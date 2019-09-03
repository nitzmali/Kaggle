use event;
go


if object_id(N'[Acct_Product]',N'U') is not null
	drop table Acct_Product

create table Acct_Product (
acct_id varchar(200) not null,
product_id varchar(200),
createdate datetime,
updatedate datetime )


ALTER DATABASE Event SET RECOVERY SIMPLE;
SET STATISTICS TIME ON
BULK INSERT [dbo].Acct_Product
FROM 'D:\Jupyter Notebook\AK_Project2\data_engineer_test\de_test_account_product.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '0x0a',   --Use to shift the control to next row
    TABLOCK
)

ALTER DATABASE Event SET RECOVERY Full;

create index acct_Prod on Acct_Product(acct_id,product_id)


select * from Acct_Product
