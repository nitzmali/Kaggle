use Event



ALTER DATABASE event
SET RECOVERY SIMPLE
DBCC SHRINKFILE (Event_log, 1)
ALTER DATABASE event
SET RECOVERY FULL;


--Just look at top 10 rows for all the tables
--Acct
--select top 10 * from Acct
--select top 10 * from Acct_Product
----interaction
--select top 10 * from Interaction
--select top 10 * from Interaction_Acct
--select top 10 * from Interaction_type
----Rep Action Type
--select top 10 * from Rep_Action_Type
----------------------------------------------------------------------------------------------------------------------------------------
--Count Number of rows in each table for verifications
--Acct
--select count(*) from Acct --523737 -- 0.5 Million
--select count(*) from Acct_Product --4638690 --4.6 Million
----interaction
--select count(*) from Interaction --19554161 --19.5 Million
--select count(*) from Interaction_Acct --19606369 --19.6 Million
--select count(*) from Interaction_type --10
----Rep Action Type
--select count(*) from Rep_Action_Type --14

------------------------------------------------------------------------------------------------------------------------------------------
--Analysis 
--Every interaction is linked to every interaction account
--one (accounts,facility) linked to many interaction_account
--one (acct,facility) linked to many products
--one interaction type is linked to many interactions
--one rep_action_type is linked to many interactions
-- if we look at interaction table, there are some accounts where facility id is Null. So i used the account table to see if they are actually individual accounts or just that facility is mising and can be extracted
--from account table
-- If we join main interaction table and left join on Interaction_account and acct table
-- There are some interactions which are not captured in the Interaction_account table [ distinct 1676 rows]. we do have facility id though.


--select top 10 * from Interaction t1
--select top 10 * from Interaction_Acct t2
--select top 10 * from Acct


-------------------------------------------------------------------------------------------------------------------------------------------
--Create  Star schema
--Create Fact table and dimension tables
--Let's start with Dimension tables first [put each of them at grain level- all denormalized]
--Acct_Product table on pivot
--So this table has all the accounts and products linked to them
--select distinct product_id from  Acct_Product --[19 products] 
--different accounts have different products linked to them
--So I did a pvot on products to keep distinct accounts and 19 product columns [may be used as features for further modelling]

if object_id(N'[Acct_Product2]',N'U') is not null
	drop table Acct_Product2
select acct_id, 
count(case when product_id='1001' then 1  end) as Pid1,
count(case when product_id='1002' then 1  end) as Pid2,
count(case when product_id='1003' then 1  end) as Pid3,
count(case when product_id='1004' then 1 end) as Pid4,
count(case when product_id='1006' then 1  end) as Pid5,
count(case when product_id='1007' then 1  end) as Pid6,
count(case when product_id='1008' then 1  end) as Pid7,
count(case when product_id='1009' then 1  end) as Pid8,
count(case when product_id='1010' then 1 end) as Pid9,
count(case when product_id='1011' then 1  end) as Pid10,
count(case when product_id='1012' then 1  end) as Pid11,
count(case when product_id='1013' then 1  end) as Pid12,
count(case when product_id='1014' then 1  end) as Pid13,
count(case when product_id='1015' then 1  end) as Pid14,
count(case when product_id='1016' then 1  end) as Pid15,
count(case when product_id='1017' then 1  end) as Pid16,
count(case when product_id='1018' then 1  end) as Pid17,
count(case when product_id='1019' then 1  end) as Pid18,
count(case when product_id='1025' then 1  end) as Pid19
into Acct_Product2
from Acct_Product
group by acct_id;


--Bridge table(mapping table)
if object_id(N'[tbl_product_map]',N'U') is not null
	drop table tbl_product_map
select convert(varchar(200),row_number() over (order by ([Pid1]+[Pid2]+[Pid3]+[Pid4]+[Pid5]+[Pid6]+[Pid7]+[Pid8]+[Pid9]+[Pid10]+[Pid11]+[Pid12]+[Pid13]+[Pid14]+[Pid15]+[Pid16]+[Pid17]+[Pid18]+[Pid19]) asc)) as Prod_id,
[Pid1]+[Pid2]+[Pid3]+[Pid4]+[Pid5]+[Pid6]+[Pid7]+[Pid8]+[Pid9]+[Pid10]+[Pid11]+[Pid12]+[Pid13]+[Pid14]+[Pid15]+[Pid16]+[Pid17]+[Pid18]+[Pid19] as Prod_Count,* 
into tbl_product_map
from (
select distinct  [Pid1],[Pid2],[Pid3],[Pid4],[Pid5],[Pid6],[Pid7],[Pid8],[Pid9],[Pid10],[Pid11],[Pid12],[Pid13],[Pid14],[Pid15],[Pid16],[Pid17],[Pid18],[Pid19]
from Acct_Product2
acct_id
) t


