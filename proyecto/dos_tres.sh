#!/bin/bash
# dos_tres.sh
# Script para las incidencias A2 y A3
# A2  No ha respondido al ping más de 20 segundos A2; IP; falla en ping
# A3  Retardo en respuesta del ping mayor a 5 segundos    A3; IP; retardo en ping
direccion=$@
LIMITE=5000 # Tiempo limite en milisegundos
base=/home/tonatihu/Documents/$direccion.rrd
# variable=$(date +%y/%m/%d-%H:%M:%S)

# Si no existe creala
if [ ! -f $base ]; then
    rrdtool create $base  --step 20 \
    DS:tiempo:GAUGE:21:U:U \
    RRA:AVERAGE:0.5:1:120
fi

tiempo=$(ping $direccion -c 1 | awk -F'time=' '/time=/ {print $2}' | awk -F' ' '{print $1}')
if[ "$tiempo"=""]; then
    tiempo="U"
fi

rrdtool update $base N:$tiempo
if [ "$tiempo"="U" ]; then
    tiempo=5001
fi
# retorna 1 si res es mayor que limite
# cero en otro caso
numCompare() {
   local me=$(awk -v lim="$1" -v res="$2" 'BEGIN { printf (res>lim?"1":"0") }')
   echo "$me"
}

eva=$(numCompare $LIMITE $tiempo)

# Para A3
if [[ eva -eq 1 ]]; then
    swaks --to "carlostonatihu@gmail.com" \
    --from "tonatihubarrera@outlook.com" \
    -s smtp-mail.outlook.com:587 -tls -a --auth LOGIN \
    --auth-user "tonatihubarrera@outlook.com" \
    --auth-password "CONTRA" \
    --data "Date: %DATE% \n
    To: %TO_ADDRESS% \n
    From: %FROM_ADDRESS% \n
    Subject: A3; $direccion; retardo en ping \n
    X-Mailer: swaks v$p_versionjetmore.org/john/code/swaks/ \n
    %NEW_HEADERS% \n
    Retardo en respuesta del ping mayor a 5 segundos \n"
fi

# Pra A2
valor=$(rrdtool lastupdate $base | awk '/:/ {print $2}')
if [ "$tiempo"="U" ]; then
    swaks --to "carlostonatihu@gmail.com" \
    --from "tonatihubarrera@outlook.com" \
    -s smtp-mail.outlook.com:587 -tls -a --auth LOGIN \
    --auth-user "tonatihubarrera@outlook.com" \
    --auth-password "CONTRA" \
    --data "Date: %DATE% \n
    To: %TO_ADDRESS% \n
    From: %FROM_ADDRESS% \n
    Subject: A2; $direccion; falla en ping \n
    X-Mailer: swaks v$p_versionjetmore.org/john/code/swaks/ \n
    %NEW_HEADERS% \n
    No ha respondido al ping más de 20 segundos \n"
fi
