# FusionAuth Install

Software should be easy to install, so we've provided you with some shortcuts to getting up and running. 

### Package Installs

#### macOS / 'nix

Note: Search is no longer installed by default anymore, if you would like search then supply `-s` to the installer script.

Options:

* `s` - Include the search engine. (Without it, we will fallback to database searches)
* `z` - Use the zip install
* `h` - Show the help text

Environment variables:

* `TARGET_DIR` - The location to install the zip (Defaults to `$PWD/fusionauth`)
* `VERSION` - The version to install (Defaults to latest stable version)

##### Examples

Download and install (Automatic method will choose RPM, DEB, or ZIP depending on the available package manager)
```bash
sh -c "curl -fsSL https://raw.githubusercontent.com/FusionAuth/fusionauth-install/master/install.sh | sh"
```

Download and install with search
```bash
sh -c "curl -fsSL https://raw.githubusercontent.com/FusionAuth/fusionauth-install/master/install.sh | sh -s - -s"
```

Download and install ZIP packages to current directory
```bash
sh -c "curl -fsSL https://raw.githubusercontent.com/FusionAuth/fusionauth-install/master/install.sh | sh -s - -z"
```

Download and install ZIP packages (with search) to current directory
```bash
sh -c "curl -fsSL https://raw.githubusercontent.com/FusionAuth/fusionauth-install/master/install.sh | sh -s - -zs"
```

#### Windows

Download and install using ZIP packages
```powershell
. { iwr -useb https://raw.githubusercontent.com/FusionAuth/fusionauth-install/master/install.ps1 } | iex; install
```

Install with search
```powershell
. { iwr -useb https://raw.githubusercontent.com/FusionAuth/fusionauth-install/master/install.ps1 } | iex; install -includeSearch 1
```

If you run into an error, you may need to change your execution policy. `Set-ExecutionPolicy Bypass -scope CurrentUser`

### Docker
https://hub.docker.com/u/fusionauth/

https://github.com/FusionAuth/fusionauth-containers

#### Docker Compose
```bash
curl -o docker-compose.yml https://raw.githubusercontent.com/FusionAuth/fusionauth-containers/master/docker/fusionauth/docker-compose.yml && docker-compose up
```

#### Docker Images

FusionAuth App ([On Docker Hub](https://hub.docker.com/r/fusionauth/fusionauth-app/))

```
docker pull fusionauth/fusionauth-app
```

FusionAuth Search ([On Docker Hub](https://hub.docker.com/r/fusionauth/fusionauth-search/))


```
docker pull fusionauth/fusionauth-search
```
You may also use Elasticsearch directly, see docker-compose.yml for example. 

### Documentation
https://fusionauth.io/docs

## Development

If you are interested in tweaking this file, your changes must work in both linux and windows (or more specifically centos, ubuntu, windows, and macos (whatever the lastest is)).

Ubuntu, Centos, and Windows testing have been automated via vagrant, go to the respective directory and run `vagrant up`. You should be able to reach fusionauth and test it. If you want to use a host machine database, the hosts ip is `10.0.2.2` inside of the guest.

To test a system go to the related directory and run `vagrant up`. You can then visit http://localhost:9011 in your systems browser (on the host) and see if fusionauth started up properly.

Macos could potentially be tested the same way, but the vagrant boxes aren't legally allowed to be distributed this way, so you would have to make your own. 
