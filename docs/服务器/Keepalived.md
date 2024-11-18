# Keepalived

参考：

[Keepalived之——Keepalived + Nginx 实现高可用 Web 负载均衡](https://blog.csdn.net/l1028386804/article/details/72801492)



## 一、下载并安装  Keepalived

下载地址：http://www.keepalived.org/download.html

1. 下载到 `/usr/local/src` 目录中

   ``` shell
   cd /usr/local/src
   sudo wget https://www.keepalived.org/software/keepalived-2.0.20.tar.gz
   ```

2. 解压安装

   ``` shell
   # 1. 源码安装
   tar -zxvf keepalived-2.0.20.tar.gz
   cd keepalived-2.0.20
   ./configure --prefix=/usr/local/keepalived
   make && make install
   
   # 2.yum 安装
   yum install keepalived.x86_64
   ```

3. 如果是用的源码安装，需要做一些工作复制默认配置文件到默认路径

   ``` shell
   mkdir /etc/keepalived
   cp /usr/local/keepalived/etc/keepalived/keepalived.conf /etc/keepalived/
   ```

   复制 `keepalived` 服务脚本到默认的地址

   ``` shell
   cp /usr/local/keepalived/etc/rc.d/init.d/keepalived /etc/init.d/
   cp /usr/local/keepalived/etc/sysconfig/keepalived /etc/sysconfig/
   ln -s /usr/local/sbin/keepalived /usr/sbin/
   ln -s /usr/local/keepalived/sbin/keepalived /sbin/
   ```

4. 把 `Keepalived` 安装成 `linux` 服务

   ``` shell
   chkconfig keepalived on
   ```

## 二、修改配置文件

### 1、Nginx 的 master  节点配置文件（192.168.99.100:8081）

``` shell
vi /etc/keepalived/keepalived.conf
```

