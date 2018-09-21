import smtplib
from smtplib import SMTPException
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import re
import subprocess

DIRECCIONES = ["ytucuantocuestas.com", "127.0.0.1", "148.204.58.221"]


def enviar_email(direccion):
    msg = MIMEMultipart()
    msg['From'] = "tonatihubarrera@outlook.com"
    msg['To'] = "carlostonatihu@gmail.com"
    msg['Subject'] = "{} no responde al ping".format(direccion)
    message = "La direccion {} no responde al ping".format(direccion)
    msg.attach(MIMEText(message, 'plain'))
    try:
        server = smtplib.SMTP("smtp-mail.outlook.com", 587)
        server.starttls()
        server.login("tonatihubarrera@outlook.com", "")
        server.sendmail(msg['From'], msg['To'], msg.as_string())
        server.quit()
        print("Successfully sent email")
    except SMTPException:
        print("Error: unable to send email")


def actualizacion():

    for direccion in DIRECCIONES:
        mandar = False
        lista = ["ping", direccion, "-c", "1"]
        try:
            resultado = subprocess.check_output(lista)
            print("QUE PASO QUI")
            resultado = resultado.decode("utf-8")
            regex = re.compile(".*time=([0-9.]*) ms")
            r = regex.findall(resultado)[0]
            dato = float(r)
            print("SI SE PUDO")
        except Exception as e:
            print("--ERROR--")
            mandar = True
        if mandar:
            print("ENVIAR EMAIL")
            enviar_email(direccion)

actualizacion()

#swaks --to "carlostonatihu@gmail.com" --from "tonatihubarrera@outlook.com" -s smtp-mail.outlook.com:587 -tls -a --auth LOGIN --auth-user "tonatihubarrera@outlook.com" --auth-password "" --data "Date: %DATE%\nTo: %TO_ADDRESS%\nFrom: %FROM_ADDRESS%\nSubject: Titulo par tu email\nX-Mailer: swaks v$p_versionjetmore.org/john/code/swaks/\n%NEW_HEADERS%\n Mensaje que quieran enviar en tu correo \n"
