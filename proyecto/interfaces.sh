#!/bin/bash
direcciones="127.0.0.1"
directorio=/home/tonatihu/Documents/septimo/admin-redes/proyecto/rrd
for direccion in $direcciones; do
    num_interfaces=$(snmpwalk -v 1 -c public $direccion ifIndex | awk 'END{print NR}')
    for (( i = 1; i <= $num_interfaces; i++ )); do
        base="$directorio/$direccion-interfaz-$i.rrd"
        if [ ! -f $base ]; then
            rrdtool create $base  --step 60 \
            DS:ifInErrors:GAUGE:120:U:U \
            DS:ifInUcastpkts:GAUGE:120:U:U \
            DS:ifInNUcastPkts:GAUGE:120:U:U \
            DS:ifInOctets:GAUGE:120:U:U \
            DS:ifOutOctets:GAUGE:120:U:U \
            DS:ifSpeed:GAUGE:120:U:U \
            RRA:AVERAGE:0.5:1:60
        fi
        ifInErrors=$(snmpget -v 1 -c public -OQUv localhost 1.3.6.1.2.1.2.2.1.14.$i)
        ifInUcastpkts=$(snmpget -v 1 -c public -OQUv localhost 1.3.6.1.2.1.2.2.1.11.$i)
        ifInNUcastPkts=$(snmpget -v 1 -c public -OQUv localhost 1.3.6.1.2.1.2.2.1.12.$i)
        ifInOctets=$(snmpget -v 1 -c public -OQUv localhost 1.3.6.1.2.1.2.2.1.10.$i)
        ifOutOctets=$(snmpget -v 1 -c public -OQUv localhost 1.3.6.1.2.1.2.2.1.16.$i)
        ifSpeed=$(snmpget -v 1 -c public -OQUv localhost 1.3.6.1.2.1.2.2.1.16.$i)
        # echo $ifInErrors $ifInUcastpkts $ifInNUcastPkts $ifInOctets $ifOutOctets $ifSpeed
        rrdtool update $base N:$ifInErrors:$ifInUcastpkts:$ifInNUcastPkts:$ifInOctets:$ifOutOctets:$ifSpeed
    done
done
