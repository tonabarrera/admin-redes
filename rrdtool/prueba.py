from rrdtool import create as rrd_create
from rrdtool import update as rrd_update
from rrdtool import graph as rrd_graph


def crear_base():
    base = rrd_create("prueba.rrd",
                      "--step", "1800", "--start", '0',
                      "DS:metrica1:GAUGE:2000:U:U",
                      "DS:metrica2:GAUGE:2000:U:U",
                      "RRA:AVERAGE:0.5:1:600",
                      "RRA:AVERAGE:0.5:6:700",
                      "RRA:AVERAGE:0.5:24:775",
                      "RRA:AVERAGE:0.5:288:797",
                      "RRA:MAX:0.5:1:600",
                      "RRA:MAX:0.5:6:700",
                      "RRA:MAX:0.5:24:775",
                      "RRA:MAX:0.5:444:797")


def actualizar_base():
    valor1 = 777
    valor2 = 90
    actualizacion = rrd_update('prueba.rrd', "N:{}:{}".format(valor1, valor2))


def graficar():
    for sched in ['daily', 'weekly', 'monthly']:
        if sched == 'weekly':
            period = 'w'
        elif sched == 'daily':
            period = 'd'
        else:
            period = 'm'
        print(sched)
        grafica = rrd_graph("metrica-{}.png".format(sched),
                            "--start", "-1{}".format(period),
                            "--vertical-label=Numero",
                            "--watermark=Marca de agua chida",
                            "-w 800",
                            "DEF:m1_num=prueba.rrd:metrica1:AVERAGE",
                            "DEF:m2_num=prueba.rrd:metrica2:AVERAGE",
                            "LINE1:m1_num#0000FF:m1",
                            "LINE2:m2_num#00FF00:m2",
                            "GPRINT:m1_num:AVERAGE:Pro m1\: %6.0lf ",
                            "GPRINT:m1_num:MAX: Max m1\: %6.0lf",
                            "GPRINT:m2_num:AVERAGE:Pro m2\: %6.0lf ",
                            "GPRINT:m2_num:MAX:Max m2\: %6.0lf")

# crear_base()
# actualizar_base()


graficar()
