use Event

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
updatedate datetime)

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

select * from Interaction
