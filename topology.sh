#!/bin/bash

#
# Copyright (c) 2017 Stanislav Galfy
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# - Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# - Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
# - The name of the author may not be used to endorse or promote products
#   derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#


killall vde_switch

vde_switch -s /tmp/switch-A-A1 -d
vde_switch -s /tmp/switch-A-A2 -d
vde_switch -s /tmp/switch-A1-A2 -d
vde_switch -s /tmp/switch-A1 -d
vde_switch -s /tmp/switch-A2 -d

vde_switch -s /tmp/switch-B-B1 -d
vde_switch -s /tmp/switch-B-B2 -d
vde_switch -s /tmp/switch-B1-B2 -d
vde_switch -s /tmp/switch-B1 -d
vde_switch -s /tmp/switch-B2 -d

vde_switch -s /tmp/switch-C-C1 -d
vde_switch -s /tmp/switch-C-C2 -d
vde_switch -s /tmp/switch-C1-C2 -d
vde_switch -s /tmp/switch-C1 -d
vde_switch -s /tmp/switch-C2 -d

vde_switch -s /tmp/switch-A-B -d
vde_switch -s /tmp/switch-A-C -d
vde_switch -s /tmp/switch-B-C -d

##################################################################

qemu-system-i386 -cdrom ../mainline/image.iso \
	-net nic,vlan=11,macaddr=ca:fe:ba:be:01:01,model=rtl8139 \
	-net vde,vlan=11,sock=/tmp/switch-A-B \
	-net nic,vlan=12,macaddr=ca:fe:ba:be:01:02,model=rtl8139 \
	-net vde,vlan=12,sock=/tmp/switch-A-C \
	-net nic,vlan=13,macaddr=ca:fe:ba:be:01:03,model=rtl8139 \
	-net vde,vlan=13,sock=/tmp/switch-A-A1 \
	-net nic,vlan=14,macaddr=ca:fe:ba:be:01:04,model=rtl8139 \
	-net vde,vlan=14,sock=/tmp/switch-A-A2 \
	-machine type=pc,accel=kvm -m 512M \
	-monitor unix:/tmp/monitor-helenosA,server,nowait \
	-name HelenOS_A &

if [ 1 -eq 0 ]; then

qemu-system-i386 -cdrom ../mainline/image.iso \
	-net nic,vlan=21,macaddr=ca:fe:ba:be:02:01,model=rtl8139 \
	-net vde,vlan=21,sock=/tmp/switch-A-A1 \
	-net nic,vlan=22,macaddr=ca:fe:ba:be:02:02,model=rtl8139 \
	-net vde,vlan=22,sock=/tmp/switch-A1-A2 \
	-net nic,vlan=23,macaddr=ca:fe:ba:be:02:03,model=rtl8139 \
	-net vde,vlan=23,sock=/tmp/switch-A1 \
	-machine type=pc,accel=kvm -m 512M \
	-monitor unix:/tmp/monitor-helenosA1,server,nowait \
	-name HelenOS_A1 &

qemu-system-i386 -cdrom ../mainline/image.iso \
	-net nic,vlan=31,macaddr=ca:fe:ba:be:03:01,model=rtl8139 \
	-net vde,vlan=31,sock=/tmp/switch-A-A2 \
	-net nic,vlan=32,macaddr=ca:fe:ba:be:03:02,model=rtl8139 \
	-net vde,vlan=32,sock=/tmp/switch-A1-A2 \
	-net nic,vlan=33,macaddr=ca:fe:ba:be:03:03,model=rtl8139 \
	-net vde,vlan=33,sock=/tmp/switch-A2 \
	-machine type=pc,accel=kvm -m 512M \
	-monitor unix:/tmp/monitor-helenosA2,server,nowait \
	-name HelenOS_A2 &

fi

##################################################################



qemu-system-i386 coreB.img \
	-net nic,vlan=41,macaddr=ca:fe:ba:be:04:01,model=rtl8139 \
	-net vde,vlan=41,sock=/tmp/switch-A-B \
	-net nic,vlan=42,macaddr=ca:fe:ba:be:04:02,model=rtl8139 \
	-net vde,vlan=42,sock=/tmp/switch-B-C \
	-net nic,vlan=43,macaddr=ca:fe:ba:be:04:03,model=rtl8139 \
	-net vde,vlan=43,sock=/tmp/switch-B-B1 \
	-net nic,vlan=44,macaddr=ca:fe:ba:be:04:04,model=rtl8139 \
	-net vde,vlan=44,sock=/tmp/switch-B-B2 \
	-machine type=pc,accel=kvm -m 512M \
	-monitor unix:/tmp/monitor-coreB,server,nowait \
	-name Core_B &

