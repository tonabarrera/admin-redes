#!/bin/bash
# tres.sh
# A3  Retardo en respuesta del ping mayor a 5 segundos    A3; IP; retardo en ping
# Lista de direcciones IP a monitorear separadas por un espacio
direcciones="10.0.1.254"
 # Tiempo limite en milisegundos
LIMITE=5000
# directorio donde se guardan los archivos que se generen
directorio=/home/tc/gestor

 # retorna 1 si valor es mayor que limite
comparacion() {
   local me=$(awk -v lim="$1" -v valor="$2" 'BEGIN { printf (valor>lim?1:0) }')
   echo "$me"
}

# variable=$(date +%y/%m/%d-%H:%M:%S)
for direccion in $direcciones; do
    # Si no existe se crea un subdirectorio para la ip monitorear
    subdirectorio="$directorio/$direccion"
    if [ ! -d $subdirectorio ]; then
        mkdir $subdirectorio
    fi
    base="$subdirectorio/ping.rrd"
    # Si no existe se crea la base de rrdtool del ping
    if [ ! -f $base ]; then
        rrdtool create $base  --step 60 \
        DS:tiempo:GAUGE:120:U:U \
        RRA:AVERAGE:0.5:1:60
    fi
    # Obtencion del tiempo de respuesta en ms
    tiempo=$(ping $direccion -c 1 | awk -F'time=' '/time=/ {print $2}' | awk -F' ' '{print $1}')
    #echo $tiempo
    rrdtool update $base N:$tiempo
    eva=$(comparacion $LIMITE $tiempo)

    # Se ejecuta si se supera el limite
    if [ $eva -eq 1 ]; then
        # Si se excede se guarda una incidencia y se manda un correo electronico
        fecha=$(date +%y/%m/%d-%H:%M:%S)
        # Se registra la incidencia en el directorio y en el archivo incidencias
        echo "A3;$direccion;retardo en ping;$fecha" >> $directorio/incidencias.log
    # Codigo para enviar un correo
    #     perl swaks --to "carlostonatihu@gmail.com" \
    #     --from "tonatihubarrera@outlook.com" \
    #     -s smtp-mail.outlook.com:587 -tls -a --auth LOGIN \
    #     --auth-user "tonatihubarrera@outlook.com" \
    #     --auth-password "" \
    #     --data "Date: %DATE% \nTo: %TO_ADDRESS% \nFrom: %FROM_ADDRESS% 
    # \nSubject: A3; $direccion; retardo en ping 
    # \nX-Mailer: swaks v20181104 jetmore.org/john/code/swaks/
    # \n%NEW_HEADERS%\n"
    fi
done
