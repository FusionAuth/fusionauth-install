# Vagrant testing

This folder contains Vagrant files that allow the install scripts to be easily tested across operating systems. It uses Vagrant and UTM.

You'll need to follow these instructions to get everything installed and configured:

https://naveenrajm7.github.io/vagrant_utm/

## Configure FusionAuth

The simplest way to configure FusionAuth in these virtual machines is to point them at your laptop. UTM uses `10.0.2.2` to reference the host machine from the guest machine. Therefore, you can use `10.0.2.2` on port `5432` to access the host machine's PostgreSQL server.

## Using dev packages locally

There are a few directories that allow you to use locally built RPMs and DEBs. In order to make these tests work, you need to run the `copy-packages.sh` script in order to copy over the RPM/DEB bundles from the `fusionauth-app` and `fusionauth-search` projects locally.

Here's the sequence of things that need to be done:

1. Bundle both `fusionauth-app` and `fusionauth-search` by running the command `sb clean bundle` from the project directories. This requires that you install RPM locally as well and that can be done by running `brew install rpm`.
2. Run the `copy-packages.sh` script and specify the version of the local bundle you just created like this: `./copy-packages.sh 1.57.1`
3. Run Vagrant by running `vagrant up`

This should ensure that the latest local bundles are available to the Vagrant VM.