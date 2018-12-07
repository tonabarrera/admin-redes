#!/bin/bash
# tres.sh
# Script para las incidencias A3
# A2  No ha respondido al ping más de 20 segundos A2; IP; falla en ping
# A3  Retardo en respuesta del ping mayor a 5 segundos    A3; IP; retardo en ping
direccion=$@
LIMITE=65 # Tiempo limite en milisegundos
base=/home/tonatihu/Documents/septimo/admin-redes/proyecto/$direccion.rrd
# variable=$(date +%y/%m/%d-%H:%M:%S)
while true; do
    # Si no existe creala
    if [ ! -f $base ]; then
        rrdtool create $base  --step 5 \
        DS:tiempo:GAUGE:21:U:U \
        RRA:AVERAGE:0.5:1:120
    else
        echo "EXISTE"
    fi

    tiempo=$(ping $direccion -c 1 | awk -F'time=' '/time=/ {print $2}' | awk -F' ' '{print $1}')
    echo $tiempo
    #if[ "$tiempo"=" "]; then
    #    tiempo="U"
    #fi

    rrdtool update $base N:$tiempo
    #if [ "$tiempo"="U" ]; then
    #    echo "ES U"
    #    tiempo=5001
    #else
    #    echo "NO es U"
    #fi
    # retorna 1 si res es mayor que limite
    # cero en otro caso
    numCompare() {
       local me=$(awk -v lim="$1" -v res="$2" 'BEGIN { printf (res>lim?"1":"0") }')
       echo "$me"
    }

    eva=$(numCompare $LIMITE $tiempo)

    # Para A3
    if [[ eva -eq 1 ]]; then
        echo "Retardo mayor a 5s"
        # swaks --to "carlostonatihu@gmail.com" \
        # --from "tonatihubarrera@outlook.com" \
        # -s smtp-mail.outlook.com:587 -tls -a --auth LOGIN \
        # --auth-user "tonatihubarrera@outlook.com" \
        # --auth-password "CONTRA" \
        # --data "Date: %DATE% \n
        # To: %TO_ADDRESS% \n
        # From: %FROM_ADDRESS% \n
        # Subject: A3; $direccion; retardo en ping \n
        # X-Mailer: swaks v$p_versionjetmore.org/john/code/swaks/ \n
        # %NEW_HEADERS% \n
        # Retardo en respuesta del ping mayor a 5 segundos \n"
    else
        echo "No hay retardo"
    fi

    sleep 5

done