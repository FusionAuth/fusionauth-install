# FusionAuth Install

Software should be easy to install, so we've provided you with some shortcuts to getting up and running. 

### Package Installs

#### macOS
Download and install using ZIP packages
```bash
sh -c "curl -fsSL https://raw.githubusercontent.com/FusionAuth/fusionauth-install/master/install.sh | sh"
```

#### Linux
Download and install RPM or DEB packages
```bash
sh -c "curl -fsSL https://raw.githubusercontent.com/FusionAuth/fusionauth-install/master/install.sh | sh"
```

Download and install ZIP packages to current directory
```bash
sh -c "curl -fsSL https://raw.githubusercontent.com/FusionAuth/fusionauth-install/master/install.sh | sh -s - -z"
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

#### Docker Compose
```bash
curl -o docker-compose.yml https://raw.githubusercontent.com/FusionAuth/fusionauth-containers/master/docker/fusionauth/docker-compose.yml && docker-compose up
```

#### Docker Images

FusionAuth App Only
```
docker pull fusionauth/fusionauth-app
```

FusionAuth Search Only
```
docker pull fusionauth/fusionauth-search
```

### Documentation
https://fusionauth.io/docs


