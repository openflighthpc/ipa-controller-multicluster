#!/bin/bash

if ! command -v ansible &> /dev/null
then
  dnf install -y ansible
fi

dnf module reset -y idm
dnf module enable -y idm:DL1
dnf module install -y idm:DL1/dns

# If I end up using the freeipa integration stuff
# ansible-galaxy collection install freeipa.ansible_freeipa
