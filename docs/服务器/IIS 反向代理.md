# 一、IIS 反向代理

## 1. 安装两个IIS插件：Application Request Routing(ARRv3.0)、Url-Rewite

下载地址：

[Application Request Routing(ARRv3.0)](https://www.iis.net/downloads/microsoft/application-request-routing)

[Url-Rewite](https://www.iis.net/downloads/microsoft/url-rewrite)

## 2. 配置反向代理：

安装完ARR之后IIS中功能菜单中会多出一个 `Application Request Routing Cache` 中，打开代理的功能。

 **步骤：** 
> 1. 在 `iis` 根路径下，找到 `Application Request Routing Cache`，并双击打开。
> 2. 右侧找到 `Proxy` > `Server Proxy Settings...`，点击打开。
> 3. 选中第一个选框 `Enable Proxy`，其它配置项可不用改，然后点击`应用`保存即可。

## 3. 配置 URL ReWrite 功能

在要配置URL重写站点下，双击打开`URL重写`模块。点击右侧的`添加规则`来添加新的URL重写规则。

 **步骤：** 

 **1. 点击右侧`添加规则`菜单，选择`空白规则`。** 

 **2. 匹配URL 模块中：** 

    > 1. 请求的URL：与模式匹配；
    > 2. 模式：`^(api|wwwroot)/(.*)`

 **3. 条件模块，如果不需要，可不配置。** 

 **4. 操作模块：** 

    > 1. 操作类型：重写
    > 2. 重写URL：`http://localhost:81/{R:1}/{R:2}`
    > 3. 其余默认即可，然后点击`应用`保存。

## 4. 最后会在网站根目录下生成 `web.config` 文件
``` xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <system.webServer>
        <rewrite>
            <rules>
                <rule name="testapi" stopProcessing="true">
                    <match url="^(api|wwwroot)/(.*)" />
                    <action type="Rewrite" url="http://localhost:81/{R:1}/{R:2}" />
                </rule>
            </rules>
        </rewrite>
    </system.webServer>
</configuration>
```


# 二、vue 项目地址去掉`#`的方法

## 1. vue-router 设置 history 模式
``` js
export default new Router({
  // mode: 'history', //后端支持可开
})
```

## 2. 后端配置

### Apache

``` apache
<IfModule mod_rewrite.c>
  RewriteEngine On
  RewriteBase /
  RewriteRule ^index\.html$ - [L]
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteCond %{REQUEST_FILENAME} !-d
  RewriteRule . /index.html [L]
</IfModule>
```

### nginx 配置

``` nginx
location / {
  try_files $uri $uri/ /index.html;
}
```

### IIS 配置

``` xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <system.webServer>
        <rewrite>
            <rules>
                <rule name="testapi" stopProcessing="true">
                    <match url="^(api|wwwroot)/(.*)" />
                    <action type="Rewrite" url="http://localhost:81/{R:1}/{R:2}" />
                </rule>
                <rule name="vue history mode rule" stopProcessing="true">
                    <match url="^(?!.*api|wwwroot).*$" />
                    <conditions logicalGrouping="MatchAll">
                        <add input="{REQUEST_FILENAME}" matchType="IsFile" negate="true" />
                        <add input="{REQUEST_FILENAME}" matchType="IsDirectory" negate="true" />
                    </conditions>
                    <action type="Rewrite" url="/" />
                </rule>
            </rules>
        </rewrite>
        <staticContent>
            <mimeMap fileExtension=".properties" mimeType="text/plain" />
        </staticContent>
    </system.webServer>
</configuration>

```


参考地址：
1. [使用 URL 重写 v2 和应用程序请求路由的反向代理](https://learn.microsoft.com/zh-cn/iis/extensions/url-rewrite-module/reverse-proxy-with-url-rewrite-v2-and-application-request-routing)

2. [URL 重写模块配置引用](https://learn.microsoft.com/zh-cn/iis/extensions/url-rewrite-module/url-rewrite-module-configuration-reference)