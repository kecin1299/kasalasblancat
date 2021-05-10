IF OBJECT_ID('TempDB..#RestoreHeaderOnlyData') IS NOT NULL
DROP TABLE #RestoreHeaderOnlyData
GO

CREATE TABLE #RestoreHeaderOnlyData( 
BackupName NVARCHAR(128) 
,BackupDescription NVARCHAR(255) 
,BackupType smallint 
,ExpirationDate datetime 
,Compressed tinyint 
,Position smallint 
,DeviceType tinyint 
,UserName NVARCHAR(128) 
,ServerName NVARCHAR(128) 
,DatabaseName NVARCHAR(128) 
,DatabaseVersion INT 
,DatabaseCreationDate datetime 
,BackupSize numeric(20,0) 
,FirstLSN numeric(25,0) 
,LastLSN numeric(25,0) 
,CheckpointLSN numeric(25,0) 
,DatabaseBackupLSN numeric(25,0) 
,BackupStartDate datetime 
,BackupFinishDate datetime 
,SortOrder smallint 
,CodePage smallint 
,UnicodeLocaleId INT 
,UnicodeComparisonStyle INT 
,CompatibilityLevel tinyint 
,SoftwareVendorId INT 
,SoftwareVersionMajor INT 
,SoftwareVersionMinor INT 
,SoftwareVersionBuild INT 
,MachineName NVARCHAR(128) 
,Flags INT 
,BindingID uniqueidentifier 
,RecoveryForkID uniqueidentifier 
,Collation NVARCHAR(128) 
,FamilyGUID uniqueidentifier 
,HasBulkLoggedData INT 
,IsSnapshot INT 
,IsReadOnly INT 
,IsSingleUser INT 
,HasBackupChecksums INT 
,IsDamaged INT 
,BeginsLogChain INT 
,HasIncompleteMetaData INT 
,IsForceOffline INT 
,IsCopyOnly INT 
,FirstRecoveryForkID uniqueidentifier 
,ForkPointLSN numeric(25,0) 
,RecoveryModel NVARCHAR(128) 
,DifferentialBaseLSN numeric(25,0) 
,DifferentialBaseGUID uniqueidentifier 
,BackupTypeDescription NVARCHAR(128) 
,BackupSetGUID uniqueidentifier 
,CompressedBackupSize BIGINT
,Containment INT
,KeyAlgorithm varchar(500)
,EncryptorThumbprint varchar(500)
,EncryptorType varchar(500)
)

DECLARE @AdventureWorks2019 smallint
SELECT @AdventureWorks2019 = MAX(Position)
FROM #RestoreHeaderOnlyData
WHERE BackupName = 'AdventureWorks2019 - Full Backup'

RESTORE DATABASE AdventureWorks2019
FROM AdventureWorks2019
WITH FILE = @AdventureWorks2019,
	MOVE N'Adventure_Works2019_1' TO N'D:\Base restaurada\AdventureWorks2019_1.mdf'
	MOVE N'Adventure_Works2019_2' TO N'D:\Base restaurada\AdventureWorks2019_2.mdf'
	MOVE N'Adventure_Works2019_3' TO N'D:\Base restaurada\AdventureWorks2019_3.mdf'
	MOVE N'Adventure_Works2019_4' TO N'D:\Base restaurada\AdventureWorks2019_4.mdf'
NOUNLOAD, REPLACE, STATS = 10
GO

EXEC sp_addumpdevice 'disk', 'AdventureWorks2019_2',
'D:\Base restaurada\AdventureWorks2019_2.bak';
GO

BACKUP DATABASE AdventureWorks2019
TO AdventureWorks2019_2
	WITH FORMAT, INIT, NAME = N' AdventureWorks2019 - Full Backup';
	GO

DECLARE @AwExamenBDII VARCHAR(100)
SET @AwExamenBDII = N'AdventureWorks2019 - Full Backup' +
FORMAT (GETDATE(), '2005_103000');

BACKUP DATABASE AdventureWorks2019
TO AdventureWorks2019_2
WITH NOFORMAT, NOINIT, NAME = @AwExamenBDII,
SKIP, NOREWIND, NOUNLOAD, STATS = 10
GO

SELECT BulkColumn
FROM OPENROWSET (BULK'D:\ExamenBaseDeDatos\dataMay-10-2021.json', SINGLE_CLOB)
as j;

SELECT value
FROM OPENROWSET (BULK 'D:\ExamenBaseDeDatos\dataMay-10-2021.json', SINGLE_CLOB)
as j
CROSS APPLY OPENJSON(BulkColumn)

CREATE PROCEDURE Person.ContactType
AS
DECLARE @Importacion VARCHAR(100)

SET @Importacion = CAST (ROUND (RAND()*1000,0 )AS VARCHAR(100))

INSERT INTO [Person].[ContactType]
			([FirstName],
			 [LastName]
			 )
			 VALUES
					('Cliente'+ @Importacion
					 ,'Apellido' + @Importacion)

GO