create index tbl_product_map on tbl_product_map (prod_id);

--Bridge table(mapping table)
if object_id(N'[tbl_product_map_2]',N'U') is not null
	drop table tbl_product_map_2
select  acct_id,prod_id 
into tbl_product_map_2
from Acct_Product2 t1
inner join tbl_product_map t2
on t1.Pid1=t2.Pid1 and 
t1.Pid2=t2.Pid2 and 
t1.Pid3=t2.Pid3 and 
t1.Pid4=t2.Pid4 and 
t1.Pid5=t2.Pid5 and 
t1.Pid6=t2.Pid6 and 
t1.Pid7=t2.Pid7 and 
t1.Pid8=t2.Pid8 and 
t1.Pid9=t2.Pid9 and 
t1.Pid10=t2.Pid10 and 
t1.Pid11=t2.Pid11 and 
t1.Pid12=t2.Pid12 and 
t1.Pid13=t2.Pid13 and 
t1.Pid14=t2.Pid14 and 
t1.Pid15=t2.Pid15 and 
t1.Pid16=t2.Pid16 and 
t1.Pid17=t2.Pid17 and 
t1.Pid18=t2.Pid18 and 
t1.Pid19=t2.Pid19 

create index tbl_product_map_2 on tbl_product_map_2 (acct_id,prod_id);


ALTER DATABASE event
SET RECOVERY SIMPLE

DBCC SHRINKFILE (Event_log, 1)

ALTER DATABASE event
SET RECOVERY FULL;


--Dates Dimension tables
if object_id(N'[tbl_dates]',N'U') is not null
	drop table tbl_dates

select *,
case when meridiem='AM' and hours in ('08','09','10','11') then '1'
when meridiem='PM' and hours in ('12','01','02','03','04','05','06') then '1'
else '0' end as isworkinghours
into tbl_dates
 from (
select  int_id,time_zone,start_date_time,start_date,date_Str,Wk_str,Datepart(year, start_date_time) as Year,Datepart(MONTH, start_date_time) Month,right(date_Str,2) as days,quarter,format(start_date_time,'hh') as hours,format(start_date_time,'mm') as minutes,
format(start_date_time,'ss') as seconds,
CASE WHEN DATEPART(HOUR, start_date_time) > 11 THEN 'PM' ELSE 'AM' END as meridiem,
datename(weekday, start_date) as day,
case when datename(weekday, start_date) in ('Saturday','Sunday') then '0' else '1' end as isweekday
 from Interaction t1
inner join weekdate t2
on convert(VARCHAR,start_date,112)=t2.date_str
) t

create index date on tbl_dates (int_id,start_date,date_str,wk_str)

ALTER DATABASE event
SET RECOVERY SIMPLE

DBCC SHRINKFILE (Event_log, 1)

ALTER DATABASE event
SET RECOVERY FULL;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- fact table get all the ids from the dimension tables. [all foreign keys of dimension tables will be keys here]
if object_id(N'[tbl_fact]',N'U') is not null
	drop table tbl_fact

select int_id,int_type_id,repid,rep_act_type_id,t7.acct_id, facilityid,isnull(t6.prod_id,0) as Prod_id ,t7.start_date_time,t7.start_date
into tbl_fact
from (
select t2.int_id,t3.int_type_id,t2.repid,rep_act_type_id,t4.acct_id,isnull(t2.facilityid,t5.facilityid) as facilityid,t2.start_date_time,t2.start_date from Rep_Action_Type t1
inner join Interaction t2
on t1.rep_act_type_id=t2.rep_action_type_id
inner join Interaction_type t3
on t2.int_type_id=t3.int_type_id
left join Interaction_Acct t4
on t2.int_id=t4.int_id
left join Acct t5
on t4.acct_id=t5.acct_id
) t7
inner join tbl_product_map_2 t6
on t7.acct_id=t6.acct_id
where t7.acct_id is not null

create index int_fac_type on tbl_fact (int_id,acct_id,facilityid,int_type_id,rep_act_type_id,prod_id)

ALTER DATABASE event
SET RECOVERY SIMPLE

DBCC SHRINKFILE (Event_log, 1)

