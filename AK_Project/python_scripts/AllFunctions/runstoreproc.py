import pyodbc
import pandas as pd

def runstoreprocedure(sp,DB,serv):
    con=pyodbc.connect('Trusted_Connection=yes',driver ='{SQL Server}',server=serv, database =DB)
    cursor=con.cursor()
    cursor.execute(sp)
    cursor.commit()