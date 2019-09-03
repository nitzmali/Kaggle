
use event;
go

if object_id(N'[Sent_Email]',N'U') is not null
	drop table Sent_Email

create table Sent_Email (
id varchar(200) not null,
isdeleted int,
rec_Type_id varchar(200) null,
createdate datetime,
CreatedById varchar(200),
LastModifieddate datetime,
LastModifiedByID varchar(200),
Sys_Mod_Stamp datetime,
acct_vod varchar(200),
app_email_temp_vod varchar(200),
cap_datetime_vod datetime,
email_sent_date_vod datetime,
Opened_vod int,
product_vod varchar(200),
status_vod varchar(200)
 )

ALTER DATABASE Event SET RECOVERY SIMPLE;
SET STATISTICS TIME ON
BULK INSERT [dbo].Sent_Email
FROM 'D:\Jupyter Notebook\AK_Project2\data_engineer_test\de_test_sent_email.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '0x0a',   --Use to shift the control to next row
    TABLOCK
)

ALTER DATABASE Event SET RECOVERY Full;

Create CLUSTERED index date_opened on Sent_Email (id,email_sent_date_vod,Opened_vod);
