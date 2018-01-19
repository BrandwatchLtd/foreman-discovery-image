#!/bin/bash
port=$( hpssacli ctrl slot=0 pd all show | grep physicaldrive | head -n1 | awk {'print $2'} | cut -d ':' -f1 )
hpssacli ctrl slot=0 create type=ld drives=${port}:1:6,${port}:1:7 raid=1
hpssacli ctrl slot=0 create type=ld drives=${port}:1:1,${port}:1:2 raid=1
hpssacli ctrl slot=0 create type=ld drives=${port}:1:3,${port}:1:4 raid=1
hpssacli ctrl slot=0 create type=ld drives=${port}:1:8,${port}:1:9 raid=1
hpssacli ctrl slot=0 create type=ld drives=${port}:1:10,${port}:1:11,${port}:1:12,${port}:1:13 raid=1+0 stripsize=16
