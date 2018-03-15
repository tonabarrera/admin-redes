from rrdtool import graph as rrd_graph


def graficar():
    for sched in ['daily', 'weekly', 'monthly']:
        if sched == 'weekly':
            period = 'w'
        elif sched == 'daily':
            period = 'd'
        else:
            period = 'm'
        print(sched)
        grafica = rrd_graph("ping-time-{}.png".format(sched),
                            "--start", "-1{}".format(period),
                            "--vertical-label=Numero",
                            "--watermark=Marca de agua chida",
                            "-w 800",
                            "DEF:m1_num=ping_logger.rrd:tiempo:AVERAGE",
                            "LINE1:m1_num#0000FF:m1",
                            "GPRINT:m1_num:AVERAGE:Pro m1\: %6.0lf ",
                            "GPRINT:m1_num:MAX: Max m1\: %6.0lf")


graficar()
