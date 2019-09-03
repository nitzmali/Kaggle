USE [Event]
GO
/****** Object:  StoredProcedure [dbo].[Step3_Interaction_Acct]    Script Date: 8/31/2019 4:10:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[Step5_Rep_Action_Type]

AS
BEGIN

if object_id(N'[Rep_Action_Type]',N'U') is not null
	drop table Rep_Action_Type

create table Rep_Action_Type (
rep_act_type_id varchar(200) not null,
rep_act_type_name varchar(200),
createdate datetime,
updatedate datetime )


ALTER DATABASE Event SET RECOVERY SIMPLE;
SET STATISTICS TIME ON
BULK INSERT [dbo].Rep_Action_Type
FROM 'D:\Jupyter Notebook\AK_Project2\data_engineer_test\de_test_rep_action_type.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '0x0a',   --Use to shift the control to next row
    TABLOCK
)

ALTER DATABASE Event SET RECOVERY Full;

create index rep_act_name on Rep_Action_Type(rep_act_type_id,rep_act_type_name)

END

