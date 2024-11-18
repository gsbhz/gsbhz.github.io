> `C#` 调用命令行编译项目一般是用 `devenv` 和 `MSBuild` 编译解决方案和项目。

## 具体用法如下：

### `devenv` 编译解决方案和项目
``` shell
> devenv Solution1.sln /Rebuild
> 
> devenv ConsoleApplication1.csproj /Rebuild
```

### `MSBuild` 编译解决方案和项目

``` shell
> MSBuild Solution1.sln /t:Rebuild /p:Configuration=Release
> 
> MSBuild ConsoleApplication1.csproj /t:Rebuild /p:Configuration=Debug
```
---
**注：**
> `devenv` 路径如下： `D:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\IDE\`
> 
> `msbuild` 路径如下： `C:\Windows\Microsoft.NET\Framework\v4.0.30319`