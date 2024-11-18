/*
杀死锁和进程
exec p_killspid  'mlfs'
*/

USE master
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[p_killspid]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP procedure [dbo].[p_killspid]
GO

CREATE PROC p_killspid (
    @dbname VARCHAR(200) -- 要关闭进程的数据库名
)
AS
BEGIN
    DECLARE @sql  NVARCHAR(500)  
    DECLARE @spid NVARCHAR(20)

    declare #tb cursor for
        select spid=cast(spid as varchar(20)) from master..sysprocesses where dbid=db_id(@dbname)
    open #tb
    fetch next from #tb into @spid
    while @@fetch_status=0
    begin  
        exec('kill '+@spid)
        fetch next from #tb into @spid
    end  
    close #tb
    deallocate #tb
END
go

