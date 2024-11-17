# 安装 WSL2

## 一、配置

### 方法一、控制面板->程序和功能->启或关闭Windows功能；

在默认的基础上，再勾选下面4个选项：
> 1. 虚拟机平台
> 2. 适用于Linux的Windows子系统
> 3. Windows虚拟机监控程序平台
> 4. Hyper-V

开启`Hyper-V`之后，会占用大量端口，用以下命令查看保留了哪些端口：
``` bash
netsh interface ipv4 show excludedportrange protocol=tcp
```
也可停止`winnat`：
``` bash
net stop winna
```

### 方法二、在`powershell`中执行下列命令：

``` bash
# 1. 启用 适用于 Linux 的 Windwos 子系统：
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# 2. 启用 虚拟机功能：
# 安装 WSL2 之前，必须启用“虚拟机平台”可选功能
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

## 二、安装`Linux`分发版
### 1、安装
方法一、打开`Microsoft Store`，选择喜欢的`Linux`分发版并下载。
方法二、命令符自动安装 (一行命令搞定，非常方便)
``` bash
wsl --install
```
启动`ubuntu`，自动安装，设置用户名和密码
``` bash
sudo passwd root
```

### 2、将分发版本设置为`WSL 2`
``` bash
#查看刚才安装的Ubuntu-24.04的WSL的版本
wsl -l -v
 
 
# 显示结果：
#   NAME            STATE           VERSION
# * Ubuntu-24.04    Running         1

# 根据显示的结果，安装的是WSL1版本
 
#更新WSL
wsl --update
 
#设置Ubuntu-24.04的WSL版本为2
wsl --set-version Ubuntu-24.04 2
 
#设置后面安装Linux子系统的默认版本为2
wsl --set-default-version 2
```

### 3、更换ubuntu的apt安装源
``` bash
cp /etc/apt/sources.list /etc/apt/sources.list.bak

echo "deb http://mirrors.aliyun.com/ubuntu/ focal main restricted
deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted
deb http://mirrors.aliyun.com/ubuntu/ focal universe
deb http://mirrors.aliyun.com/ubuntu/ focal-updates universe
deb http://mirrors.aliyun.com/ubuntu/ focal multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-updates multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted
deb http://mirrors.aliyun.com/ubuntu/ focal-security universe
deb http://mirrors.aliyun.com/ubuntu/ focal-security multiverse">/etc/apt/sources.list
```

执行更新：
``` bash
apt update && apt upgrade -y
```

## 三、将`Linux`子系统迁移到E盘（默认的`Linux`子系统安装在`C`盘）

默认的安装位置：
 
`C:\Users\Administrator\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu24.04LTS_79rhkp1fndgsc\LocalState`

迁移的正确流程：导出 ubuntu --> 注销原来 Ubuntu --> 重新导入 D盘

在`PowerShell`里执行如下的命令程序：

``` bash
#关闭：wsl
wsl --shutdown
 
#关闭：Ubuntu-24.04
wsl -t Ubuntu-24.04
 
#首先需要有：“E:\App\wsl-images\” 文件夹，导出 “子系统Ubuntu”
wsl --export Ubuntu-24.04 E:\App\wsl-images\Ubuntu-24.04.tar
 
#注销原来的 “子系统Ubuntu”
wsl --unregister Ubuntu-24.04
 
#导入 “子系统Ubuntu” 到 “E:\App\wsl-images\Ubuntu-24.04”
wsl --import Ubuntu-24.04 E:\App\wsl-images\Ubuntu-24.04 E:\App\wsl-images\Ubuntu-24.04.tar --version 2
 
# “qwe” 就是你的Ubuntu子系统的用户名，这里是对 “新导入的子系统” 配置用户名
ubuntu2204 config --default-user qwe
```

## 四、WSL2使用xrdp实现图形桌面
### 1、安装包
先更新，再安装。一共就俩包`xfce4`和`xrdp`，都很轻量，分分钟装好。
``` bash
$ sudo apt update
$ sudo apt install -y xfce4 xrdp
```

ps：安装`xfce4`过程中会出现选择显示管理`DM`选择的提示，建议用`lightdm`。

如果错过了安装过程中出现的这个向导,那么可以在安装完成后执行下面的命令重新设置DM
``` bash
$ sudo dpkg-reconfigure lightdm
```

### 2、修改`xrdp`默认端口
由于`xrdp`安装好后默认配置使用的是和`Windows`远程桌面相同的`3389`端口，为了防止和`Windows`系统远程桌面冲突，建议修改成其他的端口
``` bash
$ sudo vim /etc/xrdp/xrdp.ini
# 修改下面这一行，将默认的3389改成其他端口即可
port=3390
```

### 3、为当前用户指定登录`session`类型
注意这一步很重要，如果不设置的话会导致后面远程桌面连接上闪退
``` bash
$ vim ~/.xsession

# 写入下面内容(就一行)
xfce4-session
```

### 4、启动`xrdp`
由于`WSL2`里面不能用`systemd`，所以需要手动启动
``` bash
$ sudo /etc/init.d/xrdp start
```

### 5、远程访问
在`Windows`系统中运行`mstsc`命令打开远程桌面连接，地址输入`localhost:3390`


## 五、使用
### 1、WSL2访问WIN10文件：
``` bash
cd /mnt
cd /mnt/d/
```

### 2、WIN10访问WSL2文件：
``` bash
\wsl.localhost\Ubuntu\test_folder
```

### 3、vscode访问WSL:

https://zhuanlan.zhihu.com/p/57882542

上面方法太慢了，选择直接在WSL里安装vscode，再用以下指令打开：（推荐）
``` bash
code --user-data-dir=~/.vscode --no-sandbox
```

### 4、Linux 环境变量配置的 6 种方法
推荐修改`~/.bashrc`
https://blog.csdn.net/FMikasa/article/details/133016423

5、WSL2 Ubuntu安装beyondcompare4：
https://blog.csdn.net/Ciellee/article/details/131313925


## 六、安装docke

1、在系统用户（`C:\Users\Administrator`）下创建一个`.wslconfig`文件。其内容如下。
``` bash
[wsl2]
memory=4GB
swap=2G
```

2、配置国内镜像映射地址
安装好后，在`Settings` -> `Docker Engine`中添加`registry-mirrors`节点配置国内镜像映射地址。

3、修改`Docker`默认镜像存储位置
``` bash
# 导出docker统镜像，最后是临时保存的位置及文件名称，文件名称固定
wsl --export docker-desktop "D:\Docker\wsl\distro\docker-desktop.tar"
wsl --export docker-desktop-data "D:\Docker\wsl\data\docker-desktop-data.tar"

# 注销现有的，名称固定
wsl --unregister docker-desktop
wsl --unregister docker-desktop-data

# 重新将镜像导入到新的地方，最后指出版本是2
wsl --import docker-desktop "D:\Docker\wsl\distro" "D:\Docker\wsl\distro\docker-desktop.tar" --version 2
wsl --import docker-desktop-data "D:\Docker\wsl\data" "D:\Docker\wsl\data\docker-desktop-data.tar" --version 2
```

4、启动`Docker Desktop for Windows`

点击“设置”按钮，启用基于`WSL2`的引擎复选框（`Use the WSL 2 based engine`）

5、在`WSL`里执行`docker`命令

这个时候在`WSL`里面执行`docker`命令还是找不到的。

在`Resources`的`WSL Integration`中设置要从哪个`WSL2`发行版中访问`Docker`，使用的是 Ubuntu

6、汉化
https://github.com/asxez/DockerDesktop-CN
