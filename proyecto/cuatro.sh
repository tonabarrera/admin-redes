#!/bin/bash
# cuatro.sh
# A4 El tiempo de respuesta del servidor web excede 10 segundos
# Lista de direcciones IP a monitorear separadas por un espacio
direcciones="10.0.1.254"
 # Tiempo limite en segundos
LIMITE=10
# directorio donde se guardan los archivos que se generen
directorio=/home/tc/gestor

# Retorna 1 si valor es mayor a limite
comparacion() {
   local me=$(awk -v lim="$1" -v valor="$2" 'BEGIN { printf (valor>lim?1:0) }')
   echo "$me"
}

for direccion in $direcciones; do
    # Respuesta en segundos
    tiempo=$(curl -s -w %{time_total}\\n -o /dev/null $direccion)
    eva=$(comparacion $LIMITE $tiempo)

    #echo $tiempo

    if [ $eva -eq 1 ]; then
        # Si se excede se guarda una incidencia y se manda un correo electronico
        fecha=$(date +%y/%m/%d-%H:%M:%S)
        # Se registra la incidencia en el directorio y en el archivo incidencias
        echo "A4;$direccion;retardo http;$fecha" >> $directorio/incidencias.log
        # Envio de correo
        #    perl swaks --to "carlostonatihu@gmail.com" \
        #    --from "tonatihubarrera@outlook.com" \
        #    -s smtp-mail.outlook.com:587 -tls -a --auth LOGIN \
        #    --auth-user "tonatihubarrera@outlook.com" \
        #    --auth-password "N3gastupadr3.90" \
        #    --data "Date: %DATE% \nTo: %TO_ADDRESS% \nFrom: %FROM_ADDRESS% 
        #\nSubject: A4; $direccion; retardo http 
        #\nX-Mailer: swaks v20181104 jetmore.org/john/code/swaks/
        #\n%NEW_HEADERS%\n"
    fi
done
