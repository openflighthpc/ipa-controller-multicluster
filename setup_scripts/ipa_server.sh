REALM="STU2.ALCES.NETWORK"
DOMAIN="stu2.alces.network"
SERVICES="ldap ldaps kerberos kpasswd"
CONTROLLER_HOSTNAME="controller1"
CONTROLLER_IP="10.100.0.100" # Replace with eth0 IP of instance
SUBNET_IP_REVERSE="100.10" # [100.10].0.100
CONTROLLER_IP_REVERSE="100.0" # 100.10.[0.100]
CLOUD_DNS="10.100.0.2"
PASSWORD="SECURE_PASSWORD"

hostnamectl set-hostname $CONTROLLER_HOSTNAME.$DOMAIN
echo "$CONTROLLER_IP    $CONTROLLER_HOSTNAME.$DOMAIN $CONTROLLER_HOSTNAME" >> /etc/hosts

dnf module reset -y idm
dnf module enable -y idm:DL1
dnf module install -y idm:DL1/dns

for service in $SERVICES ; do
    firewall-cmd --add-service $service --zone public --permanent
done

ipa-server-install -a $PASSWORD --hostname $CONTROLLER_HOSTNAME.$DOMAIN --ip-address="$CONTROLLER_IP" -r "$REALM" -p $PASSWORD -n "$DOMAIN" --no-ntp --setup-dns --forwarder="$CLOUD_DNS" --reverse-zone="$SUBNET_IP_REVERSE.in-addr.arpa" --ssh-trust-dns --unattended

firewall-cmd --add-port 53/udp --add-port 53/tcp --add-port 389/tcp --add-port 636/tcp --add-port 88/tcp --add-port 88/udp --add-port 464/tcp --add-port 464/udp --zone public --permanent
firewall-cmd --reload


kinit admin
ipa hbacrule-disable allow_all

