/*
检测死锁
EXEC dbo.sp_who_lock
*/
USE master
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[sp_who_lock]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[sp_who_lock]
GO

create procedure sp_who_lock
as
BEGIN
    DECLARE @spid INT,
        @bl INT,
        @intTransactionCountOnEntry INT,
        @intRowcount INT,
        @intCountProperties INT,
        @intCounter INT

    CREATE TABLE #tmp_lock_who (
        id INT IDENTITY(1,1),
        spid SMALLINT,
        bl SMALLINT
    )
 
    IF @@ERROR<>0 RETURN @@ERROR
 
    INSERT INTO #tmp_lock_who(spid, bl) 
    SELECT 0, blocked FROM (SELECT * FROM sysprocesses WHERE blocked > 0) a 
        WHERE NOT EXISTS(SELECT * FROM (SELECT * FROM sysprocesses WHERE  blocked>0 ) b WHERE a.blocked=spid)
    UNION 
    SELECT spid,blocked FROM sysprocesses WHERE  blocked>0

    IF @@ERROR<>0 RETURN @@ERROR 
    
    -- 找到临时表的记录数
    SELECT @intCountProperties = COUNT(*), @intCounter = 1 from #tmp_lock_who
 
    IF @@ERROR<>0 RETURN @@ERROR 
 
    if @intCountProperties=0
        SELECT '现在没有阻塞和死锁信息' as message

    while @intCounter <= @intCountProperties
    begin
        select @spid = spid, @bl = bl from #tmp_lock_who where Id = @intCounter 
        begin
            if @spid =0 
                SELECT '引起数据库死锁的是: '+ CAST(@bl AS VARCHAR(10)) + '进程号,其执行的SQL语法如下'
            else
                select '进程号SPID：'+ CAST(@spid AS VARCHAR(10))+ '被' + '进程号SPID：'+ CAST(@bl AS VARCHAR(10)) +'阻塞,其当前进程执行的SQL语法如下'
                DBCC INPUTBUFFER (@bl )
        end 

        set @intCounter = @intCounter + 1
    end

    drop table #tmp_lock_who

    return 0
end