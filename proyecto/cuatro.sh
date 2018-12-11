#!/bin/bash
# cuatro.sh
# A4 El tiempo de respuesta del servidor web excede 10 segundos
direcciones="localhost"
LIMITE=.1 # Los diez segundos

# Retorna 1 si valor es mayor a limite
comparacion() {
   local me=$(awk -v lim="$1" -v valor="$2" 'BEGIN { printf (valor>lim?1:0) }')
   echo "$me"
}

for direccion in $direcciones; do
    # Respuesta en segundos
    tiempo=$(curl -s -w %{time_total}\\n -o /dev/null $direccion)
    eva=$(comparacion $LIMITE $tiempo)

    echo $tiempo

    if [ $eva -eq 1 ]; then
        echo "MAYOR"
            swaks --to "carlostonatihu@gmail.com" \
            --from "tonatihubarrera@outlook.com" \
            -s smtp-mail.outlook.com:587 -tls -a --auth LOGIN \
            --auth-user "tonatihubarrera@outlook.com" \
            --auth-password "N3gastupadr3.90" \
            --data "Date: %DATE% \nTo: %TO_ADDRESS% \nFrom: %FROM_ADDRESS% 
        \nSubject: A4; $direccion; retardo http 
        \nX-Mailer: swaks v20181104 jetmore.org/john/code/swaks/
        \n%NEW_HEADERS%\n"
    else
        echo "MENOR"
    fi
done