if [ 1 -eq 0 ]; then

qemu-system-i386 -cdrom ../mainline/image.iso \
	-net nic,vlan=51,macaddr=ca:fe:ba:be:05:01,model=rtl8139 \
	-net vde,vlan=51,sock=/tmp/switch-B-B1 \
	-net nic,vlan=52,macaddr=ca:fe:ba:be:05:02,model=rtl8139 \
	-net vde,vlan=52,sock=/tmp/switch-B1-B2 \
	-net nic,vlan=53,macaddr=ca:fe:ba:be:05:03,model=rtl8139 \
	-net vde,vlan=53,sock=/tmp/switch-B1 \
	-machine type=pc,accel=kvm -m 512M \
	-monitor unix:/tmp/monitor-helenosB1,server,nowait \
	-name HelenOS_B1 &

fi

qemu-system-i386 coreB2.img \
	-net nic,vlan=61,macaddr=ca:fe:ba:be:06:01,model=rtl8139 \
	-net vde,vlan=61,sock=/tmp/switch-B-B2 \
	-net nic,vlan=62,macaddr=ca:fe:ba:be:06:02,model=rtl8139 \
	-net vde,vlan=62,sock=/tmp/switch-B1-B2 \
	-net nic,vlan=63,macaddr=ca:fe:ba:be:06:03,model=rtl8139 \
	-net vde,vlan=63,sock=/tmp/switch-B2 \
	-machine type=pc,accel=kvm -m 512M \
	-monitor unix:/tmp/monitor-coreB2,server,nowait \
	-name Core_B2 &

##################################################################



qemu-system-i386 -cdrom ../mainline/image.iso \
	-net nic,vlan=71,macaddr=ca:fe:ba:be:07:01,model=rtl8139 \
	-net vde,vlan=71,sock=/tmp/switch-A-C \
	-net nic,vlan=72,macaddr=ca:fe:ba:be:07:02,model=rtl8139 \
	-net vde,vlan=72,sock=/tmp/switch-B-C \
	-net nic,vlan=73,macaddr=ca:fe:ba:be:07:03,model=rtl8139 \
	-net vde,vlan=73,sock=/tmp/switch-C-C1 \
	-net nic,vlan=74,macaddr=ca:fe:ba:be:07:04,model=rtl8139 \
	-net vde,vlan=74,sock=/tmp/switch-C-C2 \
	-machine type=pc,accel=kvm -m 512M \
	-monitor unix:/tmp/monitor-helenosC,server,nowait \
	-name HelenOS_C &

if [ 1 -eq 0 ]; then

qemu-system-i386 -cdrom ../mainline/image.iso \
	-net nic,vlan=81,macaddr=ca:fe:ba:be:08:01,model=rtl8139 \
	-net vde,vlan=81,sock=/tmp/switch-C-C1 \
	-net nic,vlan=82,macaddr=ca:fe:ba:be:08:02,model=rtl8139 \
	-net vde,vlan=82,sock=/tmp/switch-C1-C2 \
	-net nic,vlan=83,macaddr=ca:fe:ba:be:08:03,model=rtl8139 \
	-net vde,vlan=83,sock=/tmp/switch-C1 \
	-machine type=pc,accel=kvm -m 512M \
	-monitor unix:/tmp/monitor-helenosC1,server,nowait \
	-name HelenOS_C1 &

fi

qemu-system-i386 coreC2.img \
	-net nic,vlan=91,macaddr=ca:fe:ba:be:09:01 \
	-net vde,vlan=91,sock=/tmp/switch-C-C2 \
	-net nic,vlan=92,macaddr=ca:fe:ba:be:09:02 \
	-net vde,vlan=92,sock=/tmp/switch-C1-C2 \
	-net nic,vlan=93,macaddr=ca:fe:ba:be:09:03 \
	-net vde,vlan=93,sock=/tmp/switch-C2 \
	-machine type=pc,accel=kvm -m 512M \
	-monitor unix:/tmp/monitor-coreC2,server,nowait \
	-name Core_C2

while true
do
sleep 1
done
