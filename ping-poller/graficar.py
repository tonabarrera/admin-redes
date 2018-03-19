from rrdtool import graph as rrd_graph

DIRECCIONES = ["github.com", "127.0.0.1", "148.204.58.221"]
RUTA = "/home/tona/Documents/sexto/redes3/ping-poller"


def graficar():
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
                  "GPRINT:mitiempo:AVERAGE:Promedio\: %.3lf",
                  "GPRINT:mitiempo:MAX:Máximo\: %.3lf",
                  "GPRINT:mitiempo:MIN:Mínimo\: %.3lf")

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
                      "GPRINT:mi_tiempo:AVERAGE:Promedio\:0 %.2lf ",
                      "GPRINT:mi_tiempo:MAX: Máximo\: %.2lf",
                      "GPRINT:mi_tiempo:MIN:Mínimo\: %.2lf")


graficar()
