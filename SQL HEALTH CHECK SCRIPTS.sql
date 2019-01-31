-- SQL BACK UP DB
DECLARE @DBname VARCHAR(50) -- database name  
DECLARE @path VARCHAR(256) -- path for backup files  
DECLARE @fileName VARCHAR(256) -- filename for backup  
DECLARE @fileDate VARCHAR(50) -- used for file name
 
SET @path = 'E:\LYNXBACKUP\DB\'  
SET @DBname = 'LYNX_PRODUCTION'
SELECT @fileDate = CONVERT(VARCHAR(50),FORMAT(GETDATE() , 'MM-dd-yyyy-HH-mm-ss'))
 
SET @fileName = @path + @DBname + '_' + @fileDate + '.BAK'  
BACKUP DATABASE @DBname TO DISK = @fileName 



--SQL Server space
SELECT available_physical_memory_kb/1024 as "Total Memory MB",
       available_physical_memory_kb/(total_physical_memory_kb*1.0)*100 AS "% Memory Free"
FROM sys.dm_os_sys_memory

--DATABASE TABLE WISE MEMORY & COUNT
SELECT
s.Name AS SchemaName,
t.Name AS TableName,
p.rows AS RowCounts,
CAST(ROUND((SUM(a.used_pages) / 128.00), 2) AS NUMERIC(36, 2)) AS Used_MB,
CAST(ROUND((SUM(a.total_pages) - SUM(a.used_pages)) / 128.00, 2) AS NUMERIC(36, 2)) AS Unused_MB,
CAST(ROUND((SUM(a.total_pages) / 128.00), 2) AS NUMERIC(36, 2)) AS Total_MB
FROM sys.tables t
INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
GROUP BY t.Name, s.Name, p.Rows
ORDER BY p.rows Desc
GO

--WHO LoGIN IN SQL SERVER
SELECT spid, kpid, blocked, d.name, open_tran, status, hostname,
cmd, login_time, loginame, net_library
FROM sys.sysprocesses p
INNER JOIN sys.databases d 
 on p.dbid=d.database_id
 
 --SQL SERVER DRIVER SPACE
 exec master.dbo.xp_fixeddrives
 
 --SQL Back  uo LOG file
 BACKUP LOG [TestDb] TO  DISK = N'C:\Backup\TestDb.bak'

 
 ALTER DATABASE LYNX_DR SET PARTNER OFF;  
 
 --GET ALL TRIGGERS
 
 SELECT  table_name = OBJECT_NAME(parent_object_id) ,
        trigger_name = name ,
        trigger_owner = USER_NAME(schema_id) ,
        OBJECTPROPERTY(object_id, 'ExecIsUpdateTrigger') AS isupdate ,
        OBJECTPROPERTY(object_id, 'ExecIsDeleteTrigger') AS isdelete ,
        OBJECTPROPERTY(object_id, 'ExecIsInsertTrigger') AS isinsert ,
        OBJECTPROPERTY(object_id, 'ExecIsAfterTrigger') AS isafter ,
        OBJECTPROPERTY(object_id, 'ExecIsInsteadOfTrigger') AS isinsteadof ,
        CASE OBJECTPROPERTY(object_id, 'ExecIsTriggerDisabled')
          WHEN 1 THEN 'Disabled'
          ELSE 'Enabled'
        END AS status
FROM    sys.objects
WHERE   type = 'TR'
ORDER BY OBJECT_NAME(parent_object_id)

-- GET CHANGED AP--
SELECT name
FROM sys.objects
WHERE type = 'P'
AND modify_date > '2018-06-14 00:00:00.000'




SELECT DB_NAME(database_id) as [DB]
    , login_name
    , nt_domain
    , nt_user_name
    , status
    , host_name
    , program_name
	 , login_time
	 , last_successful_logon
    , COUNT(*) AS [Connections]
FROM sys.dm_exec_sessions
WHERE database_id > 0 -- OR 4 for user DBs
GROUP BY database_id, login_name, status, host_name, program_name, nt_domain, nt_user_name ,login_time ,last_successful_logon



SELECT  d.plan_handle ,
        d.sql_handle ,
        e.text

FROM    sys.dm_exec_query_stats d
        CROSS APPLY sys.dm_exec_sql_text(d.plan_handle) AS e
		
		
SELECT  
    SERVERPROPERTY('productversion') as 'Product Version', 
    SERVERPROPERTY('productlevel') as 'Product Level',  
    SERVERPROPERTY('edition') as 'Product Edition',
    SERVERPROPERTY('buildclrversion') as 'CLR Version',
    SERVERPROPERTY('collation') as 'Default Collation',
    SERVERPROPERTY('instancename') as 'Instance',
    SERVERPROPERTY('lcid') as 'LCID',
    SERVERPROPERTY('servername') as 'Server Name'