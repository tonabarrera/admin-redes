#!/bin/bash
# ocho.sh
# A8 la memoria real es menor de 80% del total
# Lista de direcciones IP a monitorerar separadas por un espacio
direcciones="10.0.1.254"
# limite a utilizar
LIMITE=0.8
# comunidad snmp
comunidad=public
# directorio donde se guardan los archivos que se generen
directorio=/home/tc/gestor

# Funcion de comparacion, retorna 1 si valor es menor a limite
comparacion() {
   local me=$(awk -v lim="$1" -v valor="$2" 'BEGIN { printf (valor<lim?1:0) }')
   echo "$me"
}

for direccion in $direcciones; do
    # Consulta de memoria disponible
    disponible=$(snmpget -v 1 -c $comunidad -OQUv $direccion 1.3.6.1.4.1.2021.4.6.0)
    # Consulta de memoria total
    total=$(snmpget -v 1 -c $comunidad -OQUv $direccion 1.3.6.1.4.1.2021.4.5.0)
    # Porcentaje de memoria disponible
    porcentaje=$(echo "scale=2; $disponible/$total" | bc -l)
    #echo "disponible $disponible total $total poercentaje $porcentaje"

    eva=$(comparacion $LIMITE $porcentaje)

    if [[ eva -eq 1 ]]; then
        # Si se excede se guarda una incidencia y se manda un correo electronico
        fecha=$(date +%y/%m/%d-%H:%M:%S)
        # Se registra la incidencia en el directorio y en el archivo incidencias
        echo "A8;$direccion;memoria;$fecha" >> $directorio/incidencias.log
    # Codigo para enviar un correo
    #     perl swaks --to "carlostonatihu@gmail.com" \
    #     --from "tonatihubarrera@outlook.com" \
    #     -s smtp-mail.outlook.com:587 -tls -a --auth LOGIN \
    #     --auth-user "tonatihubarrera@outlook.com" \
    #     --auth-password "" \
    #     --data "Date: %DATE% \nTo: %TO_ADDRESS% \nFrom: %FROM_ADDRESS% 
    # \nSubject: A8; $direccion; memoria 
    # \nX-Mailer: swaks v20181104 jetmore.org/john/code/swaks/
    # \n%NEW_HEADERS%\n"
    fi
done
