use event
 
DECLARE @name varchar(20), @id varchar(20), @kill_process nvarchar(max); 
DECLARE TP_cursor CURSOR FOR 
 select  d.name ,convert (smallint, req_spid) As spid
      from master.dbo.syslockinfo l, 
           master.dbo.spt_values v,
           master.dbo.spt_values x, 
           master.dbo.spt_values u, 
           master.dbo.sysdatabases d
      where   l.rsc_type = v.number 
      and v.type = 'LR' 
      and l.req_status = x.number 
      and x.type = 'LS' 
      and l.req_mode + 1 = u.number
      and u.type = 'L' 
      and l.rsc_dbid = d.dbid 
      and rsc_dbid = (select top 1 dbid from 
                      master..sysdatabases 
                      where name like 'event')

OPEN TP_cursor

FETCH NEXT FROM TP_cursor 
INTO @name, @id

WHILE @@FETCH_STATUS = 0
BEGIN
select @name,@id
print @name
print @id
SET @kill_process =  'KILL ' + @id      
            EXEC master.dbo.sp_executesql @kill_process
                   PRINT 'killed spid : '+ @id
	FETCH NEXT FROM TP_cursor		
	INTO @name, @id

	END 

CLOSE TP_cursor;
DEALLOCATE TP_cursor;

Set Nocount off



drop database Event




