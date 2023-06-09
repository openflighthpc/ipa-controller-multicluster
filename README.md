# Overview

Create a simple site & clusters setup on OpenStack consisting of:
- A site
    - Controller node (to be used as a centralised IPA server) 
        - `controller1.SITENAME.alces.network`
    - Network (all clusters launched within this)
- Multiple clusters
    - Login node
        - `login1.CLUSTERNAME.SITENAME.alces.network`
    - Multiple compute nodes

The site controller will have passwordless root SSH access to the login nodes of the clusters. 

# To Do 

- [ ] Add web interface
    - [ ] Embedded terminal for `useradmin` to add new users
    - [ ] Login API for regular cluster users which allows redirecting to cluster Web Suites
- [ ] Add Flight Solo integration for adding to domain

# Launching 

- Ensure config options in `settings.sh` look correct
- Create a site
    ```bash
    bash create-site.sh mysite
    ```
- Create a cluster (manually increment the `SUBNET_COUNT` in `sites/mysite.sh` for subsequent clusters) 
    ```bash
    bash create-cluster.sh mysite cluster1
    ```

# Configuring

## IPA Server

The script `setup_scripts/ipa_server.sh` will do all the server configuration, **edit the variables to match your configuration first**. 

After the server is setup, the script `setup_scripts/ipa_add_cluster.sh` can be used to add the basic cluster information and a test user to the IPA server, **edit the variables to match your configuration first**.

Once a cluster is added then the hosts can be added with `setup_scripts/ipa_add_host.sh`. **Edit the variables to match your configuration first**.

Setup Flight Directory for doing CLI user management with `setup_scripts/install_flight_directory.sh`. **Same warning you must have read 3 times already**.

## IPA Client

After doing the above, the script `setup_scripts/ipa_client.sh` will do all the client configuration. **Edit the variables to match your configuration first**.

# Notes

Based on the [Cluster Building Blocks](https://github.com/openflighthpc/cluster-building-blocks/) - see that repo for more info and requirements on OpenStack server
