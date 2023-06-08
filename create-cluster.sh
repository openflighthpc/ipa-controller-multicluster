#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Source general variables
source $DIR/settings.sh

# Checks
if [ -z "${OS_AUTH_URL}" ] ; then
    echo "No OpenStack auth identified, ensure that you've sourced your openstack rc file to setup the environment"
    exit 1
fi

SITENAME="$1"
CLUSTERNAME="$2"

if [ -z ${SITENAME} ] || [ -z ${CLUSTERNAME} ] ; then
    echo "Please provide site and clustername"
    echo "  bash create-cluster.sh mysite mycluster1"
    exit 1
fi

SITECONF="$DIR/sites/$SITENAME.sh"
if [ ! -f "$SITECONF" ] ; then
    echo "Site config does not exist, ensure that site has been created with the create-site.sh script before launching a cluster"
    exit 1
fi
source $SITECONF

DOMAIN="$CLUSTERNAME.$SITEDOMAIN"

# Identify resource IDs
core_resources="$(openstack stack resource list "$SITENAME-controller-and-network" -f yaml)"
network_id="$(echo "$core_resources" |grep 'site-network$' -B 1 |head -1 |sed 's/.*: //g')"
network_pri_id="$(echo "$core_resources" |grep 'site-network-pri$' -B 1 |head -1 |sed 's/.*: //g')"
sg_id="$(echo "$core_resources" |grep 'site-sg$' -B 1 |head -1 |sed 's/.*: //g')"

SERVER_LOGIN_IP="$SERVER_LOGIN_PRE.$CLUSTER_SUBNET_COUNT.101"

openstack stack create -t $DIR/cluster-login.yaml \
    --parameter clustername="$CLUSTERNAME" \
    --parameter sitename="$SITENAME" \
    --parameter site-network="$network_id" \
    --parameter site-network-pri="$network_pri_id" \
    --parameter site-sg="$sg_id" \
    --parameter ssh-key="$SSH_KEY" \
    --parameter solo-image="$SOLO_IMAGE" \
    --parameter controller-pri-ip="$SERVER_CONTROLLER_IP" \
    --parameter login-pri-ip="$SERVER_LOGIN_IP" \
    --parameter login-flavour="$SERVER_LOGIN_FLAVOUR" \
    --parameter external-network="$EXTERNAL_NETWORK" \
    "$SITENAME-$CLUSTERNAME-login" --wait

LOGIN_IP=$(openstack stack show "$SITENAME-$CLUSTERNAME-login" -f yaml |grep login_ext_ip -A 1 |tail -1 |sed 's/.*: //g')


count=1
countmax=30
echo "$count/$countmax: Waiting for login1 to be accessible..."
count=$((count + 1))
until ssh -q -o StrictHostKeyChecking=no -o PasswordAuthentication=no flight@$LOGIN_IP exit </dev/null 2>/dev/null ; do
    echo "$count/$countmax: Waiting for login1 to be accessible..."
    sleep 5
    count=$((count + 1))
    if [[ $count == $countmax ]] ; then
        echo "ERROR: Failed to access login1 at '$LOGIN_IP'!"
        echo "Exiting..."
        exit 1
    fi
done

openstack stack create -t $DIR/cluster-nodes.yaml \
    --parameter clustername="$CLUSTERNAME" \
    --parameter sitename="$SITENAME" \
    --parameter site-network="$network_id" \
    --parameter site-network-pri="$network_pri_id" \
    --parameter site-sg="$sg_id" \
    --parameter count="$NODE_COUNT" \
    --parameter solo-image="$SOLO_IMAGE" \
    --parameter node-flavour="$SERVER_COMPUTE_FLAVOUR" \
    --parameter login-pri-ip="$SERVER_LOGIN_IP" \
    --parameter ssh-key="$SSH_KEY" \
    --parameter subnet-count="$CLUSTER_SUBNET_COUNT" \
    "$SITENAME-$CLUSTERNAME-compute-nodes" --wait

# Update subnet count for subsequent clusters

