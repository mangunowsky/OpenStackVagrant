#!/bin/bash

DEVSTACK_IP=$(ip -4 addr show $1 | grep -P inet | awk '{print substr($2, 1, length($2)-3)}')

DEVSTACK_IP=$(echo $DEVSTACK_IP | xargs)

echo $DEVSTACK_IP

cp /opt/stack/devstack/stackrc /opt/stack/devstack/stackrc.bak

sed -i "s/HOST_IP=\${HOST_IP:-}/HOST_IP=\${HOST_IP:-$DEVSTACK_IP}/g" /opt/stack/devstack/stackrc
