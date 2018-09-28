#!/bin/bash
#script.sh
direccion=127.0.0.1
variable=$(date +%y/%m/%d-%H:%M:%S)
tiempo=$(ping $direccion -c 1 | awk -F'time=' '/time=/ {print $2}' | awk -F' ' '{print $1}')
base=/home/tonatihu/Documents/$direccion.rrd

if [ ! -f $base ]; then
    echo "Creando"
    rrdtool create $base  --step 60 \
    DS:tiempo:GAUGE:70:U:U \
    RRA:AVERAGE:0.5:1:120
else
    echo "Existe"
fi
rrdtool update $base N:$tiempo
echo $tiempo
limite=35
# retorna 1 si res es mayor que limite
# cero en otro caso
numCompare() {
   local me=$(awk -v lim="$1" -v res="$2" 'BEGIN {printf (res>lim?"1":"0") }')
   echo "$me"
}

eva=$(numCompare $limite $tiempo)


if [[ eva -eq 1 ]]; then
    swaks --to "carlostonatihu@gmail.com" \
    --from "tonatihubarrera@outlook.com" \
    -s smtp-mail.outlook.com:587 -tls -a --auth LOGIN \
    --auth-user "tonatihubarrera@outlook.com" \
    --auth-password "" \
    --data "Date: %DATE% \nTo: %TO_ADDRESS% \nFrom: %FROM_ADDRESS% 
    \nSubject: No responde al ping la direccion: $direccion =( 
    \nX-Mailer: swaks v$p_versionjetmore.org/john/code/swaks/\n%NEW_HEADERS%
    \n No responde el ping la interfaz con la dirección: $direccion \n"
fi
