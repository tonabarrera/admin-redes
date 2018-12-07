#!/bin/bash
# dos.sh
# Script para las incidencias A2
# A2  No ha respondido al ping más de 20 segundos A2; IP; falla en ping
# Pra A2 Sacarlo a otro script
direccion=$@
base=/home/tonatihu/Documents/septimo/admin-redes/proyecto/$direccion.rrd
valor=$(rrdtool lastupdate $base | awk '/:/ {print $2}')
echo $valor
if [ "$valor"="U" ]; then
    echo "NO respondio en 20 s"
    # swaks --to "carlostonatihu@gmail.com" \
    # --from "tonatihubarrera@outlook.com" \
    # -s smtp-mail.outlook.com:587 -tls -a --auth LOGIN \
    # --auth-user "tonatihubarrera@outlook.com" \
    # --auth-password "CONTRA" \
    # --data "Date: %DATE% \n
    # To: %TO_ADDRESS% \n
    # From: %FROM_ADDRESS% \n
    # Subject: A2; $direccion; falla en ping \n
    # X-Mailer: swaks v$p_versionjetmore.org/john/code/swaks/ \n
    # %NEW_HEADERS% \n
    # No ha respondido al ping más de 20 segundos \n"
else
    echo "Si respondio"
fi