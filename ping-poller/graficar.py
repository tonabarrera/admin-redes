from rrdtool import graph as rrd_graph

DIRECCIONES = ["github.com", "127.0.0.1", "148.204.58.221"]
RUTA = "/home/tona/Documents/sexto/redes3/ping-logger"


def graficar():
    for direccion in DIRECCIONES:
        archivo_rrd = "{}/{}.rrd".format(RUTA, direccion)
        titulo = "Ping de {}".format(direccion)
        nombre_img = "{}/{}-actual.png".format(RUTA, direccion)
        rrd_graph(nombre_img,
                  "--vertical-label", "ms",
                  "--start", "-30m",
                  "--title", titulo,
                  "DEF:mitiempo={}:tiempo:AVERAGE".format(archivo_rrd),
                  "LINE1:mitiempo#FF0000:Tiempo",
                  "GPRINT:mitiempo:AVERAGE:Promedio\: %.3lf",
                  "GPRINT:mitiempo:MAX:Máximo\: %.3lf",
                  "GPRINT:mitiempo:MIN:Mínimo\: %.3lf")

        for sched in ['dia', 'semana', 'mes']:
            if sched == 'dia':
                period = 'd'
            elif sched == 'semana':
                period = 'w'
            else:
                period = 'm'
            # print("{} - {}".format(direccion, sched))
            nombre_img = "{}/{}-{}.png".format(RUTA, direccion, sched)
            titulo = "ping del ultimo {} de {}".format(sched, direccion)
            rrd_graph(nombre_img, "--start", "-1{}".format(period),
                      "--vertical-label=Tiempo",
                      "--title", titulo,
                      "DEF:mi_tiempo={}:tiempo:AVERAGE".format(archivo_rrd),
                      "LINE1:mi_tiempo#0000FF:Tiempo",
                      "GPRINT:mi_tiempo:AVERAGE:Promedio\:0 %.2lf ",
                      "GPRINT:mi_tiempo:MAX: Máximo\: %.2lf",
                      "GPRINT:mi_tiempo:MIN:Mínimo\: %.2lf")


graficar()
