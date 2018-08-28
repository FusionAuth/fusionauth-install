# FusionAuth-Install

Linux/Mac install:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/FusionAuth/install/master/install.sh)"
```

Windows install:
```powershell
iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/FusionAuth/install/master/install.ps1')
```

If you run into an error, you may need to change your execution policy. `Set-ExecutionPolicy RemoteSigned -scope CurrentUser`
