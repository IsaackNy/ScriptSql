--Server Activity – DMV Snapshots
SELECT 
    LEFT (wait_type, 45) AS wait_type, 
    SUM (waiting_tasks_count) AS waiting_tasks_count, 
    SUM (wait_time_ms) AS wait_time_ms, 
    SUM (signal_wait_time_ms) AS signal_wait_time_ms
FROM
 (SELECT 
    LEFT (wait_type, 45) AS wait_type, 
    waiting_tasks_count, 
    wait_time_ms,  
    signal_wait_time_ms
FROM sys.dm_os_wait_stats 
WHERE waiting_tasks_count > 0 OR wait_time_ms > 0 OR signal_wait_time_ms > 0
UNION ALL 
    SELECT 
        LEFT (wait_type, 45) AS wait_type, 
        1 AS waiting_tasks_count, 
        wait_duration_ms AS wait_time_ms, 
        0 AS signal_wait_time_ms
    FROM sys.dm_os_waiting_tasks
    WHERE wait_duration_ms &gt; 60000
) AS merged_wait_stats
GROUP BY wait_type