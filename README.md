# Overview

Create a simple site & clusters setup on OpenStack consisting of:
- A site
    - Controller node (to be used as a centralised IPA server) 
        - `controller1.SITENAME.alces.network`
    - Network (all clusters launched within this
- Multiple clusters
    - Login node
        - `login1.CLUSTERNAME.SITENAME.alces.network`
    - Multiple compute nodes

The site controller will have passwordless root SSH access to the login nodes of the clusters. 

# Launching 

- Ensure config options in `settings.sh` look correct
- Create a site
    ```bash
    bash create-site.sh mysite
    ```
- Create a cluster
    ```bash
    bash create-cluster.sh mysite cluster1
    ```

# Notes

Based on the [Cluster Building Blocks](https://github.com/openflighthpc/cluster-building-blocks/) - see that repo for more info and requirements on OpenStack server
