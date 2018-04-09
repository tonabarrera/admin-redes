#!/bin/sh

rrdtool graph test.png \
--start now-100d --end=now+40d \
DEF:datos=test.rrd:msgs:AVERAGE \
LINE2:datos#FF0000:"Mis datos" \
VDEF:var_m=datos,LSLSLOPE \
VDEF:var_b=datos,LSLINT \
CDEF:ls=datos,COUNT,EXC,POP,var_m,*,var_b,+ \
LINE1:ls#333333:"Linea base" \
CDEF:var_y=datos,COUNT,EXC,POP,var_m,*,var_b,+,150,LT,TIME,0,IF \
VDEF:max_y=var_y,MAXIMUM \
GPRINT:"max_y: Alcanza 150 en\: %c :strftime" 
