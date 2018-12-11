#!/bin/bash
# seis.sh
# A6 No se puede administrar via snmp
direcciones="127.0.0.1"
directorio=/home/tonatihu/Documents/septimo/admin-redes/proyecto
for direccion in $direcciones; do
    archivo_temporal="$directorio/snmp-$direccion.txt"
    snmpwalk -v 1 -c public $direccion sysDescr.0 > $archivo_temporal 2>&1
    if grep -q "Timeout" $archivo_temporal; then
        echo "MAL"
        swaks --to "carlostonatihu@gmail.com" \
        --from "tonatihubarrera@outlook.com" \
        -s smtp-mail.outlook.com:587 -tls -a --auth LOGIN \
        --auth-user "tonatihubarrera@outlook.com" \
        --auth-password "" \
        --data "Date: %DATE% \nTo: %TO_ADDRESS% \nFrom: %FROM_ADDRESS% 
    \nSubject: A6; $direccion; fallo en agente snmp 
    \nX-Mailer: swaks v20181104 jetmore.org/john/code/swaks/
    \n%NEW_HEADERS%\n"
    else
        echo "BIEN"
    fi
    rm $archivo_temporal
done

