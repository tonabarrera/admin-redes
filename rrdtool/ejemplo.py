from rrdtool import create as rrd_create
from rrdtool import update as rrd_update
from rrdtool import graph as rrd_graph
from rrdtool import fetch as rrd_fetch
import pdb


def crear_base():
    base = rrd_create("test.rrd",
                      "--start", "920804400",
                      "DS:speed:COUNTER:600:U:U",
                      "RRA:AVERAGE:0.5:1:24",
                      "RRA:AVERAGE:0.5:6:10")


def actualizar_base():
    lista = ["920804700:12345", "920805000:12357", "920805300:12363",
             "920805600920809200:12363", "920805900:12363", "920806200:12373",
             "920806500:12383", "920806800:12393", "920807100:12399",
             "920807400:12405", "920807700:12411", "920808000:12415",
             "920808300:12420", "920808600:12422", "920808900:12423"]
    for elemento in lista:
        res = rrd_update("test.rrd", elemento)


def obtener_datos():
    res = rrd_fetch("test.rrd",
                    "AVERAGE",
                    "--start", "920804400",
                    "--end", "920809200")
    pdb.set_trace()


def graficar():
    res = rrd_graph("speed.png",
                    "--start", "920804400",
                    "--end", "920808000",
                    "DEF:myspeed=test.rrd:speed:AVERAGE",
                    "LINE1:myspeed#FF0000:Mi velocidad")
    # En lugar de escapar el operador podemos escribir entre comillas
    # En python no es necesario hacer esto
    res = rrd_graph("speed2.png",
                    "--start", "920804400",
                    "--end", "920808000",
                    "--vertical-label", "m/s",
                    "DEF:myspeed=test.rrd:speed:AVERAGE",
                    "CDEF:realspeed=myspeed,1000,*",
                    "LINE1:realspeed#FF0000:Velocidad real")

    # En consola para poder usar espacios se usan comillas
    """
    Check if kmh is greater than 100    ( kmh,100 ) GT
    If so, return 0, else kmh           ((( kmh,100 ) GT ), 0, kmh) IF
    """

    """
    Check if kmh is greater than 100    ( kmh,100 ) GT
    If so, return kmh, else return 0    ((( kmh,100) GT ), kmh, 0) IF
    """
    res = rrd_graph("speed3.png",
                    "--start", "920804400",
                    "--end", "920808000",
                    "--vertical-label", "km/h",
                    "DEF:myspeed=test.rrd:speed:AVERAGE",
                    "CDEF:kmh=myspeed,3600,*",
                    "CDEF:fast=kmh,100,GT,kmh,0,IF",
                    "CDEF:good=kmh,100,GT,0,kmh,IF",
                    "HRULE:100#0000FF:Maximo permitido",
                    "AREA:good#00FF00:Velocidad buena",
                    "AREA:fast#FF0000:Demasido rapido")


graficar()
