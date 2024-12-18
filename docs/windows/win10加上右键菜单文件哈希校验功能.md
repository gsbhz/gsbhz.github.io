**Win10 加上右键菜单文件哈希校验功能**
把以下代码保存为文件 `校验文件hash.reg`
``` bash
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\*\shell\hash]
"MUIVerb"="校验文件 Hash"
"SubCommands"=""
"Icon"="PowerShell.exe"

; SHA1
[HKEY_CLASSES_ROOT\*\shell\hash\shell\01menu]
"MUIVerb"="SHA1"

[HKEY_CLASSES_ROOT\*\shell\hash\shell\01menu\command]
@="powershell -noexit get-filehash -literalpath '%1' -algorithm SHA1 | format-list"

; SHA256
[HKEY_CLASSES_ROOT\*\shell\hash\shell\02menu]
"MUIVerb"="SHA256"

[HKEY_CLASSES_ROOT\*\shell\hash\shell\02menu\command]
@="powershell -noexit get-filehash -literalpath '%1' -algorithm SHA256 | format-list"

; SHA384
[HKEY_CLASSES_ROOT\*\shell\hash\shell\03menu]
"MUIVerb"="SHA384"

[HKEY_CLASSES_ROOT\*\shell\hash\shell\03menu\command]
@="powershell -noexit get-filehash -literalpath '%1' -algorithm SHA384 | format-list"

; SHA512
[HKEY_CLASSES_ROOT\*\shell\hash\shell\04menu]
"MUIVerb"="SHA512"

[HKEY_CLASSES_ROOT\*\shell\hash\shell\04menu\command]
@="powershell -noexit get-filehash -literalpath '%1' -algorithm SHA512 | format-list"

; MACTripleDES
[HKEY_CLASSES_ROOT\*\shell\hash\shell\05menu]
"MUIVerb"="MACTripleDES"

[HKEY_CLASSES_ROOT\*\shell\hash\shell\05menu\command]
@="powershell -noexit get-filehash -literalpath '%1' -algorithm MACTripleDES | format-list"

; MD5
[HKEY_CLASSES_ROOT\*\shell\hash\shell\06menu]
"MUIVerb"="MD5"

[HKEY_CLASSES_ROOT\*\shell\hash\shell\06menu\command]
@="powershell -noexit get-filehash -literalpath '%1' -algorithm MD5 | format-list"

; RIPEMD160
[HKEY_CLASSES_ROOT\*\shell\hash\shell\07menu]
"MUIVerb"="RIPEMD160"

[HKEY_CLASSES_ROOT\*\shell\hash\shell\07menu\command]
@="powershell -noexit get-filehash -literalpath '%1' -algorithm RIPEMD160 | format-list"

; Allget-filehash -literalpath '%1' -algorithm RIPEMD160 | format-list
[HKEY_CLASSES_ROOT\*\shell\hash\shell\08menu]
"CommandFlags"=dword:00000020
"MUIVerb"="校验全部"

[HKEY_CLASSES_ROOT\*\shell\hash\shell\08menu\command]
@="powershell -noexit get-filehash -literalpath '%1' -algorithm SHA1 | format-list;get-filehash -literalpath '%1' -algorithm SHA256 | format-list;get-filehash -literalpath '%1' -algorithm SHA384 | format-list;get-filehash -literalpath '%1' -algorithm SHA512 | format-list;get-filehash -literalpath '%1' -algorithm MACTripleDES | format-list;get-filehash -literalpath '%1' -algorithm MD5 | format-list;get-filehash -literalpath '%1' -algorithm RIPEMD160 | format-list"
```

**卸载-检验文件hash**
把以下代码保存为文件 `卸载-检验文件hash.reg`
``` bash
Windows Registry Editor Version 5.00

[-HKEY_CLASSES_ROOT\*\shell\hash]
```
