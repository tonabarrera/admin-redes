#!/bin/bash
# seis.sh
# A6 No se puede administrar via snmp
# Lista de direcciones IP a monitorear separadas por un espacio
direcciones="127.0.0.1"
# directorio donde se guardan los archivos que se generen
directorio=/home/tonatihu/Documents/septimo/admin-redes/proyecto
# Comunidad snmp
comunidad=public
for direccion in $direcciones; do
    # archivo temporal que se va a leer para ver si se puede administrar snmp
    archivo_temporal="$directorio/snmp-$direccion.txt"
    snmpwalk -v 1 -c $comunidad $direccion sysDescr.0 > $archivo_temporal 2>&1
    if grep -q "Timeout" $archivo_temporal; then
        # Si se excede se guarda una incidencia y se manda un correo electronico
        fecha=$(date +%y/%m/%d-%H:%M:%S)
        # Se registra la incidencia en el directorio y en el archivo incidencias
        echo "A6;$direccion;fallo en agente snmp;$fecha" >> $directorio/incidencias.log
        #swaks --to "carlostonatihu@gmail.com" \
        #--from "tonatihubarrera@outlook.com" \
        #-s smtp-mail.outlook.com:587 -tls -a --auth LOGIN \
        #--auth-user "tonatihubarrera@outlook.com" \
        #--auth-password "" \
        #--data "Date: %DATE% \nTo: %TO_ADDRESS% \nFrom: %FROM_ADDRESS% 
    #\nSubject: A6;$direccion;fallo en agente snmp 
    #\nX-Mailer: swaks v20181104 jetmore.org/john/code/swaks/
    #\n%NEW_HEADERS%\n"
    fi
    rm $archivo_temporal
done

