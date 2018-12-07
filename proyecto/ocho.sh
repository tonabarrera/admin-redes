#!/bin/bash
# ocho.sh
direccion=$1
LIMITE=0.8
disponible=$(snmpget -v 1 -c public -OQUv $direccion 1.3.6.1.4.1.2021.4.6.0)
total=$(snmpget -v 1 -c public -OQUv $direccion 1.3.6.1.4.1.2021.4.5.0)
# Porcentaje de memoria disponible
porcentaje=$(echo "scale=2; $disponible/$total" | bc -l)

numCompare() {
   local me=$(awk -v lim="$1" -v res="$2" 'BEGIN { printf (res<lim?"1":"0") }')
   echo "$me"
}

eva=$(numCompare $LIMITE $porcentaje)

if [[ eva -eq 1 ]]; then
    swaks --to "carlostonatihu@gmail.com" \
    --from "tonatihubarrera@outlook.com" \
    -s smtp-mail.outlook.com:587 -tls -a --auth LOGIN \
    --auth-user "tonatihubarrera@outlook.com" \
    --auth-password "CONTRA" \
    --data "Date: %DATE% \n
    To: %TO_ADDRESS% \n
    From: %FROM_ADDRESS% \n
    Subject: A8; $direccion; memoria \n
    X-Mailer: swaks v$p_versionjetmore.org/john/code/swaks/ \n
    %NEW_HEADERS% \n
    La memoria real disponible es menor del 80% del total \n"
fi