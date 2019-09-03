import pyodbc



def runcommand(command,DB,serv):
    con=pyodbc.connect('Trusted_Connection=yes',driver ='{SQL Server}',server=serv, database =DB)
    cursor=con.cursor()
    cursor.execute(command)
    cursor.commit()
    con.close()
