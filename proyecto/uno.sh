#!/bin/bash
# uno.sh
# A1 la utilización del CPU excede del 60%
# Lista de direcciones IP a monitorear separadas por un espacio
direcciones="localhost"
# limite a utilizar
LIMITE=60
# comunidad snmp
comunidad=public
# directorio donde se guardan los archivos que se generen
directorio=/home/tonatihu/Documents/septimo/admin-redes/proyecto

# Funcion de comparacion, retorna 1 si valor es mayor a limite
comparacion() {
    local me=$(awk -v lim="$1" -v valor="$2" 'BEGIN { printf (valor>lim?1:0) }')
    echo "$me"
}

for direccion in $direcciones; do
    # comando snmp y oid a consultar
    usado=$(snmpget -v 1 -c $comunidad -OQUv $direccion 1.3.6.1.2.1.25.3.3.1.2.196608)

    # No debe de ser mayor que el LIMITE por ciento
    eva=$(comparacion $LIMITE $usado)

    if [ $eva -eq 1 ]; then
        # Si se excede se guarda una incidencia y se manda un correo electronico
        fecha=$(date +%y/%m/%d-%H:%M:%S)
        # Se registra la incidencia en el directorio y en el archivo incidencias
        echo "A1;$direccion;utilizacion CPU;$fecha" >> $directorio/incidencias.log
    # Codigo para enviar un correo
    #     perl swaks --to "carlostonatihu@gmail.com" \
    #     --from "tonatihubarrera@outlook.com" \
    #     -s smtp-mail.outlook.com:587 -tls -a --auth LOGIN \
    #     --auth-user "tonatihubarrera@outlook.com" \
    #     --auth-password "" \
    #     --data "Date: %DATE% \nTo: %TO_ADDRESS% \nFrom: %FROM_ADDRESS% 
    # \nSubject: A1; $direccion; utilizacion CPU 
    # \nX-Mailer: swaks v20181104 jetmore.org/john/code/swaks/
    # \n%NEW_HEADERS%\n"
    fi
done
