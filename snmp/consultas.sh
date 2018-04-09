#!/bin/sh

# Temperatura
# Utilizacion CPU
# Total de memoria RAM
snmpget -v 1 -c public localhost 1.3.6.1.4.1.2021.4.5.0
# Uso de memoria RAM
snmpget -v 1 -c public localhost 1.3.6.1.4.1.2021.4.6.0
# Total de almacenamiento
snmpget -v 1 -c public localhost 1.3.6.1.4.1.2021.9.1.6.1
# Uso de almacenamiento
snmpget -v 1 -c public localhost 1.3.6.1.4.1.2021.9.1.8.1
