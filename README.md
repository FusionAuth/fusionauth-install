# FusionAuth FastPath(tm) Install

Software should be easy to install, so we've provided you with some shortcuts to getting up and running. 

### Package Installs

#### macOS and Linux

Note: Elasticsearch is not installed by default. To install Elasticsearch supply `-s` to the installer script.

Options:

* `s` - Install Elasticsearch. Elasticsearch provides enhanced search capability in FusionAuth.
* `h` - Show the help text.

Environment variables:

* `TARGET_DIR` - The location to install the zip. Defaults value is `$PWD/fusionauth`. This value is ignored when installing Debian or RPM packages.
* `VERSION` - The version to install. Defaults to the latest stable version.

##### Examples

Download and install FusionAuth without Elasticsearch
```bash
sh -c "curl -fsSL https://raw.githubusercontent.com/FusionAuth/fusionauth-install/master/install.sh | sh"
```

Download and install with Elasticsearch
```bash
sh -c "curl -fsSL https://raw.githubusercontent.com/FusionAuth/fusionauth-install/master/install.sh | sh -s - -s"
```

#### Windows

Download and install FusionAuth without Elasticsearch
```powershell
. { iwr -useb https://raw.githubusercontent.com/FusionAuth/fusionauth-install/master/install.ps1 } | iex; install
REM Optionally register the service with the following commands
cd fusionauth\fusionauth-app\bin
FusionAuthApp.exe /install
```

Download and install FusionAuth with Elasticsearch
```powershell
. { iwr -useb https://raw.githubusercontent.com/FusionAuth/fusionauth-install/master/install.ps1 } | iex; install -includeSearch 1
REM Optionally register the service with the following commands
cd fusionauth\fusionauth-app\bin
FusionAuthApp.exe /install
```

If you run into an error, you may need to change your execution policy. `Set-ExecutionPolicy Bypass -scope CurrentUser`

### Docker

https://hub.docker.com/u/fusionauth/

https://github.com/FusionAuth/fusionauth-containers

#### Docker Compose
The reference [docker-compose.yml](https://raw.githubusercontent.com/FusionAuth/fusionauth-containers/master/docker/fusionauth/docker-compose.yml) defaults to use the database as the User search engine.

In order to install with Elasticsearch as the User search engine, include the reference  [docker-compose.override.yml](https://raw.githubusercontent.com/FusionAuth/fusionauth-containers/master/docker/fusionauth/docker-compose.override.yml).

Review our [Docker Install Guide](https://fusionauth.io/docs/v1/tech/installation-guide/docker) for additional assistance.

```bash
curl -o docker-compose.yml https://raw.githubusercontent.com/FusionAuth/fusionauth-containers/master/docker/fusionauth/docker-compose.yml
# Uncomment the following line to install and configure Elasticsearch as the User search engine
# curl -o docker-compose.override.yml https://raw.githubusercontent.com/FusionAuth/fusionauth-containers/master/docker/fusionauth/docker-compose.override.yml
curl -o .env https://raw.githubusercontent.com/FusionAuth/fusionauth-containers/master/docker/fusionauth/.env
docker-compose up
```

#### Docker Images

FusionAuth App ([On Docker Hub](https://hub.docker.com/r/fusionauth/fusionauth-app/))

```
docker pull fusionauth/fusionauth-app
```

When running FusionAuth in Docker with Elasticsearch as the User search engine, it is recommended to either connect to an external Elasticsearch service, or use the Docker images provided by Elasticsearch. See the reference `docker-compose.yml` and `docker-compose.override.yml` in the [fusionauth-containers repository](https://github.com/FusionAuth/fusionauth-containers/tree/master/docker/fusionauth) for an example in configuring Elasticsearch with FusionAuth. 

### Documentation

https://fusionauth.io/docs

## Development

The install scripts must be compatible with CentOS, Ubuntu, Windows and macOS.

Ubuntu, Centos, and Windows testing have been automated via vagrant, go to the respective directory and run `vagrant up`. Once the VM has started you should be able to reach FusionAuth to perform any required testing. If you want to use a host machine database, the hosts IP address is `10.0.2.2` inside of the guest.

To test a system go to the related directory and run `vagrant up`. You can then visit http://localhost:9011 in your browser and see if FusionAuth started up properly.

macOS could potentially be tested the same way, but the vagrant boxes aren't legally allowed to be distributed this way, so you would have to make your own. 
