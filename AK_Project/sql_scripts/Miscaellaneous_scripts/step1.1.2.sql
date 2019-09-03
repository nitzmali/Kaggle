use event;
go


if object_id(N'[Interaction_Acct]',N'U') is not null
	drop table Interaction_Acct

create table Interaction_Acct (
int_id varchar(200) not null,
acct_id varchar(200),
isdeleted int,
createdate datetime,
updatedate datetime )


ALTER DATABASE Event SET RECOVERY SIMPLE;
SET STATISTICS TIME ON
BULK INSERT [dbo].[Interaction_Acct]
FROM 'D:\Jupyter Notebook\AK_Project2\data_engineer_test\de_test_interaction_account.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '0x0a',   --Use to shift the control to next row
    TABLOCK
)

ALTER DATABASE Event SET RECOVERY Full;

create index int_acct_id on [Interaction_Acct](int_id,acct_id)


