--Disk usage - datafiles
SELECT @dbsize = SUM(convert(bigint,case when type = 0 then size else 0 end)) 
      ,@logsize = SUM(convert(bigint,case when type = 1 then size else 0 end)) 
      ,@ftsize = SUM(convert(bigint,case when type = 4 then size else 0 end)) 
FROM sys.database_files

SELECT @reservedpages = SUM(a.total_pages) 
       ,@usedpages = SUM(a.used_pages) 
       ,@pages = SUM(CASE 
                        WHEN it.internal_type IN (202,204) THEN 0 
                        WHEN a.type != 1 THEN a.used_pages 
                        WHEN p.index_id &lt; 2 THEN a.data_pages 
                        ELSE 0 
                     END) 
FROM sys.partitions p  
JOIN sys.allocation_units a ON p.partition_id = a.container_id 
LEFT JOIN sys.internal_tables it ON p.object_id = it.object_id 

SELECT 
        @dbsize as ''dbsize'',
        @logsize as ''logsize'',
        @ftsize as ''ftsize'',
        @reservedpages as ''reservedpages'',
        @usedpages as ''usedpages'',
        @pages as ''pages''