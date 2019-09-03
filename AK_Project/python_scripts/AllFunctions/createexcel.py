import pyodbc
import csv
import pandas as pd
import itertools
from sendemail import sendemailwithattachment

def createexcelfile(csvfiles,filename,csvfilesname):
    filename=filename+'.xlsx'
    writer = pd.ExcelWriter(filename, engine='xlsxwriter')
    numberofsheets=0
    for csvfile,name in zip(csvfiles,csvfilesname):
        df = pd.read_csv(csvfile)
        numberofsheets+=1
        df.to_excel(writer, sheet_name=name,index=False)
    writer.save()
    return filename