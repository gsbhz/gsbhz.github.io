--查询整个数据库中某个特定值所在的表和字段SQL
declare @str varchar(100)
set @str='$value$'  --要搜索的字符串
 
declare @s varchar(8000)
declare tb cursor local for
select s='if exists(select 1 from ['+b.name+'] where ['+a.name+'] like ''%'+@str+'%'')
print ''SELECT * FROM '+b.name+' WHERE '+a.name+' = '''''+ @str +''''' '''
from syscolumns a join sysobjects b on a.id=b.id
where b.xtype='U' and a.status>=0 and a.xusertype in(175, 239, 231, 167, 106)
 
open tb
	fetch next from tb into @s
	
	while @@fetch_status=0
	begin
		exec(@s)
		fetch next from tb into @s
	end
close tb
 
deallocate tb