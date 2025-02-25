## 挂载数据目录

1. **挂载到宿主机的目录中：**

``` shell
docker run -p 3306:3306 --name mariadb1 -v /var/lib/mysql/mariadb1:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root -d mariadb:latest

# 其中，`/var/lib/mysql/mariadb1`是宿主机中的目录，`/var/lib/mysql`是在容器内部的安装目录
```

2. **挂载到 virtualbox 共享目录（也就是 windows 主机的目录）**

   当挂载到 virtualbox 共享目录时，有时候用上面的命令创建容器后会运行失败，则可以用下面的方式来创建：

``` shell
docker run -p 3306:3306 --name mariadb3306 -v /share/mariadb3306:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root -d mariadb:latest --innodb_use_native_aio=0

# `/share/mariadb3306`  是 virtualbox 的共享目录
```

​		手动挂载 `/share` 文件夹，输入：

```shell
sudo mount -t vboxsf share  /share
```

