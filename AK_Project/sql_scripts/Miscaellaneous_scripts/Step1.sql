use event;
go

drop partition function interaction_pfn
--create partition function to set partition boundary by year
create partition function interaction_pfn(DATETIME)
as range right for values(
'20130101','20140101','20150101','20160101','20170101','20180101','20190101','20200101')

--create partition scheme to send each partition to a different file group

create partition scheme interaction_scheme AS
partition interaction_pfn to (
'int_2013','int_2014','int_2015','int_2016','int_2017','int_2018','int_2019','int_2020','prim')

--verify the newly created partition boundaries
SELECT psch.name as PartitionScheme,
prng.value AS ParitionValue,
prng.boundary_id AS BoundaryID
FROM sys.partition_functions AS pfun
INNER JOIN sys.partition_schemes psch ON pfun.function_id = psch.function_id
INNER JOIN sys.partition_range_values prng ON prng.function_id=pfun.function_id
WHERE pfun.name = 'interaction_pfn'