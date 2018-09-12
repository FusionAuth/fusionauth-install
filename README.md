# FusionAuth Install

Software should be easy to install, so we've provided you with some shortcuts to getting up and running. 

### Package Installs

#### macOS
Download and install using ZIP packages
```bash
sh -c "curl -fsSL https://raw.githubusercontent.com/FusionAuth/fusionauth-install/master/install.sh | sh"
```

#### Linux
Download and install RPM or DEB packages, optionally ZIP packages
```bash
sh -c "curl -fsSL https://raw.githubusercontent.com/FusionAuth/fusionauth-install/master/install.sh | sh"
```

#### Windows
Download and install using ZIP packages

```powershell
iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/FusionAuth/fusionauth-install/master/install.ps1')
```

If you run into an error, you may need to change your execution policy. `Set-ExecutionPolicy Bypass -scope CurrentUser`

### Docker
https://hub.docker.com/u/fusionauth/

https://github.com/FusionAuth/fusionauth-containers

FusionAuth App Only
```
docker pull fusionauth/fusionauth-app
```

FusionAuth Search Only
```
docker pull fusionauth/fusionauth-search
```

FusionAuth App and Search in one container
```
docker pull fusionauth/fusionauth
```

FusionAuth App, Search and MySQL in one container
```
docker pull fusionauth/fusionauth-mysql
```

### Documentation
https://fusionauth.io/docs


