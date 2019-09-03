
use Event;
go

if object_id(N'[Email_Activity]',N'U') is not null
	drop table Email_Activity

create table Email_Activity (
id varchar(200) not null,
isdeleted int,
createdate datetime,
CreatedById varchar(200),
LastModifieddate datetime,
LastModifiedByID varchar(200),
Sys_Mod_Stamp datetime,
sent_email_vod varchar(200),
act_datetime_vod datetime,
event_type_vod varchar(200),
arc_start_date datetime,
arc_end_date datetime,
scd_row_type_id varchar (200),
 date_of_process_run datetime,
 )

ALTER DATABASE Event SET RECOVERY SIMPLE;
SET STATISTICS TIME ON
BULK INSERT [dbo].Email_Activity
FROM 'D:\Jupyter Notebook\AK_Project2\data_engineer_test\de_test_email_activity.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '0x0a',   --Use to shift the control to next row
    TABLOCK
)

ALTER DATABASE Event SET RECOVERY Full;

Create CLUSTERED index id_email_eventtype on Email_Activity (id,sent_email_vod,event_type_vod);
