CLUSTER="cluster1"
DOMAIN="stu2.alces.network"
SSH_KEY="" # SSH Key for the cluster test user

# Auth
kinit admin

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
echo "  ipa_add_host.sh # UPDATE VARIABLES BEFORE RUNNING"
