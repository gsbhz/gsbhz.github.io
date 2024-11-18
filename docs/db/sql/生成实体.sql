--SELECT * FROM sys.syscolumns WHERE id = OBJECT_ID('CompanyBasicInfo')
--SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('CompanyBasicInfo')
--SELECT * FROM sys.systypes

DECLARE
    @tableName VARCHAR(50), -- 表名
    @column VARCHAR(MAX) -- 字段
SET @tableName = '$tableName$'
SET @column = ''
$CURSOR$

/*********** 查询所有字段 ***********/

PRINT '*********** 查询所有字段 ***********'

--SELECT name + ', ' FROM sys.columns WHERE object_id = OBJECT_ID(@tableName) FOR XML PATH('');
SELECT @column = @column + name + ', ' FROM sys.columns WHERE object_id = OBJECT_ID(@tableName);
SET @column = LEFT(@column, LEN(@column) - 1);

PRINT @column;
PRINT CHAR(10)


/*********** 实体类 ***********/

PRINT '*********** 实体类 ***********'

DECLARE
    @model VARCHAR(MAX), -- 生成的实体代码  
    @tomodel VARCHAR(MAX), -- 转换为实体
    @params VARCHAR(MAX), -- SqlParameter
    @paramsValue VARCHAR(MAX) -- params.Value
SET @model = ''
SET @tomodel = ''
SET @params = ''
SET @paramsValue = ''
SELECT @model = @model +
'/// <summary>' + CHAR(13) + CHAR(10) +
'/// ' + ISNULL(CAST(p.value AS VARCHAR(MAX)), '') + CHAR(13) + CHAR(10) +
'/// </summary>' + CHAR(13) + CHAR(10) +
'public '+ CASE t.name WHEN 'varchar' THEN 'string' WHEN 'nvarchar' THEN 'string' WHEN 'datetime' THEN 'DateTime' WHEN 'tinyint' THEN 'int' ELSE t.name END + ' ' + c.name + ' {get;set;}' + CHAR(10) + CHAR(13),
@tomodel = @tomodel + ''+ c.name +' = m.'+ c.name +',' + CHAR(10),
@params = @params + '   new SqlParameter("'+ c.name +'", SqlDbType.'+ CASE t.name WHEN 'varchar' THEN 'VarChar' WHEN 'datetime' THEN 'DateTime' ELSE (UPPER(LEFT(t.name, 1)) + RIGHT(t.name, LEN(t.name) - 1)) END +'),' + CHAR(10),
@paramsValue = @paramsValue + 'paras['+ CAST((c.column_id - 2) AS varchar) +'].Value = m.'+ c.name +';' + CHAR(10)
FROM sys.columns c
INNER JOIN sys.systypes t ON t.xtype = c.system_type_id AND t.status = 0
LEFT JOIN sys.extended_properties p ON p.major_id = c.object_id AND p.minor_id = c.column_id
WHERE c.object_id = OBJECT_ID(@tableName)
ORDER BY c.column_id ASC;

PRINT @model;
PRINT CHAR(10)


/*********** Data ***********/

PRINT '*********** Dal类 ***********'

PRINT 'public class '+ @tableName +'Dal : BaseDal<'+ @tableName +'Dal, '+ @tableName +'>' + CHAR(13) + CHAR(10) +
'{' + CHAR(13) + CHAR(10) +
 + CHAR(13) + CHAR(10) +
'}';
PRINT CHAR(10)


/*********** 对象转换 ***********/
/*
PRINT '*********** 对象转换 ***********'

PRINT 'var entity = new '+ @tableName +'
{
' + @tomodel + '
}'
PRINT CHAR(10)
*/

/*********** INSERT ***********/
PRINT '*********** INSERT ***********'
PRINT 'INSERT INTO ' + @tableName + ' ('+ @column +') VALUES (@'+ REPLACE(@column, ', ', ', @') +')'
PRINT CHAR(10)


/*********** SqlParameter ***********/
PRINT '*********** SqlParameter ***********'
PRINT 'SqlParameter[] paras = {' + CHAR(10) + 
@params +
'};'

PRINT @paramsValue
PRINT CHAR(10)
