#!/bin/bash
# tres.sh
# A3  Retardo en respuesta del ping mayor a 5 segundos    A3; IP; retardo en ping
direcciones="github.com"
LIMITE=83 # Tiempo limite en milisegundos
directorio=/home/tonatihu/Documents/septimo/admin-redes/proyecto/rrd

 # retorna 1 si valor es mayor que limite
comparacion() {
   local me=$(awk -v lim="$1" -v valor="$2" 'BEGIN { printf (valor>lim?1:0) }')
   echo "$me"
}

# variable=$(date +%y/%m/%d-%H:%M:%S)
while true; do
for direccion in $direcciones; do
    base="$directorio/tres-$direccion.rrd"
    if [ ! -f $base ]; then
        rrdtool create $base  --step 5 \
        DS:tiempo:GAUGE:21:U:U \
        RRA:AVERAGE:0.5:1:720
    else
        echo "EXISTE $direccion"
    fi

    tiempo=$(ping $direccion -c 1 | awk -F'time=' '/time=/ {print $2}' | awk -F' ' '{print $1}')
    echo $tiempo
    rrdtool update $base N:$tiempo
    eva=$(comparacion $LIMITE $tiempo)

    # Para A3
    if [ $eva -eq 1 ]; then
        echo "Retardo mayor a $LIMITE milisegundos"
    #     swaks --to "carlostonatihu@gmail.com" \
    #     --from "tonatihubarrera@outlook.com" \
    #     -s smtp-mail.outlook.com:587 -tls -a --auth LOGIN \
    #     --auth-user "tonatihubarrera@outlook.com" \
    #     --auth-password "" \
    #     --data "Date: %DATE% \nTo: %TO_ADDRESS% \nFrom: %FROM_ADDRESS% 
    # \nSubject: A3; $direccion; retardo en ping 
    # \nX-Mailer: swaks v20181104 jetmore.org/john/code/swaks/
    # \n%NEW_HEADERS%\n"
    else
        echo "No hay retardo"
    fi
done
    sleep 5
done
