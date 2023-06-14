#!/bin/bash 

NODE="$1"
NODE_IP="$2"
CLUSTER="$3" 
DOMAIN="{{ site_name }}.{{ domain }}"
INSECURE_PASSOWRD="{{ insecure_admin_password }}"

if [ -z ${NODE} ] || [ -z ${NODE_IP} ] || [ -z ${CLUSTER } ] ; then
    echo "Please provide node, node IP and cluster name"
    echo "  ipa-add-host node01 10.100.1.101 mycluster1"
    exit 1
fi

echo "{{ secure_admin_password }}" | kinit admin

ipa host-add $NAME.$CLUSTER.$DOMAIN --password="$INSECURE_PASSWORD" --a-ip-address="$NODE_IP"
ipa hostgroup-add-member $CLUSTER --hosts=$NAME.$CLUSTER.$DOMAIN

echo
echo "==== TEST ACCESS ===="
echo "Initial testing of access to the cluster can be done with:"
echo "  ipa hbactest --user=${CLUSTER}-testuser --host=$NODE.$CLUSTER.$DOMAIN --service=sshd"
