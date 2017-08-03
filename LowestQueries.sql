
/*******************************************************/
SELECT TOP 12
    total_worker_time/execution_count AS Avg_CPU_Time
        ,execution_count
        ,total_elapsed_time/execution_count as AVG_Run_Time
        ,(SELECT
              SUBSTRING(text,statement_start_offset/2,(CASE
                                                         WHEN statement_end_offset = -1 THEN LEN(CONVERT(nvarchar(max), text)) * 2 
                                                         ELSE statement_end_offset 
                                                       END -statement_start_offset)/2
                       ) FROM sys.dm_exec_sql_text(sql_handle)
         ) AS query_text 
FROM sys.dm_exec_query_stats 
ORDER BY Avg_CPU_Time DESC
/*******************************************************/

SELECT TOP 12 obj.name, max_logical_reads, max_elapsed_time
FROM sys.dm_exec_query_stats A
CROSS APPLY sys.dm_exec_sql_text(sql_handle) hnd
INNER JOIN sys.sysobjects obj on hnd.objectid = obj.id
ORDER BY max_logical_reads DESC