# Web Servers — Install IIS on Windows Server (PowerShell)

Commands to install and manage Internet Information Services (IIS) on a Windows
Server VM using PowerShell. Run these from a PowerShell session on the target
server (locally, via RDP, or via `Invoke-Command`/`Enter-PSSession` for remote
management).

## Install IIS (Web-Server role)

```powershell
Install-WindowsFeature -Name Web-Server -IncludeManagementTools
```

- `Web-Server` — installs the core IIS role.
- `-IncludeManagementTools` — also installs the IIS Management Console and
  PowerShell management cmdlets.

## Install IIS with common sub-features

```powershell
Install-WindowsFeature -Name Web-Server, Web-Asp-Net45, Web-Net-Ext45, Web-ISAPI-Ext, Web-ISAPI-Filter -IncludeManagementTools
```

## Verify the installation

```powershell
Get-WindowsFeature -Name Web-Server
```

## Check the IIS service status

```powershell
Get-Service -Name W3SVC
```

## Start / stop / restart IIS

```powershell
Start-Service -Name W3SVC
Stop-Service -Name W3SVC
Restart-Service -Name W3SVC
```

## Manage sites with the WebAdministration module

```powershell
# List all sites
Get-Website

# Create a new site
New-Website -Name "MySite" -PhysicalPath "C:\inetpub\wwwroot\MySite" -Port 8080

# Start / stop a site
Start-Website -Name "MySite"
Stop-Website -Name "MySite"

# Remove a site
Remove-Website -Name "MySite"
```

## Remove IIS

```powershell
Uninstall-WindowsFeature -Name Web-Server
```

## References
- [Install-WindowsFeature](https://learn.microsoft.com/powershell/module/servermanager/install-windowsfeature)
- [WebAdministration module](https://learn.microsoft.com/powershell/module/webadministration/)
