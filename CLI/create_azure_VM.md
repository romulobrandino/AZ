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

Now that a VM has been created, detailed information about it can be retrieved. The common command for getting information from a resource is show.
```Bash
az vm show --name TutorialVM1 --resource-group TutorialResources
```

You'll see a lot of information, which can be difficult to parse visually. The returned JSON contains information on authentication, network interfaces, storage, and more. Most importantly, it contains the Azure object IDs for resources that the VM is connected to. Object IDs allow accessing these resources directly to get more information about the VM's configuration and capabilities.

In order to extract the object ID we want, the ``--query`` argument is used. Queries are written in the JMESPath query language. Start with getting the network interface controller (NIC) object ID.

```AzureCLI
az vm show --name TutorialVM1 \
  --resource-group TutorialResources \
  --query 'networkProfile.networkInterfaces[].id' \
  --output tsv
```
There's a lot going on here, just by adding the query. Each part of it references a key in the output JSON, or is a JMESPath operator.

* ``networkProfile`` is a key of the top-level JSON, which has networkInterfaces as a subkey. If a JSON value is a dictionary, its keys are referenced from the parent key with the . operator.
* The ``networkInterfaces`` value is an array, so it is flattened with the [] operator. This operator runs the remainder of the query on each array element. In this case, it gets the id value of every array element.

The output format tsv (tab-separated values) is guaranteed to only include the result data and whitespace consisting of tabs and newlines. Since the returned value is a single bare string, it's safe to assign directly to an environment variable.

Go ahead and assign the NIC object ID to an environment variable now.

This example also demonstrates the use of short arguments. You may use ``-g`` instead of ``--resource-group``, ``-n`` instead of ``--name``, and ``-o`` instead of ``--output``.

## Set environment variables from CLI output

Now that you have the NIC ID, run az network nic show to get its information. Note that you don't need a resource group here, since the resource group name is contained within the Azure resource ID.
```Bash
az network nic show --ids $NIC_ID
```




## 


