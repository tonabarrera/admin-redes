from rrdtool import create as rrd_create
from rrdtool import update as rrd_update
from rrdtool import fetch as rrd_fetch
import subprocess
import sys
import re
import os.path
import smtplib
from smtplib import SMTPException
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

DIRECCIONES = ["github.com", "127.0.0.1", "148.204.58.221"]
RUTA = "/home/tona/Documents/sexto/redes3/ping-poller"


def crear_base():
    # Espera 120 segundos antes de que se guarde como NaN
    # RRA:AVERAGE:0.5:1:60
    # 0.5 = porcentaje de PDP que pueden ser desconocidos
    # 1  = PDP que se utilizan, cada actualizacion es un PDP
    # 60 = Cuantos PDP se guardan
    # 1 min (60 s) * 1 PDP = 1 min intervalo en el que se guarda un registro de los 60
    # Toma (1 min * 60 registros) = 60 min llenar los 60 registros
    # Por lo que almacenamos 60 min de info
    for direccion in DIRECCIONES:
        archivo = "{}/{}.rrd".format(RUTA, direccion)
        if not os.path.isfile(archivo):
            base_rrd = rrd_create(archivo, "--start", "N", "--step", "60",
                                  "DS:tiempo:GAUGE:120:0:U",
                                  "RRA:MIN:0.5:5:12",
                                  "RRA:MAX:0.5:5:12",
                                  "RRA:MIN:0.5:60:24",
                                  "RRA:MAX:0.5:60:24",
                                  "RRA:AVERAGE:0.5:1:60",
                                  "RRA:AVERAGE:0.5:10:144")


def enviar_email(direccion):
    email = MIMEMultipart()
    # email['From'] = "tonatihubarrera@outlook.com"
    email['From'] = sys.argv[1]
    # email['To'] = "carlostonatihu@gmail.com"
    email['To'] = sys.argv[2]
    contra = sys.argv[3]
    mensaje = "La direccion {} no responde al ping".format(direccion)
    email['Subject'] = mensaje
    email.attach(MIMEText(mensaje, 'plain'))
    try:
        server = smtplib.SMTP("smtp-mail.outlook.com", 587)
        server.starttls()
        server.login(email['From'], contra)
        server.sendmail(email['From'], email['To'], email.as_string())
        server.quit()
        print("Email enviado")
    except SMTPException as e:
        print("Algo fallo al enviar el email")
        print(e)


def actualizacion():
    for direccion in DIRECCIONES:
        lista = ["ping", direccion, "-c", "1"]
        try:
            resultado = subprocess.check_output(lista)
            resultado = resultado.decode("utf-8")
            regex = re.compile(".*time=([0-9.]*) ms")
            r = regex.findall(resultado)[0]
            dato = float(r)
            archivo = "{}/{}.rrd".format(RUTA, direccion)
            rrd_update(archivo, "N:{}".format(dato))
        except Exception as e:
            print("Error al hacer ping")
            print(e)
            enviar_email(direccion)


crear_base()
actualizacion()
