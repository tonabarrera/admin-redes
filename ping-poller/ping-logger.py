import subprocess
import pdb
import re
import os.path
import time
import datetime

host = "google.com"
lista = ["ping", host, "-c", "1"]
tiempo = time.time()
tiempo = datetime.datetime.fromtimestamp(tiempo).strftime('%Y-%m-%d %H:%M:%S')
try:
    resultado = subprocess.check_output(lista)
    resultado = resultado.decode("utf-8")
    regex = re.compile(".*time=([0-9.]* [a-z][a-z])")
    r = regex.findall(resultado)[0]
    resultado = r
except Exception as e:
    resultado = "NaN"

archivo = open('/home/tona/Documents/sexto/redes3/ping-logger/salida.txt', "a")
resultado = "{} [{}] {}\n".format(host, tiempo, resultado)
archivo.write(resultado)
archivo.close()
"""
    tamanio del archivo tras un ping 40 bytes
    Se hace un ping cada 1 minutos
    En una hora se hacen 60 pings
    En un dia se hacen 1440 pings
    En un anio se hacen 525600
    Por lo que en un anio el tamaño del archivo sera 21024000 bytes = 21.045 MB
"""