ALTER DATABASE event
SET RECOVERY FULL;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Join facts and dimension tables to create a big table on which we will partition that table based on dates and create a clustered indexes on some important columns
--Basically there are 4 main dimensions
--1. Inter_type/rep_action_type
--2. interaction/acct and acct
--3. product and mappings
--4. dates 
--select top 10 * from tbl_fact t1
--select top 10 * from Interaction 

----1.tbl_fact and intertype/rep action type
-- select top 10 * from tbl_fact t1
-- inner join Rep_Action_Type t2
-- on t1.rep_act_type_id=t2.rep_act_type_id
-- inner join Interaction_type t3
-- on t1.int_type_id=t3.int_type_id
-- --2. tbl_fact and interaction/acct and acct
--select top 10 * from tbl_fact t1
--inner join Interaction t2 
--on t1.int_id=t2.int_id and t1.int_type_id=t2.int_type_id and t1.rep_act_type_id=t2.rep_action_type_id
-- --3. tbl_fact and prouct mappings
-- select top 10 * from tbl_fact t1
--inner join tbl_product_map_2 t2
--on t1.acct_id=t2.acct_id
--inner join tbl_product_map t3
--on t2.Prod_id=t3.Prod_id
----4 tbl_fact and dates
--select top 10 * from tbl_fact t1
--inner join tbl_dates t2
--on t1.int_id=t2.int_id
--and t1.start_date_time=t2.start_date_time
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----Event table
--if object_id(N'[tbl_event]',N'U') is not null
--	drop table tbl_event

-- select t1.int_id,t3.int_type_id,t3.int_type_name,t1.repid,t2.rep_act_type_id,t2.rep_act_type_name,t1.acct_id,t1.facilityid,t6.time_zone,t7.duration,t7.crea_from_sugg,
-- t6.start_date_time,t6.start_date,t6.date_Str,t6.Wk_str,t6.Year,t6.Month,t6.days,t6.hours,t6.minutes,t6.seconds,t6.meridiem,t6.day,t6.isweekday,t6.isworkinghours,t6.Quarter,
-- t5.*,t7.isdeleted,t7.iscompleted 
-- into tbl_event
-- from tbl_fact t1
-- inner join Rep_Action_Type t2
-- on t1.rep_act_type_id=t2.rep_act_type_id
-- inner join Interaction_type t3
-- on t1.int_type_id=t3.int_type_id
-- inner join tbl_product_map_2 t4
-- on t1.acct_id=t4.acct_id
-- inner join tbl_product_map t5
-- on t4.Prod_id=t5.Prod_id
-- inner join tbl_dates t6
-- on t1.int_id=t6.int_id and t1.start_date_time=t6.start_date_time
-- inner join Interaction t7
-- on t1.int_id=t7.int_id

--  create clustered index IX_acct_fac_int_type_id_date on 
-- tbl_event (start_date asc,date_str asc,wk_str asc,year asc,day)


-- create index acct_id_faciltyid_repid_int_type_id_timezone on tbl_event (acct_id,facilityid,repid,int_type_id,time_zone)
--  create index prod on tbl_event ([Pid1],[Pid2],[Pid3],[Pid4],[Pid5],[Pid6],[Pid7],[Pid8],[Pid9],[Pid10],[Pid11],[Pid12],[Pid13],[Pid14],[Pid15],[Pid16],[Pid17],[Pid18],[Pid19])

 --visit
 --select count(*) from tbl_event
 --where int_type_id ='4' and acct_id is not null and facilityid is not null
 --sendany
 -- select count(*) from tbl_event
 --where int_type_id ='11' and acct_id is not null and facilityid is not null

-- select top 10 * from tbl_event

--  select * from tbl_event
-- where day ='sunday'

-- select wk_str,int_type_id,count(int_id) from tbl_event
--where year ='2019'
--and 
--[Pid1]= 0 and [Pid2]= 0 and[Pid3]= 0 and[Pid4]= 0 and[Pid5]= 0 and[Pid6]= 0 and[Pid7]= 0 and[Pid8]= 0 and[Pid9]= 0 and[Pid10]= 0 and[Pid11]= 0 and[Pid12]= 0 and[Pid13]= 0 and[Pid14]= 0 and[Pid15]= 0 and[Pid16]= 0 and[Pid17]= 1 and[Pid18]=1 and [Pid19]=1
--group by int_type_id,Wk_str
--order by Wk_str
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ALTER DATABASE event
SET RECOVERY SIMPLE

DBCC SHRINKFILE (Event_log, 1)

ALTER DATABASE event
SET RECOVERY FULL;

go
--Event view
 If object_id(N'vw_event') is not null Drop view vw_event
 go
