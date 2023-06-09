CLUSTER="cluster1"
SSH_KEY="" # SSH Key for the cluster test user

# Auth
kinit admin

# Host and user group for cluster
ipa hostgroup-add $CLUSTER --desc="Nodes in $CLUSTER" 
ipa group-add ${CLUSTER}-users --desc="Generic $CLUSTER users" 

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
echo "  ipa host-add NODE_FQDN --password='INSECURE_PASSWORD' --ip-address=NODE_IP"
echo "  ipa hostgroup-add-member ${CLUSTER} --hosts=NODE_FQDN"
echo
echo "Initial testing of access to the cluster can be done with:"
echo "  ipa hbactest --user=${CLUSTER}-testuser --host=NODE_FQDN --service=sshd"
