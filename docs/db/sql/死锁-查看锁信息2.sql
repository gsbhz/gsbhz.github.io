-- 查看锁信息
CREATE table #t(req_spid int,obj_name sysname)

declare 
    @s nvarchar(4000)
    ,@rid int,
    @dbname sysname,
    @id int,
    @objname sysname

declare tb cursor for 
    select distinct req_spid,dbname=db_name(rsc_dbid),rsc_objid
    from master..syslockinfo where rsc_type in(4,5)
open tb
fetch next from tb into @rid,@dbname,@id
while @@fetch_status=0
begin
    set @s='select @objname=name from ['+@dbname+']..sysobjects where id=@id'
    exec sp_executesql @s,N'@objname sysname out,@id int',@objname out,@id
    insert into #t values(@rid,@objname)
    fetch next from tb into @rid,@dbname,@id
end
close tb
deallocate tb

select 进程id=a.req_spid
    ,数据库=db_name(rsc_dbid)
    ,类型=case rsc_type when 1 then 'NULL 资源（未使用）'
        when 2 then '数据库'
        when 3 then '文件'
        when 4 then '索引'
        when 5 then '表'
        when 6 then '页'
        when 7 then '键'
        when 8 then '扩展盘区'
        when 9 then 'RID（行 ID)'
        when 10 then '应用程序'
    end
    ,对象id=rsc_objid
    ,对象名=b.obj_name
    ,rsc_indid
 from master..syslockinfo a left join #t b on a.req_spid=b.req_spid

go
drop table #t