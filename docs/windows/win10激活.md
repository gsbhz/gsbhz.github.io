### 一. 解决 0x803F7001在运行Microsoft Windows非核心版本的计算机错误
然后再注册表下输入地址 `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform\` ，在该目录下找到 `SkipRearm`，双击打开后，将数值 `0` 改为 `1`，确认保存后重新启动电脑即可

### 二.激活win10

[密钥管理服务 (KMS) 客户端激活和产品密钥](https://learn.microsoft.com/zh-cn/windows-server/get-started/kms-client-activation-keys?tabs=server2025%2Cwindows1110ltsc%2Cversion1803%2Cwindows81)

> `kms.03k.org` 这个地址能激活，网上找的有些地址激活不了。
> 
> Windows 全版本激活码：https://github.com/xiaozhu2021/key

`kms` 激活示例：
``` bash
slmgr /ipk NPPR9-FWDCX-D2C8J-H872K-2YT43
slmgr /skms kms.03k.org 
slmgr /ato
```

可用`kms`地址：
``` bash
# 下方地址可能会有重复，自己看看
kms.03k.org
kms.chinancce.com
kms.lotro.cc
cy2617.jios.org
kms.shuax.com
kms.luody.info
kms.cangshui.net
kms.library.hk
xykz.f3322.org
kms.binye.xyz
kms.tttal.com
kms.v0v.bid
kms.moeclub.org
amrice.top
kms.digiboy.ir
kms.lolico.moe
kms.90zm.xyz
kms.cangshui.net
kms.03k.org
kms.myftp.org
zh.us.to
kms.chinancce.com
kms.digiboy.ir
kms.luody.info
kms.mrxn.net
kms8.MSGuides.com
xykz.f3322.org
kms.bige0.com
kms.shuax.com
kms.lotro.cc
www.ddddg.cn
cy2617.jios.org
enter.picp.net
kms.qkeke.com
```
