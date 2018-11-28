#!/bin/bash
# cuatro.sh
# A4 El tiempo de respuesta del servidor web excede 10 segundos
direccion=$@
LIMITE=10 # Los diez segundos
# Respuesta en segundos
tiempo=$(curl -s -w %{time_total}\\n -o /dev/null $direccion)

numCompare() {
   local me=$(awk -v lim="$1" -v res="$2" 'BEGIN { printf (res>lim?"1":"0") }')
   echo "$me"
}

eva=$(numCompare $LIMITE $tiempo)

if [[ eva -eq 1 ]]; then
    swaks --to "carlostonatihu@gmail.com" \
    --from "tonatihubarrera@outlook.com" \
    -s smtp-mail.outlook.com:587 -tls -a --auth LOGIN \
    --auth-user "tonatihubarrera@outlook.com" \
    --auth-password "CONTRA" \
    --data "Date: %DATE% \n
    To: %TO_ADDRESS% \n
    From: %FROM_ADDRESS% \n
    Subject: A4; $direccion; retardo http \n
    X-Mailer: swaks v$p_versionjetmore.org/john/code/swaks/ \n
    %NEW_HEADERS% \n
    El tiempo de respuesta del servidor web excede 10 segundos \n"
fi