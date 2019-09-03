import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders
from  email.mime.text import MIMEText

def sendemailwithattachment(login,pw,FROM,TO,cc,sub,mess,attachmentlist):


    rcpt=TO.split(",")+cc.split(",")
    # Prepare actual message
    msg=MIMEMultipart()
    message=mess
    msg['subject']=sub
    msg['Cc']=cc
    msg.attach(MIMEText(message,'plain'))

    #Attachment
    for attachfilename in attachmentlist:
        part = MIMEBase('application', "octet-stream")
        part.set_payload(open(attachfilename, "rb").read())
        encoders.encode_base64(part)
        part.add_header('Content-Disposition', 'attachment;filename=%s'%(attachfilename))
        msg.attach(part)


    # Send the mail
    server = smtplib.SMTP('smtp.office365.com',587)
    server.ehlo()
    server.starttls()
    server.ehlo()
    server.login(login,pw)
    server.sendmail(FROM,rcpt, msg.as_string())
    server.quit()


