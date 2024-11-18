常见的加壳工具：

> 1. DotFuscator，官方自带，据说免费版混淆程度不高
> 2. Virbox Protector，很好很优秀，但是收费
> 3. NET Reactor，可能会被识别为病毒
> 4. Obfuscar，开源，可以用dotnet tool或项目构建的方式进行使用

## Obfuscar 使用方法：

### 方式一：nuget安装（推荐，这种方式可以针对性下载各.net版本对应工具包）

1、在项目中使用`nuget`安装`obfuscar`
2、在项目根目录下找到`packages\Obfuscar.2.2.38\tools`，将`Obfuscar.Console.exe`拷到要加密文件的文件夹中
3、新建一个`Obfuscar.xml`文件放到相同目录下，内容如下：

``` xml
<?xml version='1.0'?>
<Obfuscator>
  <Var name="InPath" value="." />
  <Var name="OutPath" value=".\Obfuscar" />
  <Var name="KeepPublicApi" value="true" />
  <Var name="HidePrivateApi" value="true" />
  <Var name="HideStrings" value="true" />
  <Var name="UseUnicodeNames" value="true" />
  <Var name="ReuseNames" value="true" />
  <Var name="RenameFields" value="true" />
  <Var name="RegenerateDebugInfo" value="true" />

  <Module file="$(InPath)\Logic.dll" />

</Obfuscator>
```

其中 `Logic.dll` 是要加密的类库。

4、用命令提示符cmd进入到目录下（可以在cmd里用cd指令跳转，也可以直接打开目标文件夹，然后在上方的文件路径那里直接替换成cmd后enter）
5、执行`>Obfuscar.Console.exe Obfuscar.xml`
6、在生成的`Obfuscar`文件夹中可以找到被加壳后的同名`Logic.dll`

上述得到的`Logic.dll`即可被其他项目直接引用，加密后类似：


### 方式二：dotnet tool（.net 6）

1、新建一个`Obfuscar.xml`文件放到类库所在目录，内容如下：

``` xml
<?xml version='1.0'?>
<Obfuscator>
  <Var name="InPath" value="." />
  <Var name="OutPath" value=".\Obfuscar" />
  <Var name="KeepPublicApi" value="true" />
  <Var name="HidePrivateApi" value="true" />
  <Var name="HideStrings" value="false" />
  <Var name="UseUnicodeNames" value="true" />
  <Var name="ReuseNames" value="true" />
  <Var name="RenameFields" value="true" />
  <Var name="RegenerateDebugInfo" value="true" />
  <Module file="$(InPath)\PlanManager.dll" />
  <Module file="$(InPath)\MapManager.dll" />

  <AssemblySearchPath path="C:\Program Files\dotnet\shared\Microsoft.WindowsDesktop.App\6.0.9\" />
  <AssemblySearchPath path="C:\Program Files\dotnet\shared\Microsoft.NETCore.App\6.0.9\" />
</Obfuscator>
```
其中，`Module`对应填入想要加壳的类库，可以添加多行，`AssemblySearchPath`根据自己 .net 的路径进行配置。

2、在 cmd 中进入到上述目录中，执行命令：`dotnet tool install --global Obfuscar.GlobalTool`

3、在 cmd 中执行命令：`obfuscar.console Obfuscar.xml`

4、在上述目录中找到自动生成的`Obfuscar`文件夹，加壳后的类库就存放在里面，拷贝出来即可使用。

> .net6的带WebAPI的exe好像加壳失败，待测试。

### 方式三：项目构建

1、在 `csproj` 项目文件中添加安装`Obfuscar`的代码：

``` xml
<ItemGroup>
    <PackageReference Include="Obfuscar" Version="2.2.33">
        <PrivateAssets>all</PrivateAssets>
        <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
    </PackageReference>
</ItemGroup>
```

2、在项目中添加一个`Obfuscar.xml`文件，内容跟方式一的类似，再在`csproj`项目文件中设置更新

``` xml
<ItemGroup>
    <None Update="Obfuscar.xml">
        <CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory>
    </None>
</ItemGroup>
```
3、在`csproj`项目文件中设置自动构建

``` xml
<Target Name="ObfuscarTask" AfterTargets="AfterBuild">
    <PropertyGroup>
        <ObfuscateCommand>$(Obfuscar) "Obfuscar.xml"</ObfuscateCommand>
    </PropertyGroup>
    <Exec WorkingDirectory="$(OutputPath)" Command="$(ObfuscateCommand)" />
</Target>
```
> 这种方式还没测试过，待测试
