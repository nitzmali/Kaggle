import imaplib
import email
import re
import datetime
from bs4 import BeautifulSoup
# Connect to imap server



def get_bodyhtml(msg):
    if msg.is_multipart():
        return get_bodyhtml(msg.get_payload(0))
    else:
        return msg.get_payload(None,True)

def get_bodytext(body):
    soup=BeautifulSoup(body,"html.parser")
    for script in soup(["script","style"]):
        script.extract()
    text=soup.get_text()
    lines =(line.strip() for line in text.splitlines())
    chunks =(phrase.strip() for line in lines for phrase in line.split(" "))
    text=' '.join(chunk for chunk in chunks if chunks)
    return text

def get_bodytext(body):
    soup=BeautifulSoup(body,"html.parser")
    for script in soup(["script","style"]):
        script.extract()
    text=soup.get_text()
    lines =(line.strip() for line in text.splitlines())
    chunks =(phrase.strip() for line in lines for phrase in line.split(" "))
    text=' '.join(chunk for chunk in chunks if chunks)
    return text.strip()

def search(key,value,mail):
    result,data = mail.search(None,key,'"{}"'.format(value))
    return data

def describe(raw):

    date_tuple = email.utils.parsedate_tz(raw['Date'])
    if date_tuple:
         local_date = datetime.datetime.fromtimestamp(email.utils.mktime_tz(date_tuple))
    tim=local_date.strftime("%H:%m:%S")
    fro=email.utils.parseaddr(raw['From'])[1]
    to=raw['To']
    sub=raw['subject']
    return tim,fro,to,sub
    


def get_attachment(msg):
    for part in msg.walk():
        if part.get_content_maintype()=='multipart':
            continue
        if part.get('Content-Disposition') is None:
            continue
        filename = part.get_filename()
        if bool(filename):
            with open(filename,'wb') as f:
                f.write(part.get_payload(decode=True))



def main(username,password,searchfrom,boolattach,date,n):
    headers=['Time','From','To','Subject','Body']
    datastamp={}
    mail = imaplib.IMAP4_SSL('outlook.office365.com')
    mail.login(username, password)
    mail.select("Inbox",True)

    #result,data=mail.search(None,'ALL')
    #result,data=mail.search(None,'(FROM %s)'%(searchfrom))
    result,data=mail.search(None,'(SENTSINCE {0})'.format(date),'(FROM %s)'%(searchfrom))
    if data==[b'']:
        return False
    
    ids=data[0]
    id_list=str(ids,encoding="utf-8").split()


    for i in range(len(id_list)):
        list=[]
        result,data =mail.fetch(id_list[-(i+1)],'(RFC822)')
        raw=email.message_from_bytes(data[0][1])

        #from,to,header,subject
        Tim,From,To,Subject= describe(raw)
        bodyhtml=get_bodyhtml(raw).decode("cp1252")
        bodytext=get_bodytext(bodyhtml)

        #attachment
        if boolattach:
            get_attachment(raw)
        list.append(Tim)
        list.append(From)
        list.append(To)
        list.append(Subject)
        list.append(bodytext)

        datastamp[Tim]=(dict(zip(headers,list)))
    mail.close()
    mail.logout()
    return datastamp



    







































