#!/bin/sh
rrdtool create test2.rrd -b now-100d -s 86400 \
DS:msgs:GAUGE:86400:U:U \
RRA:AVERAGE:0.5:1:100 \
RRA:HWPREDICT:100:0.005:0.01:8:3 \
RRA:SEASONAL:8:0.05:2 \
RRA:DEVSEASONAL:1:0.001:2 \
RRA:DEVPREDICT:100:4 \
RRA:FAILURES:100:2:4:4

rrdtool tune test2.rrd --deltapos 8 --deltaneg 2

rrdtool fetch testf.rrd AVERAGE -s -100d | awk '/:/ {sub(",",".",$2);cmd="rrdtool update test2.rrd " $1 $2; print cmd; system(cmd);}'

rrdtool graph test2.png --start now-100d --end=now-5d \
DEF:var_test2=test2.rrd:msgs:AVERAGE \
DEF:pred=test2.rrd:msgs:HWPREDICT \
DEF:dev=test2.rrd:msgs:DEVPREDICT \
DEF:fail=test2.rrd:msgs:FAILURES \
TICK:fail#ffffa0:1.0:" Fallas" \
CDEF:inferior=pred,dev,2,*,- \
CDEF:superior=pred,dev,8,*,+ \
LINE2:var_test2#FF0000:"Datos" \
LINE2:superior#0000ff:"Limite superior" \
LINE2:inferior#0000ff:"Limite inferior"
