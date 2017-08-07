-- Espace total par BD
USE master
GO
SELECT      sys.databases.name,
             CONVERT(VARCHAR,SUM(size)*8/1024)+' MB' AS [Total disk space]
FROM        sys.databases 
JOIN        sys.master_files
ON          sys.databases.database_id=sys.master_files.database_id
GROUP BY    sys.databases.name
ORDER BY    sys.databases.name 

--
-- BD courante -->espace utilisé espace libre
SELECT DB_NAME() AS DbName,
name ASFileName,
size/128.0 AS CurrentSizeMB,
size/128.0 -CAST(FILEPROPERTY(name,'SpaceUsed')AS INT)/128.0 AS FreeSpaceMB 
FROM sys.database_files;


-- Espace utilisé
exec sp_spaceused


-- Generer script pour selectionner les fichiers des difféerentes BD usagers
Select 'USE ' + QUOTENAME(name) + ' SELECT name, filename from sysdatabases where dbid >5 ' from sysdatabases where dbid >5