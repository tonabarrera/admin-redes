#!/bin/bash
direcciones=("127.0.0.1")

for direccion in ${direcciones[@]}; do
    num_interfaces=$(snmpwalk -v 2c -c public $direccion ifIndex | awk 'END{print NR}')
    for (( i = 1; i <= $num_interfaces; i++ )); do
        ifInErrors=$(snmpget -v 1 -c public -OQUv localhost 1.3.6.1.2.1.2.2.1.14.$i)
        ifInUcastpkts=$(snmpget -v 1 -c public -OQUv localhost 1.3.6.1.2.1.2.2.1.11.$i)
        ifInNUcastPkts=$(snmpget -v 1 -c public -OQUv localhost 1.3.6.1.2.1.2.2.1.12.$i)
        ifInOctets=$(snmpget -v 1 -c public -OQUv localhost 1.3.6.1.2.1.2.2.1.10.$i)
        ifOutOctets=$(snmpget -v 1 -c public -OQUv localhost 1.3.6.1.2.1.2.2.1.16.$i)
        ifSpeed=$(snmpget -v 1 -c public -OQUv localhost 1.3.6.1.2.1.2.2.1.16.$i)
        echo $ifInErrors $ifInUcastpkts $ifInNUcastPkts $ifInOctets $ifOutOctets $ifSpeed
    done
done
