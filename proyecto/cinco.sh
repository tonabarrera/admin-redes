#!/bin/bash
# cinco.sh
original=$1 # configuracion original
nuevo=$2 # configuracion nueva
# Regreso 1 si no son iguales
resultado=$(cmp -s $original $nuevo && echo "0" || echo "1")

if [[ $resultado -eq 1 ]]; then
    swaks --to "carlostonatihu@gmail.com" \
    --from "tonatihubarrera@outlook.com" \
    -s smtp-mail.outlook.com:587 -tls -a --auth LOGIN \
    --auth-user "tonatihubarrera@outlook.com" \
    --auth-password "CONTRA" \
    --data "Date: %DATE% \n
    To: %TO_ADDRESS% \n
    From: %FROM_ADDRESS% \n
    Subject: A5; $direccion; alteracion de la configuracion \n
    X-Mailer: swaks v$p_versionjetmore.org/john/code/swaks/ \n
    %NEW_HEADERS% \n
    Cambio en la configuración (la configuración en ejecución 
    no concuerda con el ultimo respaldo) \n"
fi