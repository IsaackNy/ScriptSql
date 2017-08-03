--Disk_usage - log files
INSERT INTO @tran_log_space_usage 
EXEC(''DBCC SQLPERF (LOGSPACE) WITH NO_INFOMSGS'');
SELECT 
    database_name,
    log_size_mb,
    log_space_used,
    status    
FROM @tran_log_space_usage