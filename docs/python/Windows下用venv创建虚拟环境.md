## 1.创建一个虚拟环境
``` bash
D:\>mkdir my_venv
D:\>cd my_venv
D:\my_venv>python -m venv venv1
```

命令python -m venv venv1,创建一个venv1的虚拟环境，生成目录形式如下：

```
venv1
  │  pyvenv.cfg
  │  
  ├─Include
  ├─Lib
  └─Scripts
```

## 2.启用虚拟环境
``` bash
D:\my_venv>venv1\Scripts\activate.bat
(venv1) D:\my_venv
```

## 3.pip在虚拟环境安装模块
首先查看目前虚拟环境已有的模块：
``` bash
(venv1) D:\my_venv>pip list
pip (8.1.1)
setuptools (20.10.1)
You are using pip version 8.1.1, however version 8.1.2 is available.
You should consider upgrading via the 'python -m pip install --upgrade pip' command.
```

提示pip有新版本，按提示python -m pip install --upgrade pip 命令更新就好，千万别用pip install --upgrade pip，这样会破坏pip

## 4.退出虚拟环境

``` bash
(venv1) D:\my_venv>test\Scripts\deactivate.bat
D:\my_venv>
```