create view vw_event 
with schemabinding
as
 select t1.int_id,t3.int_type_id,t3.int_type_name,t1.repid,t2.rep_act_type_id,t2.rep_act_type_name,t1.acct_id,t1.facilityid,t6.time_zone,t7.duration,t7.crea_from_sugg,
 t6.start_date_time,t6.start_date,t6.date_Str,t6.Wk_str,t6.Year,t6.Month,t6.days,t6.hours,t6.minutes,t6.seconds,t6.meridiem,t6.day,t6.isweekday,t6.isworkinghours,t6.Quarter,
 t5.[Prod_id]
      ,[Prod_Count]
      ,[Pid1]
      ,[Pid2]
      ,[Pid3]
      ,[Pid4]
      ,[Pid5]
      ,[Pid6]
      ,[Pid7]
      ,[Pid8]
      ,[Pid9]
      ,[Pid10]
      ,[Pid11]
      ,[Pid12]
      ,[Pid13]
      ,[Pid14]
      ,[Pid15]
      ,[Pid16]
      ,[Pid17]
      ,[Pid18]
      ,[Pid19],t7.isdeleted,t7.iscompleted 
 from dbo.tbl_fact t1
 inner join dbo.Rep_Action_Type t2
 on t1.rep_act_type_id=t2.rep_act_type_id
 inner join dbo.Interaction_type t3
 on t1.int_type_id=t3.int_type_id
 inner join dbo.tbl_product_map_2 t4
 on t1.acct_id=t4.acct_id
 inner join dbo.tbl_product_map t5
 on t4.Prod_id=t5.Prod_id
 inner join dbo.tbl_dates t6
 on t1.int_id=t6.int_id and t1.start_date_time=t6.start_date_time
 inner join dbo.Interaction t7
 on t1.int_id=t7.int_id
 

 --Create unique clustered Index on dates for each interaction and account
  create unique clustered index IX_acct_fac_int_type_id_date on 
 vw_event (int_id,acct_id,start_date asc,date_str asc,wk_str asc,year asc,day);

 --Create non clustered indexs for ids and products
 create index acct_id_faciltyid_repid_int_type_id_timezone on vw_event (acct_id,facilityid,repid,int_type_id,time_zone);
  create index prod on vw_event ([Pid1],[Pid2],[Pid3],[Pid4],[Pid5],[Pid6],[Pid7],[Pid8],[Pid9],[Pid10],[Pid11],[Pid12],[Pid13],[Pid14],[Pid15],[Pid16],[Pid17],[Pid18],[Pid19]);

  ALTER DATABASE event
SET RECOVERY SIMPLE

DBCC SHRINKFILE (Event_log, 1)

ALTER DATABASE event
SET RECOVERY FULL;


  --Some queries for testing spped of retrieval

-- select * from vw_event
-- with (NOEXPAND)
-- where 
-- --acct_id ='183134'
-- day ='monday'
-- and 
--[Pid1]= 0 and [Pid2]= 0 and[Pid3]= 0 and[Pid4]= 0 and[Pid5]= 0 and[Pid6]= 0 and[Pid7]= 0 and[Pid8]= 0 and[Pid9]= 0 and[Pid10]= 1 and[Pid11]= 0 and[Pid12]= 1 and[Pid13]= 0 and[Pid14]= 0 and[Pid15]= 0 and[Pid16]= 0 and[Pid17]= 1 and[Pid18]=1 and [Pid19]=0


-- --visit
-- select count(*) from vw_event
-- where int_type_id ='4' and acct_id is not null and facilityid is not null
-- --sendany
--  select count(*) from vw_event
-- where int_type_id ='11' and acct_id is not null and facilityid is not null


 
-- select date_Str,int_type_id,count(int_id) from vw_event
--  with (NOEXPAND)
----where 
----year ='2019' 
----[Pid1]= 0 and [Pid2]= 0 and[Pid3]= 0 and[Pid4]= 0 and[Pid5]= 0 and[Pid6]= 0 and[Pid7]= 0 and[Pid8]= 0 and[Pid9]= 0 and[Pid10]= 0 and[Pid11]= 0 and[Pid12]= 0 and[Pid13]= 0 and[Pid14]= 0 and[Pid15]= 0 and[Pid16]= 0 and[Pid17]= 1 and[Pid18]=1 and [Pid19]=1
--group by int_type_id,date_str
--order by date_Str

--select * from vw_event
--where repid ='2345'



select wk_str,int_type_id,time_zone,count(int_id) from vw_event
with (NOEXPAND)
where time_zone in ('America/Chicago','America/Los_Angeles')
and iscompleted='1'
group by int_type_id,Wk_str,time_zone



