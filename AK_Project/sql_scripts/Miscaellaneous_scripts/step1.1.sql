use Event;

go



ALTER DATABASE Event
ADD FILEGROUP int_2013
GO
ALTER DATABASE Event
ADD FILEGROUP int_2014
GO
ALTER DATABASE Event
ADD FILEGROUP int_2015
GO
ALTER DATABASE Event
ADD FILEGROUP int_2016
GO
ALTER DATABASE Event
ADD FILEGROUP int_2017
GO
ALTER DATABASE Event
ADD FILEGROUP int_2018
GO
ALTER DATABASE Event
ADD FILEGROUP int_2019
GO
ALTER DATABASE Event
ADD FILEGROUP int_2020
GO

SELECT name AS AvailableFilegroups
FROM sys.filegroups
WHERE type = 'FG'

ALTER DATABASE [Event]
    ADD FILE 
    (
    NAME = [part2013],
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\eventdb.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [int_2013]

	ALTER DATABASE [Event]
    ADD FILE 
    (
    NAME = [part2014],
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\eventdb2.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [int_2014]

	ALTER DATABASE [Event]
    ADD FILE 
    (
    NAME = [part2015],
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\eventdb3.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [int_2015]

	ALTER DATABASE [Event]
    ADD FILE 
    (
    NAME = [part2016],
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\eventdb4.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [int_2016]

	ALTER DATABASE [Event]
    ADD FILE 
    (
    NAME = [part2017],
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\eventdb5.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [int_2017]

	ALTER DATABASE [Event]
    ADD FILE 
    (
    NAME = [part2018],
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\eventdb6.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [int_2018]

	ALTER DATABASE [Event]
    ADD FILE 
    (
    NAME = [part2019],
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\eventdb7.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [int_2019]

	ALTER DATABASE [Event]
    ADD FILE 
    (
    NAME = [part2020],
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\eventdb8.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [int_2020]


SELECT 
name as [FileName],
physical_name as [FilePath] 
FROM sys.database_files
where type_desc = 'ROWS'
GO


--drop partition function interactionpfn
--create partition function to set partition boundary by year
create partition function interactionpfn(DATE)
as range right for values(
'2014-01-01','2015-01-01','2016-01-01','2017-01-01','2018-01-01','2019-01-01','2020-01-01')

use Event;
go
--create partition scheme to send each partition to a different file group
--drop partition scheme interaction_scheme
create partition scheme interaction_scheme AS
partition interactionpfn to (
'int_2013','int_2014','int_2015','int_2016','int_2017','int_2018','int_2019','int_2020')


if object_id(N'[Interaction]',N'U') is not null
	drop table Interaction

create table Interaction (
int_id varchar(200) not null,
ext_id varchar(200),
int_type_id varchar(200),
rep_action_type_id varchar(200),
repid varchar(100),
facilityid varchar(200),
start_date_time datetime,
duration int,
crea_from_sugg int,
iscompleted int,
isdeleted int,
time_zone varchar(200),
start_date date,
createdate datetime,
updatedate datetime )
ON interaction_scheme (start_date)

ALTER DATABASE Event SET RECOVERY SIMPLE;
SET STATISTICS TIME ON
BULK INSERT [dbo].[Interaction]
FROM 'D:\Jupyter Notebook\AK_Project2\data_engineer_test\de_test_interaction.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '0x0a',   --Use to shift the control to next row
    TABLOCK
)

ALTER DATABASE Event SET RECOVERY Full;

--select top 10 * from Interaction



--verify the newly created partition boundaries
SELECT distinct
p.partition_number AS PartitionNumber,
f.name AS PartitionFilegroup, 
p.rows AS NumberOfRows 
FROM sys.partitions p
JOIN sys.destination_data_spaces dds ON p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(OBJECT_ID) = 'Interaction'


--select count(*) from Interaction

--select facilityid, count (distinct int_id ) from Interaction
--group by facilityid
--having count(distinct int_id) >1


create index int_fac_type on Interaction (int_id,facilityid,int_type_id)
create index rep_act_type on Interaction (rep_action_type_id,repid)
create index ext_i on Interaction (ext_id)



select * from Interaction
where start_date like '%2017%'


select * from Interaction 
where rep_action_type_id='12' and repid ='2806'
