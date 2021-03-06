select distinct ps.Name AS PartitionScheme, pf.name AS PartitionFunction,fg.name AS FileGroupName, rv.value AS PartitionFunctionValue
    from sys.indexes i  
    join sys.partitions p ON i.object_id=p.object_id AND i.index_id=p.index_id  
    join sys.partition_schemes ps on ps.data_space_id = i.data_space_id  
    join sys.partition_functions pf on pf.function_id = ps.function_id  
    left join sys.partition_range_values rv on rv.function_id = pf.function_id AND rv.boundary_id = p.partition_number
    join sys.allocation_units au  ON au.container_id = p.hobt_id   
    join sys.filegroups fg  ON fg.data_space_id = au.data_space_id 
