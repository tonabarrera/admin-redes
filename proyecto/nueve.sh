#!/bin/bash
# nueve.sh
# El espacio de almacenamiento es menor que el 70%
direcciones=('localhost' '127.0.0.1')
LIMITE=70

# No debe de ser menor que el 70 por ciento
comparacion() {
   local me=$(awk -v lim="$1" -v valor="$2" 'BEGIN { printf (valor<lim?1:0) }')
   echo "$me"
}

for direccion in ${direcciones[@]}; do
    usado=$(snmpget -v 1 -c public -OQUv $direccion 1.3.6.1.4.1.2021.9.1.9.1)
    libre=$(( 100 - usado ))
    eva=$(comparacion $LIMITE $libre)

    #echo $libre

    if [ $eva -eq 1 ]; then
    echo "MENOR"
    swaks --to "carlostonatihu@gmail.com" \
        --from "tonatihubarrera@outlook.com" \
        -s smtp-mail.outlook.com:587 -tls -a --auth LOGIN \
        --auth-user "tonatihubarrera@outlook.com" \
        --auth-password "" \
        --data "Date: %DATE% \nTo: %TO_ADDRESS% \nFrom: %FROM_ADDRESS% 
    \nSubject: A9; $direccion; almacenamiento 
    \nX-Mailer: swaks v20181104 jetmore.org/john/code/swaks/
    \n%NEW_HEADERS%\n"
    else
        echo "BIEN"
    fi
done
