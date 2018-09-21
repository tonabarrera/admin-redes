#!/bin/bash
#script.sh
variable=$(date +%y/%m/%d-%H:%M:%S)
tiempo=$(ping google.com -c 1 | awk -F'time=' '/time=/ {print $2}' | awk -F' ' '{print $1}')

limite=30
# retorna 1 si res es mayor que limite
# cero en otro caso
numCompare() {
   local me=$(awk -v lim="$1" -v res="$2" 'BEGIN {printf (res>lim?"1":"0") }')
   echo "$me"
}

eva=$(numCompare $limite $tiempo)

if [[ eva -eq 1 ]]; then
    echo "$variable $tiempo ms Se paso" >> /home/tonatihu/Documents/log.txt
else
    echo "$variable $tiempo ms Chido" >> /home/tonatihu/Documents/log.txt
fi
