#!/bin/bash
# interfaces.sh
# Direcciones ip a monitorear
direcciones="10.0.1.254"
# Directorio donde se guardan los archivos
directorio=/home/tc/gestor
# Comunidad snmp
comunidad=public
for direccion in $direcciones; do
    # num_interfaces=$(snmpwalk -v 1 -c public $direccion ifIndex | awk 'END{print NR}')
    for i in 1 2 3 4 5; do
        # Si no existe se crea un subdirectorio para la ip monitorear
        subdirectorio="$directorio/$direccion"
        if [ ! -d $subdirectorio ]; then
            mkdir $subdirectorio
        fi
        # Base de datos por interfaz
        base="$subdirectorio/interfaz-$i.rrd"
        # Si no existe se crea la base de rrdtool para cada interfaz de ip a monitorear
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
        ifSpeed=$(snmpget -v 1 -c public -OQUv localhost 1.3.6.1.2.1.2.2.1.5.$i)
        # echo $ifInErrors $ifInUcastpkts $ifInNUcastPkts $ifInOctets $ifOutOctets $ifSpeed
        rrdtool update $base N:$ifInErrors:$ifInUcastpkts:$ifInNUcastPkts:$ifInOctets:$ifOutOctets:$ifSpeed
    done
done
