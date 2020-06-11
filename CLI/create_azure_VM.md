# Create virtual machines with the Azure CLI

https://docs.microsoft.com/en-us/cli/azure/azure-cli-vm-tutorial?view=azure-cli-latest

In this tutorial, you learn all of the steps involved in setting up a virtual machine with the Azure CLI. The tutorial also covers output queries, Azure resource reuse, and resource cleanup.

This tutorial can be completed with the interactive experienced offered through Azure Cloud Shell, or you may install the CLI locally.

Use ctrl-shift-v (cmd-shift-v on macOS) to paste tutorial text into Azure Cloud Shell.

## Sign in
If you're using a local install of the CLI, you need to sign in before performing any other steps.

```Bash
az login
```
Complete the authentication process by following the steps displayed in your terminal.

## Create a resource group
In Azure, all resources are allocated in a resource management group. Resource groups provide logical groupings of resources that make them easier to work with as a collection. For this tutorial, all of the created resources go into a single group named TutorialResources.
```Bash
az group create --name TutorialResources --location eastus
```

## Create a virtual machine
Virtual machines in Azure have a large number of dependencies. The CLI creates these resources for you based on the command-line arguments you specify.

Create a new virtual machine running Ubuntu, which uses SSH authentication for login.
```Bashaz vm create --resource-group TutorialResources \
  --name TutorialVM1 \
  --image UbuntuLTS \
  --generate-ssh-keys \
  --output json \
  --verbose
```

Note: If you have an SSH key named id_rsa already available, this key is used for authentication rather than having a new key generated.

As the VM is created, you see the local values used and Azure resources being created due to the --verbose option. Once the VM is ready, JSON is returned from the Azure service including the public IP address.

```JSON
{
  "fqdns": "",
  "id": "...",
  "location": "eastus",
  "macAddress": "...",
  "powerState": "VM running",
  "privateIpAddress": "...",
  "publicIpAddress": <PUBLIC_IP_ADDRESS>,
  "resourceGroup": "TutorialResources",
  "zones": ""
}
```
Confirm that the VM is running by connecting over SSH.
```Bash
ssh <PUBLIC_IP_ADDRESS>
```
Go ahead and log out from the VM.

There are other ways to get this IP address after the VM has started. In the next section you will see how to get detailed information on the VM, and how to filter it.

## Get VM information with queries

## 

## 


