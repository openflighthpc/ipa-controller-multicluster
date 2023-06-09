NODE="login1"
CLUSTER="cluster1"
DOMAIN="stu2.alces.network"
NODE_IP="IP_ADDRESS"
INSECURE_PASSWORD="INSECURE_PASSWORD"

ipa host-add $NAME.$CLUSTER.$DOMAIN --password="$INSECURE_PASSWORD" --a-ip-address="$NODE_IP"
ipa hostgroup-add-member $CLUSTER --hosts=$NAME.$CLUSTER.$DOMAIN

echo 
echo "==== TEST ACCESS ===="
echo "Initial testing of access to the cluster can be done with:"
echo "  ipa hbactest --user=${CLUSTER}-testuser --host=$NODE.$CLUSTER.$DOMAIN --service=sshd"
