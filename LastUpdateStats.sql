SELECT OBJECT_NAME(object_id) AS ObjectName,
    STATS_DATE(object_id, stats_id) AS StatisticsDate,
    *
FROM sys.stats