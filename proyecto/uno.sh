#!/bin/bash
# uno.sh
# A1 la utilización del CPU excede del 60%
# Lista de direcciones IP
direcciones=('localhost')
LIMITE=5

# Funcion de comparacion
comparacion() {
    local me=$(awk -v lim="$1" -v valor="$2" 'BEGIN { printf (valor>lim?1:0) }')
    echo "$me"
}
# Poner un while aqui si es necesario
for direccion in ${direcciones[@]}; do
    libre=$(snmpget -v 1 -c public -OQUv $direccion 1.3.6.1.4.1.2021.11.11.0)
    usado=$(( 100 - libre ))
    echo "$direccion utilizacion: $usado %"

    # No debe de ser mayor que el 60 por ciento
    eva=$(comparacion $LIMITE $usado)

    if [ $eva -eq 1 ]; then
        echo "MAYOR"
        swaks --to "carlostonatihu@gmail.com" \
        --from "tonatihubarrera@outlook.com" \
        -s smtp-mail.outlook.com:587 -tls -a --auth LOGIN \
        --auth-user "tonatihubarrera@outlook.com" \
        --auth-password "" \
        --data "Date: %DATE% \nTo: %TO_ADDRESS% \nFrom: %FROM_ADDRESS% 
    \nSubject: A1; $direccion; utilizacion CPU 
    \nX-Mailer: swaks v20181104 jetmore.org/john/code/swaks/
    \n%NEW_HEADERS%\n"
    else
        echo "BIEN"
    fi
done
