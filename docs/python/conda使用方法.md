## conda install 和 pip install 区别
通常我们可以使用conda和pip两种方式来下载和卸载安装包，这里说一下这两种方式使用的区别。

- conda是一种通用包管理系统，可以构建和管理任何语言的任何类型的软件，因此，它也使用于Python包。
- pip是Python官方认可的包管理器，最常用于安装在Python包索引（PyPI）上发布的包，网址https://pypi.org/。

> 即：pip是Python包的通用管理器，conda是一个与语言无关的跨平台环境管理器，对于我们用户来说，最显著的区别是pip在任何环境中安装Python包，conda安装任何环境的任何包。
> 
> 注意：Anaconda中base环境中已经集成安装好了conda和pip，所以可以使用两种方式来安装我们想要的python软件包，安装好了软件包在Scripts目录下可以找到。


## 一、管理Conda

#### 查看版本
``` bash
conda --version
```

#### 更新至最新版本
``` bash
conda update conda
```

## 二、使用conda实现环境管理

#### 创建环境
``` bash
conda create --name your-env
# 或
conda create -n your-env
```

#### 创建环境并同时安装指定包
``` bash
conda create --name your-env your-pkg
conda create --name snakes python=3.5
# 或
conda create -n your_env_name package_name python=X.X (2.7、3.6等)
```

创建python版本为：X.X，不指定时，默认安装最新Python版本。

要安装的包 ：`package_name` 根据需求下载，可不填。

虚拟环境名字为： `your_env_name`

> 注意：`your_env_name` 文件可以在 `Anaconda` 安装目录 `envs` 文件下找到。

举例：
``` bash
conda create -n myenv numpy matplotlib python=3.7
```

#### 激活环境
``` bash
conda activate your-env
```

#### 取消激活环境
``` bash
conda deactivate
```

#### 查看已经创建的环境
``` bash
conda info --envs
```

#### 完整的删除一个环境
``` bash
conda remove --name ENVNAME --all
```

#### 删除虚拟环境中的某个包
``` bash
conda remove --name your_enev_name package_name(包名)
# 或者进入激活虚拟环境后，使用命令 
conda uninstall package_name(包名)
```

#### 复制1个环境
``` bash
conda create --clone ENVNAME --name NEWENV
```

#### 将环境导出到yaml文件，用于创建新的环境
``` bash
conda env export --name ENVNAME > envname.yml
conda env create -f=/path/to/environment.yml -n your-env-name
```

#### 查看某个环境的修订版
``` bash
conda list --revisions
```

#### 将一个环境恢复到指定版本
``` bash
conda list --name ENVNAME --revisions
conda install --name ENVNAME --revision
REV_NUMBER
```

## 三、包管理

#### 查看一个未安装的包在Anaconda库中是否存在
``` bash
conda search pkg-name
```

#### 安装一个包
``` bash
conda install pkg-name
```

#### 查看刚安装的包是否存在
``` bash
conda list
```

#### 查看某个环境下的包
``` bash
conda list --name ENVNAME
```

#### 将当前环境下包的列表导出指定文件，用于创建新的环境
``` bash
conda create --name NEWENV --file pkgs.txt
```

#### 更新某个环境下的所有包
``` bash
conda update --all --name ENVNAME
```

#### 删除某个环境下的包
``` bash
conda uninstall PKGNAME --name ENVNAME
```

#### 一次安装多个包
``` bash
conda install --yes PKG1 PKG2
```

#### 安装指定版本的包
``` bash
# 在当前通道查找大于3.1.0小于3.2的包
conda search PKGNAME=3.1 "PKGNAME
[version='>=3.1.0,<3.2']"
# 使用ananconda 客户端，在所有通道下模糊查找某个包
anaconda search FUZZYNAME
# 从指定通道中安装某个包
conda install conda-forge::PKGNAME
# 安装指定版本的包
conda install PKGNAME==3.1.4
# 限定包的版本范围
conda install "PKGNAME[version='3.1.2|3.1.4']"
conda install "PKGNAME>2.5,<3.2"
```

## 四、配置管理

#### conda使用的源管理，查看
``` bash
conda config --show channels
```

#### 增加源，解决下载慢的问题
``` bash
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
```

#### 移除源
``` bash
conda config --remove channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
```

#### 清除索引缓存
``` bash
conda clean -i
```

#### 常用源
``` bash
默认源：
https://repo.anaconda.com/

清华源：
channels:
  - defaults
show_channel_urls: true
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/bioconda/
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/menpo/
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
```

#### 
``` bash

```

#### 
``` bash

```

#### 
``` bash

```

#### 
``` bash

```
