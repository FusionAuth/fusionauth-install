# FusionAuth Install

Software should be easy to install, so we've provided you with some shortcuts to getting up and running. 

### Linux or macOS
```bash
sh -c "curl -fsSL https://raw.githubusercontent.com/FusionAuth/fusionauth-install/master/install.sh | sh"
```


### Windows
```powershell
iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/FusionAuth/fusionauth-install/master/install.ps1')
```

If you run into an error, you may need to change your execution policy. `Set-ExecutionPolicy Bypass -scope CurrentUser`

### Documentation
https://fusionauth.io/docs