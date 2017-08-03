--snapshots.os_wait_stats
SELECT 
  LEFT(latch_class,45) as latch_class,
  waiting_requests_count,
  wait_time_ms
FROM sys.dm_os_latch_stats 
WHERE waiting_requests_count > 0 OR wait_time_ms > 0