USE [master]
GO

ALTER DATABASE $key$ SET RECOVERY SIMPLE WITH NO_WAIT
GO
ALTER DATABASE $key$ SET RECOVERY SIMPLE --简单模式
GO

USE $key$
GO

DBCC SHRINKFILE (N'$key$_log' , 1, TRUNCATEONLY)
GO
/*
这里的 DNName_Log 如果不知道在sys.database_files里是什么名字的话，可以用以下注释的语句进行查询

USE $key$
GO
SELECT file_id, name FROM sys.database_files;
GO
*/

USE [master]
GO
ALTER DATABASE $key$ SET RECOVERY FULL WITH NO_WAIT
GO
ALTER DATABASE $key$ SET RECOVERY FULL --还原为完全模式
GO

USE $key$
GO