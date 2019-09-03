def importsqlcommands(filename):
    csvfilescreated=[]
    with open (filename,'r') as fd:
        sqlfile=fd.read()
    filename=(filename.split('\\'))
    sqlcommands =sqlfile.split(';')
    return sqlcommands