use Event
SET NOCOUNT OFF

--step 1 Interaction SP Creation
declare @Sql varchar(8000)
set @Sql = 'SQLCMD -S NMALI-T450S -i "D:\Jupyter Notebook\AK_Project2\sql_scripts\SQL_Independent_Scripts\Store_Proc1_Interaction.sql"'
EXEC master.sys.xp_cmdshell @Sql;

--step 2 Interaction_Type SP Creation
declare @Sql varchar(8000)
set @Sql = 'SQLCMD -S NMALI-T450S -i "D:\Jupyter Notebook\AK_Project2\sql_scripts\SQL_Independent_Scripts\Store_Proc2_Interaction_Type.sql"'
EXEC master.sys.xp_cmdshell @Sql;

--step 3 Interaction_Account Creation
declare @Sql varchar(8000)
set @Sql = 'SQLCMD -S NMALI-T450S -i "D:\Jupyter Notebook\AK_Project2\sql_scripts\SQL_Independent_Scripts\Store_Proc3_Interaction_Acct.sql"'
EXEC master.sys.xp_cmdshell @Sql;

--step 4 Account Creation
declare @Sql varchar(8000)
set @Sql = 'SQLCMD -S NMALI-T450S -i "D:\Jupyter Notebook\AK_Project2\sql_scripts\SQL_Independent_Scripts\Store_Proc4_Acct.sql"'
EXEC master.sys.xp_cmdshell @Sql;

--step 5 RepActionType Creation
declare @Sql varchar(8000)
set @Sql = 'SQLCMD -S NMALI-T450S -i "D:\Jupyter Notebook\AK_Project2\sql_scripts\SQL_Independent_Scripts\Store_Proc5_Rep_Action_Type.sql"'
EXEC master.sys.xp_cmdshell @Sql;

--step 6 Account Product Creation
declare @Sql varchar(8000)
set @Sql = 'SQLCMD -S NMALI-T450S -i "D:\Jupyter Notebook\AK_Project2\sql_scripts\SQL_Independent_Scripts\Store_Proc6_Acct_Product.sql"'
EXEC master.sys.xp_cmdshell @Sql;

--step 7 weekdate
declare @Sql varchar(8000)
set @Sql = 'SQLCMD -S NMALI-T450S -i "D:\Jupyter Notebook\AK_Project2\sql_scripts\SQL_Independent_Scripts\Store_Proc7_weekdate.sql"'
EXEC master.sys.xp_cmdshell @Sql;


