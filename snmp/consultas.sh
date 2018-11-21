#!/bin/sh

# Temperatura
# Utilizacion CPU
snmpget -v 1 -c public -OQUv localhost 1.3.6.1.4.1.2021.11.52.0
# Uso de memoria RAM
snmpget -v 1 -c public -OQUv localhost 1.3.6.1.4.1.2021.4.6
# Uso de almacenamiento
snmpget -v 1 -c public -OQUv localhost 1.3.6.1.4.1.2021.9.1.8.1
# CPU load
snmpget -v 1 -c public -OQUv localhost 1.3.6.1.4.1.2021.10.1.3.1