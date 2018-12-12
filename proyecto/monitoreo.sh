#!/bin/bash
# monitoreo.sh
# script para el monitoreo de varias IP
# Lista de direcciones IP a monitorerar separadas por un espacio
direcciones="10.0.1.254"
# directorio donde se guardan los archivos que se generen
directorio=/home/tc/gestor
# comunidad snmp
comunidad=public

# Poner un while aqui si es necesario
for direccion in $direcciones; do
    # Si no existe se crea un subdirectorio para la ip monitorear
    subdirectorio="$directorio/$direccion"
    if [ ! -d $subdirectorio ]; then
        mkdir $subdirectorio
    fi
    base="$subdirectorio/monitoreo.rrd"
    if [ ! -f $base ]; then
        rrdtool create $base  --step 60 \
        DS:usoCPU:GAUGE:120:U:U \
        DS:usoMemoria:GAUGE:70:U:U \
        RRA:AVERAGE:0.5:1:60
    fi
    # comandos snmp y oids a consultar
    cpu_usado=$(snmpget -v 1 -c $comunidad -OQUv $direccion 1.3.6.1.2.1.25.3.3.1.2.768)
    memoria_disponible=$(snmpget -v 1 -c $comunidad -OQUv $direccion 1.3.6.1.4.1.2021.4.6.0)
    memoria_total=$(snmpget -v 1 -c $comunidad -OQUv $direccion 1.3.6.1.4.1.2021.4.5.0)
    # porcentaje de memoria usado
    porcentaje=$(echo "scale=2; (1-($memoria_disponible/$memoria_total))*100" | bc -l)
    #echo $memoria_total $memoria_disponible $porcentaje
    rrdtool update $base N:$cpu_usado:$porcentaje
done
