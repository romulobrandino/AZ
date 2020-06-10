# Azure Command-Line Interface (CLI) documentation

https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest


## Install Azure CLI on Windows

You can also install the Azure CLI using PowerShell. Start PowerShell as administrator and run the following command:

```PowerShell
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi
```

This will download and install the latest version of the Azure CLI for Windows. If you already have a version installed, it will update the existing version. After the installation is complete, you will need to reopen PowerShell to use the Azure CLI.

You can now run the Azure CLI with the az command from either Windows Command Prompt or PowerShell. PowerShell offers some tab completion features not available from Windows Command Prompt. To sign in, run the az login command.

1. Run the login command.

```AzureCLI
az login
```


