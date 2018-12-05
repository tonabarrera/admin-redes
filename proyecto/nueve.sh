#!/bin/bash
# nueve.sh
direccion=$1
usado=$(snmpget -v 1 -c public -OQUv $direccion 1.3.6.1.4.1.2021.9.1.9.1)
libre=$(( 100 - usado ))
LIMITE=70

# No debe de ser menor que el 70 por ciento
numCompare() {
   local me=$(awk -v lim="$1" -v res="$2" 'BEGIN { printf (res<lim?"1":"0") }')
   echo "$me"
}

eva=$(numCompare $LIMITE $libre)

if [[ eva -eq 1 ]]; then
    echo "MENOR"
    swaks --to "carlostonatihu@gmail.com" \
    --from "tonatihubarrera@outlook.com" \
    -s smtp-mail.outlook.com:587 -tls -a --auth LOGIN \
    --auth-user "tonatihubarrera@outlook.com" \
    --auth-password "CONTRA" \
    --data "Date: %DATE% \n
    To: %TO_ADDRESS% \n
    From: %FROM_ADDRESS% \n
    Subject: A9; $direccion; almacenamiento \n
    X-Mailer: swaks v$p_versionjetmore.org/john/code/swaks/ \n
    %NEW_HEADERS% \n
    El espacio en almacenamiento es menor que el 70% \n"
fi
# almacenamiento diferenciado dinamicamente