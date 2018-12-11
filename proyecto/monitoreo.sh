#!/bin/bash
# uno.sh
# A1 la utilización del CPU excede del 60%
# Lista de direcciones IP
direcciones="localhost"
directorio=/home/tonatihu/Documents/septimo/admin-redes/proyecto/rrd

# Poner un while aqui si es necesario
for direccion in $direcciones; do
    base="$directorio/monitoreo-$direccion.rrd"
    if [ ! -f $base ]; then
        rrdtool create $base  --step 60 \
        DS:usoCPU:GAUGE:120:U:U \
        DS:usoMemoria:GAUGE:70:U:U \
        DS:usoDisco:GAUGE:70:U:U \
        RRA:AVERAGE:0.5:1:60
    else
        echo "EXISTE $direccion"
    fi
    cpu_libre=$(snmpget -v 1 -c public -OQUv $direccion 1.3.6.1.4.1.2021.11.11.0)
    cpu_usado=$(( 100 - cpu_libre ))
    disco_usado=$(snmpget -v 1 -c public -OQUv $direccion 1.3.6.1.4.1.2021.9.1.9.1)
    memoria_disponible=$(snmpget -v 1 -c public -OQUv $direccion 1.3.6.1.4.1.2021.4.6.0)
    memoria_total=$(snmpget -v 1 -c public -OQUv $direccion 1.3.6.1.4.1.2021.4.5.0)
    # porcentaje de memoria usado
    porcentaje=$(echo "scale=2; (1-($memoria_disponible/$memoria_total))*100" | bc -l)
    #echo $memoria_total $memoria_disponible $porcentaje
    rrdtool update $base N:$cpu_usado:$porcentaje:$disco_usado
done
