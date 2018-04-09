#!/bin/sh
rrdtool create test.rrd -b now-100d -s 86400 \
DS:msgs:GAUGE:86400:U:U RRA:AVERAGE:0.5:1:100

#rrdtool create test.rrd -b now-10d -s 86400 \
#DS:msgs:GAUGE:86400:U:U RRA:AVERAGE:0.5:1:10
#en create -b se encuentra el inicio: hoy menos 10 dias -s 84600 es el paso que en este caso es el numero de segundos en un 
#dia.
#en la definicion del archivo se dice cuantos se promedian:1 y cuantos valores puede almacenar la base de datos: 10        
         
#rrdtool fetch test.rrd AVERAGE -s -10d | awk '/:/ {cmd="rrdtool update test.rrd " $1 "6"; print cmd; system(cmd);}'
#rrdtool fetch test.rrd AVERAGE -s -100d | awk '/:/ {cmd="rrdtool update test.rrd " $1 q; print cmd; s=.25*q;v=v+1; u=v/100; t=v%8; r=rand();q=500;if(v<75) {q=3+s+v+2*u+3*(t-4)*(t-4)+10*r}; system(cmd);}'
rrdtool fetch test.rrd AVERAGE -s -100d | awk '/:/ {cmd="rrdtool update test.rrd " $1 q; print cmd; s=.15*q;v=v+1; u=v/300; t=v%8; r=rand();q=500;if(v<75) {q=3+s+v+1.5*u+3*(t-4)*(t-4)+10*r}; system(cmd);}'
#rrdtool fetch test.rrd AVERAGE -s -100d 
rrdtool graph test.png --start now-100d --end=now DEF:test=test.rrd:msgs:AVERAGE LINE2:test#FF0000:test 
