
--data loading
----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- My workstation is 4 gb RAM with SQL server management studio 2017 and Python environment [Jupyter/Spyder IDE]
-- Thought of automating using Apache AirFlow [Open source ETL scripts process] [Currently I use in the office] but do not have a workstation set up here.[future prospects]
--The data sets has been loaded. Used BCP with Tablock to load the data. 
-- Since The data was so huge some of the files were not opened to view. So had to use python to load few rows and get the structure and load it onto sql.
--step 1.1 to step 1.1.8 all scripts for loading the data for each table. [4 minutes to load the entire data with partitioned and indexing]
--For the interaction dataset. I have partitioned the table from 2013 to 2020. [But I see the data is more in 2018 and 2019] Any clues here?

SELECT distinct
p.partition_number AS PartitionNumber,
f.name AS PartitionFilegroup, 
p.rows AS NumberOfRows 
FROM sys.partitions p
JOIN sys.destination_data_spaces dds ON p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(OBJECT_ID) = 'Interaction'
--I assume the data is OLAP and this dataset is ideally used for analytical and modelling but not for storing and iterating transcational purpose. right?
-- I have created indexes on the ID's and columns which are more frequently used in joining. [tables are below] 
select top 10 * from Interaction
--select top 10 * from Interaction_Acct
--select top 10 * from Interaction_type
--select top 10 * from Acct
--select top 10 * from Acct_Product
--select top 10 * from Acct_Product2
select top 10 * from Sent_Email
--select top 10 * from Email_Activity
--select top 10 * from Rep_Action_Type

--designing Database Schema
-------------------------------------------------------------------------------------------------------------------------------------------------------------
--Interaction and email are considered events.
--As per my understanding Reps reach to accounts/Facility through one of the events[interactions/email].
-- All the inteactions event have been captured in interactions dataset.
--all the Email event have been captured in email data set.
------------------------------------------------------------------------------
--1 
 --Events [Interactions and accounts]
--Keeping aside email apart looking at interaction and account interaction and facility.
-- I assume facility is like a grouped accounts( a healthcare facility has many accounts) right ?
-- But a account can belong to only one facility. There are no shared accounts within the facility. right? I saw in the data none of them were shared.
-- There may be individual accounts which are not grouped (does not have facility id) should I keep them in database and not use them for modelling?--Since modelling requires every account/facility pair
--out of 19 million[19554161] these 14Million [14315205] are the accounts with  facility id
select count(*) from Interaction
where facilityid is not null

--so below is the temoporary structure designed for analysis
-- Rep_action_type and Interaction_type are joined based on there ids.

--accounts and Interaction_accounts
--acct table consist only of those accounts which have facility assigned to it. right?
--Individual accounts are present in interaction account table only
select top 10 * from Interaction
select top 10 * from Interaction_Acct
select top 10 * from Acct

--we only consider those accounts which are in Interaction and have a facility pair
-- if we look at interaction table, there are some accounts where facility id is Null. So i used the account table to see if they are actually individual accounts or just that facility is mising and can be extracted
--from account table
-- If we join main interaction table and left join on Interaction_account and acct table
-- There are some interactions which are not captured in the Interaction_account table [ distinct 1676 rows]. we do have facility id though.
-- Are they not accounts? can I fill those accountid's based on the repid and facilityid

select * from (
select distinct isnull(t5.acct_id,t4.acct_id) as acct_id,isnull(t2.facilityid,t5.facilityid) as facilityid from Interaction t2
left join Interaction_Acct t4
on t2.int_id=t4.int_id
left join Acct t5
on t4.acct_id=t5.acct_id
) t
where acct_id is null


select * from Interaction t1
left join Interaction_Acct t2
on t1.int_id=t2.int_id
where t1.facilityid ='1004695.0'


------------------------------------------------------------------------------------

