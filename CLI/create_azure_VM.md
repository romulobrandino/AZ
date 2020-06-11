# Create virtual machines with the Azure CLI

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

## 

## 

## 


