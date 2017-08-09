USE DGP0ENT1
GO
CREATE USER [ENT1] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[ENT1]
GO
CREATE SCHEMA [ENT1] AUTHORIZATION ENT1;
GO
-- Transfer objets schéma PRO1 vers ENT1
DECLARE @name        VARCHAR(128),
        @instruction NVARCHAR(256)

DECLARE db_cursor CURSOR FOR  
  Select so.name  
  from sysobjects so join sysusers su 
  on so.uid = su.uid  
  and su.name ='PRO1'
  and xtype in ('U','V','P','FN' ) 
  order by so.crdate

OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @name   

WHILE @@FETCH_STATUS = 0   
BEGIN          
       SET @instruction =  ' ALTER SCHEMA ENT1 TRANSFER PRO1.' + @name +';'
       IF EXISTS (SELECT  * FROM sys.objects WHERE SCHEMA_NAME(schema_id) =  'PRO1'                )
           EXEC sp_executesql @instruction

       FETCH NEXT FROM db_cursor INTO @name   
END   
CLOSE db_cursor   
DEALLOCATE db_cursor
GO


USE [DGP0ENT1]
GO
GRANT DELETE,EXECUTE,INSERT,SELECT,UPDATE on schema::ENT1 to [GPD_USER];
GO
GRANT DELETE,EXECUTE,INSERT,SELECT,UPDATE on schema::ENT1 to [MVTDEV\ST-SQL-FID-DGP0ENT1-GP_USER_READ];
GO
