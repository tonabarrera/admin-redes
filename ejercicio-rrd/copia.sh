#!/bin/sh
rrdtool create test2.rrd -b now-100d -s 86400 \
DS:msgs:GAUGE:86400:U:U \
RRA:AVERAGE:0.5:1:100 \
RRA:HWPREDICT:80:0.25:0.0005:10

rrdtool tune test2.rrd \
	--window-length 1 \
	--failure-threshold 1

rrdtool fetch testf.rrd AVERAGE -s -100d | awk '/:/ {sub(",",".",$2);cmd="rrdtool update test2.rrd " $1 $2; print cmd; system(cmd);}'

rrdtool graph test2.png --start now-100d --end=now \
DEF:var_test2=test2.rrd:msgs:AVERAGE \
LINE2:var_test2#FF0000:test2 \
DEF:pred=test2.rrd:msgs:HWPREDICT \
DEF:dev=test2.rrd:msgs:DEVPREDICT \
DEF:fail=test2.rrd:msgs:FAILURES \
TICK:fail#ffffa0:1.0:"fallas" \
CDEF:down=pred,dev,2,*,- \
LINE2:down#0000ff:"Down"
