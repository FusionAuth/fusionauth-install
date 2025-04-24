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
Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/FusionAuth/fusionauth-install/main/install.ps1 | iex
```

Download and install FusionAuth with Elasticsearch

```powershell
Invoke-WebRequest -UseBasicParsing -Uri https://raw.githubusercontent.com/FusionAuth/fusionauth-install/main/install.ps1 -OutFile install.ps1
.\install.ps1 -IncludeSearch 1
```

After you have downloaded and install FusionAuth using the commands above, you can start it like this:

```powershell
cd fusionauth\bin
.\startup.ps1
```

Or you can install the Windows Service like this:

```powershell
cd fusionauth\fusionauth-app\bin
FusionAuthApp.exe /install
```

### Other options

We have a bunch of other ways to download and install FusionAuth. Those options are located here:

https://fusionauth.io/download

### Documentation

https://fusionauth.io/docs

## Development

The install scripts must be compatible with CentOS, Ubuntu, Windows and macOS.

Ubuntu, Centos, and Windows testing have been automated via vagrant, go to the respective directory and run `vagrant up`. Once the VM has started you should be able to reach FusionAuth to perform any required testing. If you want to use a host machine database, the hosts IP address is `10.0.2.2` inside of the guest.

To test a system go to the related directory and run `vagrant up`. You can then visit http://localhost:9011 in your browser and see if FusionAuth started up properly.

macOS could potentially be tested the same way, but the vagrant boxes aren't legally allowed to be distributed this way, so you would have to make your own. 
