## 一、挂载虚拟内存五个步骤：

1.查看磁盘
``` bash
df
```

2.建立2G的虚拟内存
``` bash
dd if=/dev/zero of=/tmp/mnt/CoolFlash/swapfile bs=1k count=2097152
```

3.设置为虚拟内存
``` bash
mkswap /tmp/mnt/CoolFlash/swapfile
```

4.开启虚拟内存
``` bash
swapon /tmp/mnt/CoolFlash/swapfile
```

5.设置开机启动

打开或新建 post-mount 文件，放到  /jffs/scripts/  下面,内容如下：
``` bash
#!/bin/sh
swapon /tmp/mnt/CoolFlash/swapfile
```

## 二、创建连接

ln -s /源地址 /目标地址

``` bash
# 重新挂载为读写模式
mount -o remount,rw /usbjffs

ln -sf /tmp/mnt/CoolFlash/usbjffs /usbjffs

# 文件系统重新挂载为只读模式
mount -o remount,ro /
```

## 三、安装 alist

1、安装

``` bash
# 下载
cd /mnt/media/download/

wget -O ./alist-linux-musl-arm64.tar.gz https://github.com/alist-org/alist/releases/download/v
3.37.4/alist-linux-musl-arm64.tar.gz

tar -zxvf ./alist-linux-musl-arm64.tar.gz 

# 移动到bin目录
mkdir /usbjffs/bin/alist
mv ./alist /usbjffs/bin/alist/


cd /usbjffs/bin/alist/

# 授予程序执行权限：
chmod +x alist

# 获得管理员信息 以下两个不同版本，新版本也有随机生成和手动设置
# 低于v3.25.0版本
./alist admin

# 高于v3.25.0版本
# 随机生成一个密码
./alist admin random
# 手动设置一个密码 `NEW_PASSWORD`是指你需要设置的密码
./alist admin set NEW_PASSWORD
```

2、运行程序

``` bash
# 方法1
./alist server
# 或者带参数启动服务
alist --data ./config/alist/ serve

# 方法2（推荐）
# 对于所有平台，您可以使用以下命令来静默启动、停止和重新启动。 （v3.4.0 及更高版本）
# 携带`--force-bin-dir`参数启动服务
alist start
# 通过pid停止服务
alist stop
# 通过pid重启服务
alist restart
```

3、开机自动启动

``` bash
# 打开post-mount
vi /usbjffs/scripts/post-mount.sh

/tmp/mnt/CoolFlash/usbjffs/bin/alist/alist start

# 或 延迟30秒后再启动
{
sleep 30                                                                                        n-dir
logger '开机自启动alist'                                                                        n-dir
/usbjffs/bin/alist/alist server --force-bin-dir >/usbjffs/bin/alist/start.log 2>&1
} &

```

## 四、nginx
配置文件路径：`/mnt/CoolFlash/entware/etc/nginx/nginx.conf`


## 五、挂载 jffs
1、查看`jffs`原来的挂载信息
``` bash
df -h
---
Filesystem                Size      Used Available Use% Mounted on
ubi:rootfs_ubifs         77.2M     68.1M      9.0M  88% /
devtmpfs                207.9M         0    207.9M   0% /dev
tmpfs                   208.0M    664.0K    207.4M   0% /var
tmpfs                   208.0M     25.3M    182.8M  12% /tmp/mnt
mtd:bootfs                4.4M      3.3M      1.1M  75% /bootfs
tmpfs                   208.0M     25.3M    182.8M  12% /tmp/mnt
mtd:data                  8.0M    608.0K      7.4M   7% /data
tmpfs                   208.0M     25.3M    182.8M  12% /tmp
/dev/mtdblock9           28.7G      2.1G     25.1G   8% /jffs
/dev/sda1                28.7G      2.1G     25.1G   8% /tmp/mnt/CoolFlash
/dev/sdb                232.9G    146.2G     86.6G  63% /tmp/mnt/media
```
看到倒数第3行，记录下来，以备以后恢复时用。

2、手动实现U盘挂载`jffs`
``` bash
# 先卸载jffs分区
umount -l /jffs

# 在U盘中创建目录
mkdir /mnt/CoolFlash/.usbjffs

# 将jffs分区里的所有文件复制到U盘.usbjffs
cp -a /jffs/ /tmp/mnt/CoolFlash/.usbjffs

# 用刚才创建的文件夹替换/jffs
mount -o rbind /tmp/mnt/CoolFlash/.usbjffs/jffs /jffs
```

然后修改`/mnt/CollFlash/usbjffs/scripts/post-mount.sh`文件，增加下面的语句
``` bash
umount -l /jffs
mount -o rbind /tmp/mnt/CoolFlash/.usbjffs/jffs /jffs
```

3、手动恢复原始`jffs`挂载方式
``` bash
# 卸载jffs分区
umount -l /jffs

# 把U盘.usbjffs中的文件复制到原目录中
cp -a /tmp/mnt/CoolFlash/.usbjffs/ /jffs

# 用原始的jffs挂载文件系统/dev//dev/mtdblock9 挂载 jffs
mount -t jffs2 -o rw,noatime /dev//dev/mtdblock9 /jffs
```

## 五、开机启动顺序
`/jffs/scripts`中的启动文件执行顺序：
开关机时，只执行了这三个文件，其它的没有执行
> post-mount
> services-stop
> unmount

## 六、ShellCrash
1、手动启动
``` bash
# 启动
/jffs/ShellCrash/start.sh start

# 查看菜单
/jffs/ShellCrash/menu.sh

# 添加环境变量
[ -w ~/.bashrc ] && profile=~/.bashrc
[ -w /etc/profile ] && profile=/etc/profile
        
cd /jffs/ShellCrash
CRASHDIR=$(cd $(dirname $0);pwd)

sed -i "/alias crash/d" $profile
sed -i "/alias clash/d" $profile
sed -i "/export CRASHDIR/d" $profile
echo "alias crash=\"$CRASHDIR/menu.sh\"" >>$profile
echo "alias clash=\"$CRASHDIR/menu.sh\"" >>$profile
echo "export CRASHDIR=\"$CRASHDIR\"" >>$profile
```

2、自动启动
修改`/mnt/CollFlash/usbjffs/scripts/post-mount.sh`文件，增加下面的语句
``` bash
{
sleep 60 && /jffs/ShellCrash/start.sh start
} &
```