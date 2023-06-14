#!/bin/bash 

NODE="$1"
NODE_IP="$2"
CLUSTER="$3" 
DOMAIN="{{ site_name }}.{{ domain }}"
INSECURE_PASSOWRD="{{ insecure_admin_password }}"

if [ -z ${NODE} ] || [ -z ${NODE_IP} ] || [ -z ${CLUSTER} ] ; then
    echo "Please provide node, node IP and cluster name"
    echo "  ipa-add-host node01 10.100.1.101 mycluster1"
    exit 1
fi

echo "{{ secure_admin_password }}" | kinit admin

ipa host-add $NODE.$CLUSTER.$DOMAIN --password="$INSECURE_PASSWORD" --ip-address="$NODE_IP"
ipa hostgroup-add-member $CLUSTER --hosts=$NODE.$CLUSTER.$DOMAIN

echo
echo "==== NEXT STEPS ===="
echo "The host will need to be connected to IPA with:"
echo "  ipa-client-install --no-ntp --mkhomedir --ssh-trust-dns --force-join --realm='{{ realm }}' --server='{{ controller_fqdn }}' -w '{{ insecure_admin_password }}' --domain='${CLUSTER}.$DOMAIN' --unattended --hostname='$NODE.$CLUSTER.$DOMAIN'"
echo "Initial testing of access to the cluster can be done with:"
echo "  ipa hbactest --user=${CLUSTER}-testuser --host=$NODE.$CLUSTER.$DOMAIN --service=sshd"
