select * from Rep_Action_Type
select * from Interaction_type
--Account and interaction
select count(*) from Interaction
--select count(*) from [Acct]
select count(*) from Interaction_Acct

select count(distinct int_id) from Interaction


select * from Interaction_Acct
where int_id not in (select distinct int_id from Interaction)



select * from Interaction
where int_id not in (select distinct int_id from Interaction_Acct)


select top 10 * from Interaction
select top 10 * from [Acct]
select top 10 * from Interaction_Acct


select count(*) from Interaction --19554161
select count(*) from Interaction_Acct --19606369


select count(*) from Interaction t1
inner join Interaction_Acct t2
on t1.int_id=t2.int_id


select * from Interaction_Acct t1
left join acct t2 
on t1.acct_id=t2.acct_id
inner join Interaction t3
on t1.int_id=t3.int_id
where t2.acct_id is null


--Facility pair


select acct_id,count(facilityid) from [Acct]
group by acct_id

select facilityid ,count(acct_id) from Acct
group by facilityid
use Event
--14 million
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
inner join Acct_Product2 t6
on t.acct_id=t6.acct_id
where facilityid is not null



--left join on all 19609205
--right join on all
--inner join about 2 million

select distinct acct_id from [Acct]
select top 10 * from Interaction_Acct

select count(*) from Interaction_Acct t1
left join acct t2 
on t1.acct_id=t2.acct_id
where t2.acct_id is null

select top 10 * from Acct_Product
select top 10 * from Interaction_Acct
select top 10 * from Interaction


if object_id(N'[Acct_Product2]',N'U') is not null
	drop table Acct_Product2
select acct_id, 
count(case when product_id='1001' then 1 else 0 end) as Pid1,
count(case when product_id='1002' then 1 else 0 end) as Pid2,
count(case when product_id='1003' then 1 else 0 end) as Pid3,
count(case when product_id='1004' then 1 else 0 end) as Pid4,
count(case when product_id='1006' then 1 else 0 end) as Pid5,
count(case when product_id='1007' then 1 else 0 end) as Pid6,
count(case when product_id='1008' then 1 else 0 end) as Pid7,
count(case when product_id='1009' then 1 else 0 end) as Pid8,
count(case when product_id='1010' then 1 else 0 end) as Pid9,
count(case when product_id='1011' then 1 else 0 end) as Pid10,
count(case when product_id='1012' then 1 else 0 end) as Pid11,
count(case when product_id='1013' then 1 else 0 end) as Pid12,
count(case when product_id='1014' then 1 else 0 end) as Pid13,
count(case when product_id='1015' then 1 else 0 end) as Pid14,
count(case when product_id='1016' then 1 else 0 end) as Pid15,
count(case when product_id='1017' then 1 else 0 end) as Pid16,
count(case when product_id='1018' then 1 else 0 end) as Pid17,
count(case when product_id='1019' then 1 else 0 end) as Pid18,
count(case when product_id='1025' then 1 else 0 end) as Pid19
into Acct_Product2
from Acct_Product
group by acct_id

select top 10 * from #temp
 

 select * from Sent_Email t1
 inner join Interaction t2
 on t1.id=t2.ext_id

 
 select * from Sent_Email t1
 inner join Interaction t2
 on t1.id=t2.ext_id
 inner join Interaction_Acct t3
 on t3.int_id=t2.int_id
 inner join Acct t4
 on t4.acct_id=t3.acct_id


 select top 10 * from Sent_Email
 select top 10 * from Interaction
 select top 10 * from Interaction_Acct
 select * from acct t1
 inner join Sent_Email t2
 on t1.ext_id=t2.id



 select * into 
 tbl_temp
 from #temp

