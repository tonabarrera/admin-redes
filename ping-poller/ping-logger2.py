from rrdtool import create as rrd_create
from rrdtool import update as rrd_update
from rrdtool import fetch as rrd_fetch
import subprocess
import pdb
import re
import os.path

DIRECCIONES = ["github.com", "127.0.0.1", "148.204.58.221"]
RUTA = "/home/tona/Documents/sexto/redes3/ping-logger"


def crear_base():
    # RRA:AVERAGE:0.5:1:24
    # 0.5 = porcentaje de PDP que pueden ser desconocidos
    # 5  = PDP que se utilizan, cada actualizacion es un PDP
    # 48 = Cuantos PDP se guardan
    # 1 min * 5 PDP = 5 min intervalo en el que se guarda un registro de los 48
    # Toma (5 min * 48 registros) = 240 min =  4 hrs llenar los 48 registros
    # Por lo que almacenamos 4 horas de info
    for direccion in DIRECCIONES:
        archivo = "{}/{}.rrd".format(RUTA, direccion)
        if not os.path.isfile(archivo):
            base_rrd = rrd_create(archivo, "--start", "N", "--step", "60",
                                  "DS:tiempo:GAUGE:120:0:U",
                                  "RRA:MIN:0.5:5:48",
                                  "RRA:MAX:0.5:5:48",
                                  "RRA:AVERAGE:0.5:1:48")


def actualizacion():
    for direccion in DIRECCIONES:
        lista = ["ping", direccion, "-c", "1"]
        resultado = subprocess.check_output(lista)
        resultado = resultado.decode("utf-8")
        regex = re.compile(".*time=([0-9.]*) ms")
        r = regex.findall(resultado)[0]
        dato = float(r)
        archivo = "{}/{}.rrd".format(RUTA, direccion)
        rrd_update(archivo, "N:{}".format(dato))


crear_base()
actualizacion()
