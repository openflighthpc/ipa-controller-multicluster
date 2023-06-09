NODENAME="login1"
CLUSTER="cluster1"
REALM="STU2.ALCES.NETWORK"
DOMAIN="stu2.alces.network"
SERVICES="ldap ldaps kerberos kpasswd"
CONTROLLER_HOSTNAME="controller1"
CONTROLLER_IP="10.100.0.100" # Replace with eth0 IP of instance
SUBNET_IP_REVERSE="100.10" # [100.10].0.100
CONTROLLER_IP_REVERSE="100.0" # 100.10.[0.100]
CLOUD_DNS="10.100.0.2"
INSECURE_PASSWORD="INSECURE_PASSSWORD"

dnf -y install ipa-client ipa-admintools

echo "$CONTROLLER_IP    $CONTROLLER_HOSTNAME.$DOMAIN $CONTROLLER_HOSTNAME" >> /etc/hosts

cat << EOF > /etc/resolv.conf
search $DOMAIN $CLUSTER.$DOMAIN
nameserver $CONTROLLER_IP
EOF

ipa-client-install --no-ntp --mkhomedir --ssh-trust-dns --force-join --realm="$REALM" --server="$CONTROLLER_HOSTNAME.$DOMAIN" -w "$INSECURE_PASSWORD" --domain="$CLUSTER.$DOMAIN" --unattended --hostname="$NODENAME.$CLUSTER.$DOMAIN"
