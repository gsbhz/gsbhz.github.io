-- 方法一
SELECT
    Name,--存储过程名字
    Definition --存储过程内容
FROM sys.sql_modules AS m 
    INNER JOIN sys.all_objects AS o ON m.object_id = o.object_id
WHERE o.[type] = 'P' AND m.definition LIKE '%$key$%'

-- 方法二
SELECT b.name, [text] 
FROM dbo.syscomments a, dbo.sysobjects b
WHERE a.id = b.id AND b.xtype = 'p' AND a.[text] LIKE '%$key$%'
