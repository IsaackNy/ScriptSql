--ProcessAndMemory
SELECT 
    memory_node_id, 
    virtual_address_space_reserved_kb, 
    virtual_address_space_committed_kb, 
    locked_page_allocations_kb, 
    single_pages_kb, 
    multi_pages_kb, 
    shared_memory_reserved_kb, 
    shared_memory_committed_kb
FROM sys.dm_os_memory_nodes