# Mariadb 主从复制

---

> 原理：
>
> 主从复制的原理也非常简单，通俗的讲就是：当对主服务器进行写的操作时，主服务器将自己的操作记录到一个二进制日志文件中，从服务器有一个心跳机制，定时的去读取主服务器的日志文件，当对比自己的日志文件有差异时，将差异部分同步更新到自己的服务器上。


##  一. 创建主从数据库服务器容器

``` shell
# 主数据库
docker run -p 3306:3306 --name mariadb3306 -v /var/lib/mysql/mariadb3306:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root --restart always -d mariadb:latest

# 从数据库
docker run -p 3307:3306 --name mariadb3307 -v /var/lib/mysql/mariadb3307:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root --restart always -d mariadb:latest
```

## 二. 配置主服务器

#### 1. 从容器中拷贝 `my.cnf` 到宿主机

```shell
sudo docker cp mariadb3306:/etc/mysql/my.cnf   /home/my.cnf
```

#### 2. 修改 `my.cnf` ，在 `[mysqld]` 节点下添加以下内容：

``` shell
[mysqld]
# * My Settings
# 主机id，不能重复
server-id=1
# 开启二进制日志
log_bin=master-bin
# 不同步mysql，information_schema，  performance_schema这几个库
binlog-ignore-db=mysql
binlog-ignore-db=information_schema
binlog-ignore-db=performance_schema
innodb_flush_log_at_trx_commit=1
binlog_format=mixed
```

#### 3. 再把 `my.cnf` 复制回容器，并覆盖 `mariadb3306:/etc/mysql/my.cnf` ，并重启容器：

``` shell
sudo docker cp /home/my.cnf   mariadb3306:/etc/mysql/my.cnf

docker restart mariadb3306
```

#### 4. 进入主服务器，并查看主服务器是否开启 `log_bin` 日志：

查看 `log_bin` 是否开启：

``` mysql
show variables like '%log_bin%';
/* 结果如下：
MariaDB [(none)]> show variables like '%log_bin%';
+---------------------------------+----------------------------------+
| Variable_name                   | Value                            |
+---------------------------------+----------------------------------+
| log_bin                         | ON                               |
| log_bin_basename                | /var/log/mysql/mariadb-bin       |
| log_bin_compress                | OFF                              |
| log_bin_compress_min_len        | 256                              |
| log_bin_index                   | /var/log/mysql/mariadb-bin.index |
| log_bin_trust_function_creators | OFF                              |
| sql_log_bin                     | ON                               |
+---------------------------------+----------------------------------+
7 rows in set (0.002 sec)
*/
```

授权用户读取 `bin` 日志：

``` mysql
GRANT replication slave ON *.* TO 'slave'@'%' IDENTIFIED BY 'salve';
/*
参数说明：
replication slave：分配复制权限
*.*：可以操作的数据库
slave：用户
'%'：可操作的服务器IP
salve：密码
*/
```

查看服务器 `bin` 日志的信息，得到服务器的 `log` 文件及其位置。

需要记录下 `File` 和 `Position` ，用于配置从服务。

``` mysql
show master status;

/*结果如下：
+--------------------+----------+--------------+----------------------------------------------+
| File               | Position | Binlog_Do_DB | Binlog_Ignore_DB                             |
+--------------------+----------+--------------+----------------------------------------------+
| mariadb-bin.000004 |      330 |              | mysql,infofrmation_schema,performance_schema |
+--------------------+----------+--------------+----------------------------------------------+
*/
```

## 三. 配置从服务器

#### 1. 修改 `my.cnf` ，在 `[mysqld]` 节点下添加以下内容：

``` shell
[mysqld]
server-id=2
relay-log-index=slave1-relay-bin.index
relay-log=slave1-relay-bin
relay_log_recovery=1
```

修改完后，需要重启 从服务器容器

#### 2. 进入从服务器，并执行以下命令：

``` mysql
stop SLAVE;

CHANGE MASTER TO
MASTER_HOST='172.18.0.2', -- 主服务器端口
MASTER_PORT=3306 , -- 主服务器对外暴露的端口
MASTER_USER='root', -- 同步账号的用户名
MASTER_PASSWORD='root', -- 密码
MASTER_LOG_FILE='mariadb-bin.000004', -- 主容器的日志地址(之前查到)
MASTER_LOG_POS=330; -- 主容器的日志位置(之前查到)

start SLAVE;
```

查看配置是否成功：

``` mysql
show slave status \G;

-- 当结果中显示有以下内容时，即可表示配置成功
/*
Slave_IO_State: Waiting for master to send event
Slave_IO_Running: Yes
Slave_SQL_Running: Yes
*/
```

#### 3. 设置从服务器为 全局只读：

``` mysql
-- 查看只读状态
show global variables like "%read_only%";

-- 设置为只读
set global read_only=1; -- 1是只读，0是读写
```

**说明：**
> 1. `read_only=1` 只读模式，不会影响 slave 同步复制的功能，所以在 slave 库中设定了 `read_only=1` 后，通过 `show slave status \G` ，命令查看 salve 状态，可以看到仍然会读取 master 上的日志，并且在 slave 库中应用日志，保证主从数据库同步一致；
> 
> 2. `read_only=1` 只读模式，可以限定**普通用户**进行数据修改的操作，但不会限定具有 **`super` 权限的用户**的数据修改操作；在 MySQL 中设置 `read_only=1` 后，普通的应用用户进行 `insert、update、delete` 等会产生数据变化的 `DML` 操作时，都会报出数据库处于只读模式**不能发生数据变化**的错误，但具有 super 权限的用户，例如在本地或远程通过 root 用户登录到数据库，还是可以进行数据变化的 `DML` 操作；

