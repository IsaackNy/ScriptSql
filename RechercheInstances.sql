/************************************************************************
 Nom du fichier:  RechercheInstances.sql
 Fonction:        Ce script retourne la liste des instances du serveur.
 Date:            2013-02-08
 Proposé par:     I. Nyobe
*************************************************************************/
Set NoCount On
	Declare @CurrID int,@ExistValue int, @MaxID int, @SQL nvarchar(1000)

	Declare @TCPPorts Table (PortType nvarchar(180), Port int)

	Declare @SQLInstances Table (InstanceID int identity(1, 1) not null primary key,
                                          InstName nvarchar(180),
                                          Folder nvarchar(100),
                                          StaticPort int null,
                                          DynamicPort int null,
                                          Platform int null);

	Declare @Plat Table (Id int,Name varchar(180),InternalValue varchar(50), Charactervalue varchar (50))

	Declare @Platform varchar(100)

    Declare @Keyexist Table (Keyexist int)


	Insert into @Plat exec xp_msver platform
	select @Platform = (select 1 from @plat where charactervalue like '%86%')

	If @Platform is NULL 
    Begin 
		Insert Into @SQLInstances (InstName, Folder)
		Exec xp_regenumvalues N'HKEY_LOCAL_MACHINE',
                             N'SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL';
		Update @SQLInstances set Platform=64 
	End
	else
	Begin
	  Insert Into @SQLInstances (InstName, Folder)
	  Exec xp_regenumvalues N'HKEY_LOCAL_MACHINE',
                             N'SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL';
     Update @SQLInstances Set Platform=32
   End   
 

   Insert into @Keyexist
   Exec xp_regread'HKEY_LOCAL_MACHINE',
                              N'SOFTWARE\Wow6432Node\Microsoft\Microsoft SQL Server\Instance Names\SQL';
   select @ExistValue= Keyexist from @Keyexist
   If @ExistValue=1
   Insert Into @SQLInstances (InstName, Folder)
   Exec xp_regenumvalues N'HKEY_LOCAL_MACHINE',
                              N'SOFTWARE\Wow6432Node\Microsoft\Microsoft SQL Server\Instance Names\SQL';
   Update @SQLInstances Set Platform =32 where Platform is NULL
 

   Select @MaxID = MAX(InstanceID), @CurrID = 1
   From @SQLInstances nolock
   While @CurrID <= @MaxID
   Begin
      Delete From @TCPPorts
      Select @SQL = 'Exec xp_instance_regread N''HKEY_LOCAL_MACHINE'',
                              N''SOFTWARE\Microsoft\\Microsoft SQL Server\' + Folder + '\MSSQLServer\SuperSocketNetLib\Tcp\IPAll'',
                              N''TCPDynamicPorts'''
      From @SQLInstances
      Where InstanceID = @CurrID
      
      Insert Into @TCPPorts
      Exec sp_executesql @SQL
      
      Select @SQL = 'Exec xp_instance_regread N''HKEY_LOCAL_MACHINE'',
                              N''SOFTWARE\Microsoft\\Microsoft SQL Server\' + Folder + '\MSSQLServer\SuperSocketNetLib\Tcp\IPAll'',
                              N''TCPPort'''
      From @SQLInstances
      Where InstanceID = @CurrID
      
 

      Insert Into @TCPPorts
      Exec sp_executesql @SQL
 

      Select @SQL = 'Exec xp_instance_regread N''HKEY_LOCAL_MACHINE'',
                              N''SOFTWARE\Wow6432Node\Microsoft\\Microsoft SQL Server\' + Folder + '\MSSQLServer\SuperSocketNetLib\Tcp\IPAll'',
                              N''TCPDynamicPorts'''
      From @SQLInstances
      Where InstanceID = @CurrID
      
      Insert Into @TCPPorts
      Exec sp_executesql @SQL
      
      Select @SQL = 'Exec xp_instance_regread N''HKEY_LOCAL_MACHINE'',
                              N''SOFTWARE\Wow6432Node\Microsoft\\Microsoft SQL Server\' + Folder + '\MSSQLServer\SuperSocketNetLib\Tcp\IPAll'',
                              N''TCPPort'''
      From @SQLInstances nolock
      Where InstanceID = @CurrID
      
 

      Insert Into @TCPPorts
      Exec sp_executesql @SQL
 

      
      Update SI
      Set StaticPort = P.Port,
            DynamicPort = DP.Port
      From @SQLInstances SI 
      Inner Join @TCPPorts DP On DP.PortType = 'TCPDynamicPorts'
      Inner Join @TCPPorts P On P.PortType = 'TCPPort'
      Where InstanceID = @CurrID;
      
      Set @CurrID = @CurrID + 1
   End
 

 Select serverproperty('ComputerNamePhysicalNetBIOS') as ServerName, 
    InstName, StaticPort, DynamicPort,Platform
 From @SQLInstances nolock
    order by InstName

 Set NoCount Off

 /***********************************************************************/
