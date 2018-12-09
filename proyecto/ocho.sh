#!/bin/bash
# ocho.sh
# A8 la memoria real es menor de 80% del total
direcciones=("localhost")
LIMITE=0.8

comparacion() {
   local me=$(awk -v lim="$1" -v valor="$2" 'BEGIN { printf (valor<lim?1:0) }')
   echo "$me"
}

for direccion in ${direcciones[@]}; do
    disponible=$(snmpget -v 1 -c public -OQUv $direccion 1.3.6.1.4.1.2021.4.6.0)
    total=$(snmpget -v 1 -c public -OQUv $direccion 1.3.6.1.4.1.2021.4.5.0)
    # Porcentaje de memoria disponible
    porcentaje=$(echo "scale=2; $disponible/$total" | bc -l)
    echo "disponible $disponible total $total poercentaje $porcentaje"

    eva=$(comparacion $LIMITE $porcentaje)

    if [[ eva -eq 1 ]]; then
        echo "MAL"
        swaks --to "carlostonatihu@gmail.com" \
        --from "tonatihubarrera@outlook.com" \
        -s smtp-mail.outlook.com:587 -tls -a --auth LOGIN \
        --auth-user "tonatihubarrera@outlook.com" \
        --auth-password "" \
        --data "Date: %DATE% \nTo: %TO_ADDRESS% \nFrom: %FROM_ADDRESS% 
    \nSubject: A8; $direccion; memoria 
    \nX-Mailer: swaks v20181104 jetmore.org/john/code/swaks/
    \n%NEW_HEADERS%\n"
    else
        echo "BIEN"
    fi
done
