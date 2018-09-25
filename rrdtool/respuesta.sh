#!/bin/bash
#respuesta
# Cambiar el step a 5 min
if [ ! -f /home/tonatihu/Documents/septimo/admin-redes/rrdtool/respuesta.rrd ]; then
    echo "No existe"
    rrdtool create /home/tonatihu/Documents/septimo/admin-redes/rrdtool/respuesta.rrd --start 1537914720  --step 30 \
    DS:tiempo:GAUGE:40:U:U \
    RRA:AVERAGE:0.5:1:120
else
    echo "Existe"
fi
tiempo=$(ping github.com -c 1 | awk -F'time=' '/time=/ {print $2}' | awk -F' ' '{print $1}')
rrdtool update /home/tonatihu/Documents/septimo/admin-redes/rrdtool/respuesta.rrd N:$tiempo
echo $tiempo >> /home/tonatihu/Documents/septimo/admin-redes/rrdtool/texto.csv
# rrdtool update respuesta.rrd 15379047254:20
# rrdtool fetch test.rrd AVERAGE --start 920804400 --end 920809200

# rrdtool graph speed.png \
# --start 920804400 --end 920808000 \
# DEF:myspeed=test.rrd:speed:AVERAGE \
# LINE2:myspeed#FF0000