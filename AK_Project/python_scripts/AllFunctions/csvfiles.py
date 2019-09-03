import pyodbc
import csv
import pandas as pd
import itertools

def writetocsvfile(filename,rowscommand,headcommand,DB,serv):
    with open(filename,'w',newline='') as csvfile:
        filewriter=csv.writer(csvfile,dialect='excel',delimiter=',',quotechar='|',quoting=csv.QUOTE_MINIMAL)
        con=pyodbc.connect('Trusted_Connection=yes',driver ='{SQL Server}',server=serv, database =DB)
        cursor=con.cursor()
    
        cursor.execute(headcommand)
        l=[]
        while 1:
           head =cursor.fetchone()
           if not head:
                break
           [l.append(s) for s in head]
        filewriter.writerow(l)

        cursor.execute(rowscommand)
        while 1:
            rows =cursor.fetchone()
            if not rows:
                break
            t=[]
            [t.append(s) for s in rows]
            filewriter.writerow(t)
        con.close()



def importsqlcreatecsv(sqlfilename,DB,serv):
    csvfilescreated=[]
    with open (sqlfilename,'r') as fd:
        sqlfile=fd.read()
    sqlfilename=(sqlfilename.split('\\'))
    sqlfilename=sqlfilename[1].split('.')
    sqlcommands =sqlfile.split(';')
    numberoffiles =0
    for head,content in zip(*[iter(sqlcommands)]*2):
        numberoffiles+=1
        writetocsvfile(sqlfilename[0]+str(numberoffiles)+'.csv',content,head,DB,serv)
        csvfilescreated.append(sqlfilename[0]+str(numberoffiles)+'.csv')
    return csvfilescreated