drop table tbl_temp
select t.repid,rep_act_type_id,t.int_id,t.ext_id,t.int_type_id, facilityid,t6.*
 into tbl_temp
 from (
select t2.repid,rep_act_type_id,t2.int_id,t2.ext_id,t3.int_type_id,t4.acct_id,isnull(t2.facilityid,t5.facilityid) as facilityid from Rep_Action_Type t1
inner join Interaction t2
on t1.rep_act_type_id=t2.rep_action_type_id
inner join Interaction_type t3
on t2.int_type_id=t3.int_type_id
left join Interaction_Acct t4
on t2.int_id=t4.int_id
left join Acct t5
on t4.acct_id=t5.acct_id
) t
left join Acct_Product2 t6
on t.acct_id=t6.acct_id
where facilityid is not null
------------------------------------------------------------------------------------------------------------------------
--2
--account product table
--So this table has all the accounts and products linked to them
select distinct product_id from  Acct_Product
--different accounts have different products linked to them
--So I did a pvot on products to keep distinct accounts and 19 product columns [may be used as features for further modelling]
select top 10 * from Acct_Product2

--one thing to note here. 
-- we do not no if the interaction was for which products though. [if there was interaction_id in the acct_product table, we could have known the specifc product the rep is talking about]
-- I think data collection gap
-- hence I considered all the products with that accountid as interaction
-----------------------------------------------------------------------------------------------------------------------
--3 [rep type and Interaction type]
--different types the reps have reached 
-- In this which ones are email/visit?
--select top 10 * from Interaction
select  * from Interaction_type
select * from Rep_Action_Type

select distinct t1.rep_act_type_id,t3.rep_act_type_name,t1.int_type_id,t2.int_type_name from tbl_temp t1
inner join Interaction_type t2
on t1.int_type_id=t2.int_type_id
inner join Rep_Action_Type t3
on t1.rep_act_type_id=t3.rep_act_type_id

--when I joined my above temp master table created and linked based on ids.
--All I can see is only 2 rep_act_type_id and 2 interaction_type_id
--So I assume, Send_any is for Email and Visit is for visit

-----------------------------------------------------------------------------------------------------------------------------------
--email [Most confused part]
select count(*) from Sent_Email --305763
select count(*) from Email_Activity --410759

--how are email and Interaction linked?
----when I had joined the interaction table on external_id and Email_id
--I got about 0.26 million rows but the thing to note here is none of them have facility id
--Now all of these do not have a facilityid [are all the emails sent are to personal doctors?]
--It can't be
--So I assume we use facilityid from the acct table [which I already used in my master tamp table]


--when I joined my master table tbl_temp
--I got 11380 rows [are these are the only emails sent to an account and facility pair]
select * from tbl_temp t1
inner join Sent_Email t2
on t2.id=t1.ext_id

--If yes, how do I link email sent and activity?
select top 10 * from Interaction
select top 10 * from Sent_Email
select top 10 * from Email_Activity
select top 10 * from tbl_temp


select * from Sent_Email t1
inner join Email_Activity t2
on t1.app_email_temp_vod=t2.sent_email_vod


--need your suggestion Michael
--So The task for schema is to create a single table in the schmea. which means one master table with all events right?
--Do they have to be denormalized in structure [I assume yes, because we are using it for modelling and analysis [OLAP]]
--I am planning to use Star Schema structure [with fact table[master temp table] and dimension tables [remaining tables]]
--So If I join both fact tables and dimension tables I will get one single denomalized for OLAP]

--------------------------------------------------------------------------------------------------------------------------------------------
--Modelling
--As per my understanding Reps reach to accounts/Facility through one of the ways. All the inteactions have been captured in interactions dataset.
-- I am assuming we are targeting the interaction in future. So any interactions in future is the ones where proability of email/visit has to be calculated?
--I am planning to use XGboost/neural networks [tensorflow with keras] sigmoid function to identify the prob?
--Any suggestion you have for me?
--Deadline?