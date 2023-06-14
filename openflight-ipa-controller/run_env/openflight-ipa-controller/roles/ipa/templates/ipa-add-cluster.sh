#!/bin/bash

CLUSTER="$1"

if [ -z ${CLUSTER} ] ; then
    echo "Please provide cluster"
    echo "  ipa-add-cluster mycluster1"
    exit 1
fi

DOMAIN="{{ site_name }}.{{ domain }}"
SSH_KEY="{{ cluster_test_user_pub_key }}" # SSH Key for the cluster test user

# Auth
echo "{{ secure_admin_password }}" |kinit admin

# Host and user group for cluster
ipa hostgroup-add $CLUSTER --desc="Nodes in $CLUSTER"
ipa group-add ${CLUSTER}-users --desc="Generic $CLUSTER users"
ipa dnszone-add $CLUSTER.$DOMAIN

# Access rules for cluster
ipa hbacrule-add ${CLUSTER}-access --desc "Allow user access to $CLUSTER hosts"
ipa hbacrule-add-service ${CLUSTER}-access --hbacsvcs sshd
ipa hbacrule-add-user ${CLUSTER}-access --groups ${CLUSTER}-users
ipa hbacrule-add-host ${CLUSTER}-access --hostgroups $CLUSTER

# Test user for cluster access
ipa user-add ${CLUSTER}-testuser --first $CLUSTER --last TestUser --random
ipa user-mod ${CLUSTER}-testuser --sshpubkey="$SSH_KEY"
ipa group-add-member ${CLUSTER}-users --users ${CLUSTER}-testuser

# Last steps
echo
echo "==== NEXT STEPS ===="
echo "You will need to add the cluster hosts to the hostgroup:"
echo "  ipa_add_host newhost.$CLUSTER.$DOMAIN"
