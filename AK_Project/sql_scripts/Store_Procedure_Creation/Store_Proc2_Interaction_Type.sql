USE [Event]
GO
/****** Object:  StoredProcedure [dbo].[Step1_Interaction]    Script Date: 8/31/2019 4:04:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[Step2_Interaction_Type]

AS
BEGIN


if object_id(N'[Interaction_type]',N'U') is not null
	drop table [Interaction_type]

create table [Interaction_type] (
int_type_id varchar(200) not null,
int_type_name varchar(200),
createdate datetime,
updatedate datetime )


ALTER DATABASE Event SET RECOVERY SIMPLE;
SET STATISTICS TIME ON
BULK INSERT [dbo].[Interaction_type]
FROM 'D:\Jupyter Notebook\AK_Project2\data_engineer_test\de_test_interaction_type.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '0x0a',   --Use to shift the control to next row
    TABLOCK
)

ALTER DATABASE Event SET RECOVERY Full;

create index int_type_id_name on [Interaction_type](int_type_id,int_type_name)

END

