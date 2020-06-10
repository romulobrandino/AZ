# Azure Command-Line Interface (CLI) documentation

https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest


## Install Azure CLI on Windows

You can also install the Azure CLI using PowerShell. Start PowerShell as administrator and run the following command: Should be in Administrator mode....

```PowerShell
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi
```

This will download and install the latest version of the Azure CLI for Windows. If you already have a version installed, it will update the existing version. After the installation is complete, you will need to reopen PowerShell to use the Azure CLI.

You can now run the Azure CLI with the az command from either Windows Command Prompt or PowerShell. PowerShell offers some tab completion features not available from Windows Command Prompt. To sign in, run the az login command.

1. Run the login command.

```AzureCLI
az login
```

If the CLI can open your default browser, it will do so and load an Azure sign-in page.

Otherwise, open a browser page at https://aka.ms/devicelogin and enter the authorization code displayed in your terminal.

Sign in with your account credentials in the browser.

To learn more about different authentication methods, see Sign in with Azure CLI.


## Install Azure in Linux, for example in Ubuntu WSL 2 (Windows Subsystem for Linux)

If you are running a distribution that comes with apt, such as Ubuntu or Debian, there's an x86_64 package available for the Azure CLI. This package has been tested with and is supported for:

* Ubuntu trusty, xenial, artful, bionic, and disco
* Debian wheezy, jessie, stretch, and buster
The current version of the Azure CLI is 2.7.0. For information about the latest release, see the release notes. To find your installed version and see if you need to update, run ``az --version.``

### Install Azure CLI with apt

**Install**
We offer two ways to install the Azure CLI with distributions that support apt: As an all-in-one script that runs the install commands for you, and instructions that you can run as a step-by-step process on your own.

**Install with one command**
We offer and maintain a script which runs all of the installation commands in one step. Run it by using curl and pipe directly to bash, or download the script to a file and inspect it before running.


```Bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

**Manual install instructions**
If you don't want to run a script as superuser or the all-in-one script fails, follow these steps to install the Azure CLI.

1. Get packages needed for the install process:

```Bash
sudo apt-get update
sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg
```

2. Download and install the Microsoft signing key:

```Bash
curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
```

3. Add the Azure CLI software repository:

```Bash
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list
```
4. Update repository information and install the azure-cli package:

```Bash
sudo apt-get update
sudo apt-get install azure-cli
```

Run the Azure CLI with the az command. To sign in, use the az login command.

Run the login command.
```Azure CLI
az login
```

If the CLI can open your default browser, it will do so and load an Azure sign-in page.

Otherwise, open a browser page at https://aka.ms/devicelogin and enter the authorization code displayed in your terminal.

Sign in with your account credentials in the browser.

To learn more about different authentication methods, see Sign in with Azure CLI.


You can test the connection with ``az account list``