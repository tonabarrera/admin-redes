#!/bin/bash
# --data "Date: %DATE% \nTo: %TO_ADDRESS% \nFrom: %FROM_ADDRESS% 
#     \nSubject: A1; $direccion; utilizacion CPU 
#     \nX-Mailer: swaks v20181104 jetmore.org/john/code/swaks/
#     \n%NEW_HEADERS%
#     \n La utilizacion del CPU excede del 60% \n"
# * * * * * /path/to/executable param1 param2
# * * * * * ( sleep 30 ; /path/to/executable param1 param2 )
# echo var/spool/cron >> /opt/.filetool.lst
# echo /usr/sbin/crond >> /opt/bootlocal.sh
# rrdtool lastupdate ./rrd/monitoreo-localhost.rrd
# rrdtool fetch ./rrd/monitoreo-localhost.rrd AVERAGE --start N-90

words=$@
for i in $words; do
    echo $i
done
while true; do
    sleep 2
    ls -l
done

