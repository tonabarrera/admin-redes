#!/usr/bin/env python2

import sys
import re
import os.path
import smtplib
from smtplib import SMTPException
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

DIRECCIONES = ["github.com"]
RUTA = "/home/tona/Documents/sexto/admin-redes/ping-poller"


def crear_base():
    """Funcion que crea la base si no existe de acuerdo a la lista
    de host que se tiene declarada"""
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


def graficar():
    """Funcion que toma los valores que hay en la base y los grafica
    en un intervalo del ultimo dia y ultima hora"""
    for direccion in DIRECCIONES:
        archivo_rrd = "{}/{}.rrd".format(RUTA, direccion)
        titulo = "Ping de {}".format(direccion)
        nombre_img = "{}/{}-actual.png".format(RUTA, direccion)
        rrd_graph(nombre_img,
                  "--vertical-label", "miliseg",
                  "--start", "-1h",
                  "--title", titulo,
                  "DEF:mitiempo={}:tiempo:AVERAGE".format(archivo_rrd),
                  "LINE1:mitiempo#FF0000:Tiempo",
                  "GPRINT:mitiempo:AVERAGE:Promedio\: %.3lf ms",
                  "GPRINT:mitiempo:MAX:Max\: %.3lf ms",
                  "GPRINT:mitiempo:MIN:Min\: %.3lf ms")

        for intervalo in ['diario']:
            if intervalo == 'diario':
                etiqueta = 'd'
            # print("{} - {}".format(direccion, intervalo))
            nombre_img = "{}/{}-{}.png".format(RUTA, direccion, intervalo)
            titulo = "Registro ping {} de {}".format(intervalo, direccion)
            rrd_graph(nombre_img, "--start", "-1{}".format(etiqueta),
                      "--vertical-label=miliseg",
                      "--title", titulo,
                      "DEF:mi_tiempo={}:tiempo:AVERAGE".format(archivo_rrd),
                      "LINE1:mi_tiempo#0000FF:Tiempo",
                      "GPRINT:mi_tiempo:AVERAGE:Promedio\: %.2lf ms",
                      "GPRINT:mi_tiempo:MAX:Max\: %.2lf ms",
                      "GPRINT:mi_tiempo:MIN:Min\: %.2lf ms")


def enviar_email(direccion):
    """Funcion que recibe como parametro la direccion del host
    que no respondio a un ping y que se envia por correo electronico,
    los parametros del email son pasados al script al ejecutarlo"""
    email = MIMEMultipart()
    email['From'] = "tonatihubarrera@outlook.com"
    #email['From'] = sys.argv[1]
    email['To'] = "carlostonatihu@gmail.com"
    #email['To'] = sys.argv[2]
    contra = sys.argv[3]
    mensaje = "La direccion {} no responde al ping".format(direccion)
    email['Subject'] = "N3gastupadr3.90"
    email.attach(MIMEText(mensaje, 'plain'))
    try:
        server = smtplib.SMTP("smtp-mail.outlook.com", 587)
        server.starttls()
        server.login(email['From'], contra)
        server.sendmail(email['From'], email['To'], email.as_string())
        server.quit()
        # print("Email enviado")
    except SMTPException as e:
        pass
        # print("Algo fallo al enviar el email")
        # print(e)


def actualizacion():
    """Funcion que cada cierto tiempo acutaliza la informacion
    de rrd despues de realizar un ping"""
    for direccion in DIRECCIONES:
        lista = ["ping", direccion, "-c", "1"]
        enviar_email(direccion)


#crear_base()
actualizacion()
#graficar()
