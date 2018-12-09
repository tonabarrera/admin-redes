#!/bin/bash
# --data "Date: %DATE% \nTo: %TO_ADDRESS% \nFrom: %FROM_ADDRESS% 
#     \nSubject: A1; $direccion; utilizacion CPU 
#     \nX-Mailer: swaks v20181104 jetmore.org/john/code/swaks/
#     \n%NEW_HEADERS%
#     \n La utilizacion del CPU excede del 60% \n"
words=$@
for i in $words; do
    echo $i
done
while true; do
    sleep 2
    ls -l
done

