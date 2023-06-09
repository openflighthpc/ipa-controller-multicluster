REALM="STU2.ALCES.NETWORK"
DOMAIN="stu2.alces.network"
SERVICES="ldap ldaps kerberos kpasswd"
CONTROLLER_HOSTNAME="controller1"
CONTROLLER_IP="10.100.0.100" # Replace with eth0 IP of instance
SUBNET_IP_REVERSE="100.10" # [100.10].0.100
CONTROLLER_IP_REVERSE="100.0" # 100.10.[0.100]
CLOUD_DNS="10.100.0.2"
PASSWORD="SECURE_PASSWORD"

dnf install -y https://repo.openflighthpc.org/openflight-dev/centos/8/x86_64/flight-directory-1.1.3-2.el8.x86_64.rpm

sed -i "s/IPAPASSWORD=.*/IPAPASSWORD='$PASSWORD'/g" /opt/flight/etc/directory/base.conf
chmod 0600 /opt/flight/etc/directory/base.conf

echo "cw_ACCESS_fqdn=$CONTROLLER_HOSTNAME.$DOMAIN" > /opt/flight/etc/access.rc

cd /opt/flight/bin
curl https://s3-eu-west-1.amazonaws.com/flightconnector/directory/resources/banner > banner
chmod 755 banner
cd /opt/flight/opt/directory/bin
curl https://s3-eu-west-1.amazonaws.com/flightconnector/directory/resources/sandbox-starter-2023.1 > sandbox-starter
chmod 755 sandbox-starter

# Create useradmin for managing cluster access
useradd useradmin
passwd -l useradmin

echo 'useradmin ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/userware

echo
echo "==== NEXT STEPS ===="
echo "- Add SSH keys for useradmin access to ~useradmin/.ssh/authorized_keys:"
echo "  command='/opt/flight/opt/directory/bin/sandbox-starter',no-port-forwarding,no-x11-forwarding,no-agent-forwarding ssh-rsa <ADMIN KEY>"

