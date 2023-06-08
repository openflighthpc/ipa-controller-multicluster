#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Source general variables
source $DIR/settings.sh

# Source site variables
SITECONF="sites/$SITENAME.sh"
if [ -f "$SITECONF" ] ; then
    source $DIR/$SITECONF
fi

# Checks
if [ -z "${OS_AUTH_URL}" ] ; then
    echo "No OpenStack auth identified, ensure that you've sourced your openstack rc file to setup the environment"
    exit 1
fi

SITENAME="$1"

if [ -z ${SITENAME} ] ; then
    echo "Please provide site"
    echo "  bash create-site.sh mysite"
    exit 1
fi

# Source site variables
SITECONF="$DIR/sites/$SITENAME.sh"
if [ ! -f "$SITECONF" ] ; then
    echo "SITEDOMAIN='$SITENAME.alces.network'" > $SITECONF
    echo "CLUSTER_SUBNET_COUNT=1" >> $SITECONF
fi
source $SITECONF

openstack stack create -t $DIR/site.yaml \
    --parameter sitename="$SITENAME" \
    --parameter external-network="$EXTERNAL_NETWORK" \
    --parameter ssh-key="$SSH_KEY" \
    --parameter solo-image="$SOLO_IMAGE" \
    --parameter network-cidr-pri="$SITE_NETWORK" \
    --parameter controller-pri-ip="$SERVER_CONTROLLER_IP" \
    --parameter controller-flavour="$SERVER_CONTROLLER_FLAVOUR" \
    "$SITENAME-controller-and-network" --wait

CONTROLLER_IP=$(openstack stack show "$SITENAME-controller-and-network" -f yaml |grep controller_ext_ip -A 1 |tail -1 |sed 's/.*: //g')

echo "Controller for $SITENAME: $CONTROLLER_IP"

