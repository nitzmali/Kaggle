import pyodbc
import pandas as pd


def exportdata(command,DB,serv):
    con=pyodbc.connect('Trusted_Connection=yes',driver ='{SQL Server}',server=serv, database =DB)
    data=pd.read_sql(command,con)
    return data