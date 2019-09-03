USE [Event]
GO


if object_id(N'[weekdate]',N'U') is not null
	drop table weekdate

create table weekdate (
Wdate datetime not null,
WK datetime not null,
date_Str varchar(8) not null,
Wk_str varchar(8),
Quarter varchar(10) )


ALTER DATABASE Event SET RECOVERY SIMPLE;
SET STATISTICS TIME ON
BULK INSERT [dbo].weekdate
FROM 'D:\Jupyter Notebook\AK_Project2\data_engineer_test\dates_table.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '0x0a',   --Use to shift the control to next row
    TABLOCK
)

ALTER DATABASE Event SET RECOVERY Full;

create index weekdate on weekdate(date_str,Wk_Str)
