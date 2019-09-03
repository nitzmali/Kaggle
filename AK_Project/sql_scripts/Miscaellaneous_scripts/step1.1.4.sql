use event;
go


if object_id(N'[Acct]',N'U') is not null
	drop table Acct

create table Acct (
acct_id varchar(200),
ext_id varchar(200),
facilityid varchar(200),
isdeleted int,
createdate datetime,
updatedate datetime )


ALTER DATABASE Event SET RECOVERY SIMPLE;
SET STATISTICS TIME ON
BULK INSERT [dbo].Acct
FROM 'D:\Jupyter Notebook\AK_Project2\data_engineer_test\de_test_account.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '0x0a',   --Use to shift the control to next row
    TABLOCK
)

ALTER DATABASE Event SET RECOVERY Full;

create index acct_fac_ext on Acct(acct_id,ext_id,facilityid)


select * from Acct
