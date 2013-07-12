#!/bin/bash

modprobe dummy
ip link set dummy0 down
ip l set dev dummy0 name eth0
ip link set dev eth0 address 00:22:68:0c:2a:cd
