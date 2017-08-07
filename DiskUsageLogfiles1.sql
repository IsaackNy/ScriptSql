--Disk_usage - log files
DECLARE @tran_log_space_usage as table( database_name sysname, log_size_mb numeric(19,7), log_space_used numeric(8,6), status bit)
INSERT INTO @tran_log_space_usage 
EXEC('DBCC SQLPERF (LOGSPACE) WITH NO_INFOMSGS');

SELECT 
    database_name,
    log_size_mb,
    log_space_used,
    status    
FROM @tran_log_space_usage


　

-- Commande 　
DBCC SQLPERF (LOGSPACE) WITH NO_INFOMSGS
