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
This command shows all of the information for the network interface of the VM. This data includes DNS settings, IP information, security settings, and the MAC address. Right now the goal is to obtain the public IP address and subnet object IDs.
```AzureCLI
az network nic show --ids $NIC_ID \
  --query '{IP:ipConfigurations[].publicIpAddress.id, Subnet:ipConfigurations[].subnet.id}' \
  -o json
```
```JSON
{
  "IP": [
    "/subscriptions/.../resourceGroups/TutorialResources/providers/Microsoft.Network/publicIPAddresses/TutorialVM1PublicIP"
  ],
  "Subnet": [
    "/subscriptions/.../resourceGroups/TutorialResources/providers/Microsoft.Network/virtualNetworks/TutorialVM1VNET/subnets/TutorialVM1Subnet"
  ]
}
```
This command displays a JSON object that has custom keys ('IP' and 'Subnet') for the extracted values. While this style of output might not be useful for command-line tools, it helps with human readability and can be used with custom scripts.

In order to use command-line tools, change the command to remove the custom JSON keys and output as ``tsv``. This style of output can be processed by the shell read command to load results into multiple variables. Since two values on separate lines are displayed, the read command delimiter must be set to the empty string rather than the default of non-newline whitespace.
```Bash
read -d '' IP_ID SUBNET_ID <<< $(az network nic show \
  --ids $NIC_ID \
  --query '[ipConfigurations[].publicIpAddress.id, ipConfigurations[].subnet.id]' \
  -o tsv)
```
You won't use the subnet ID right away, but it should be stored now to avoid having to perform a second lookup later. For now, use the public IP object ID to look up the public IP address and store it in a shell variable.
```Bash
VM1_IP_ADDR=$(az network public-ip show --ids $IP_ID \
  --query ipAddress \
  -o tsv)
```
Now you have the IP address of the VM stored in a shell variable. Go ahead and check that it is the same value that you used to initially connect to the VM.
```Bash
echo $VM1_IP_ADDR
```

## Creating a new VM on the existing subnet
The second VM uses the existing subnet. You can skip a few steps to get the public IP address of the new VM stored into an environment variable right away, since it's returned in the VM creation information. If you'd need other information about the VM later, it can always be obtained from the ``az vm``show command.

```Bash
VM2_IP_ADDR=$(az vm create -g TutorialResources \
  -n TutorialVM2 \
  --image UbuntuLTS \
  --generate-ssh-keys \
  --subnet $SUBNET_ID \
  --query publicIpAddress \
  -o tsv)
```
Using the stored IP address, SSH into the newly created VM.
```Bash
ssh $VM2_IP_ADDR
```
Go ahead and log out from the VM.


# Cleanup
Now that the tutorial is complete, it's time to clean up the created resources. You can delete individual resources with the delete command, but the safest way to remove all resources in a resource group is with group delete.
```AzureCLI
az group delete --name TutorialResources --no-wait
```
This command deletes the resources created during the tutorial, and is guaranteed to deallocate them in the correct order. The ``--no-wait`` parameter keeps the CLI from blocking while the deletion takes place. If you want to wait until the deletion is complete or watch it progress, use the group wait command.
```Bash
az group wait --name TutorialResources --deleted
```

With cleanup completed, the tutorial is finished. Continue on for a summary of everything you learned and links to resources that will help you with your next steps.

# Summary


Summary

Congratulations! You learned how to create VMs with new or existing resources, used the --query and --output arguments to capture data to be stored in shell variables, and looked at some of the resources that get created for Azure VMs.

Where you go from here depends on what you plan to use the CLI for. There are a variety of materials that go further in depth on the features covered in this tutorial.
Samples

If you want to get started right away with specific tasks, look at some sample scripts.

* Working with Linux VMs <https://docs.microsoft.com/en-us/azure/virtual-machines/linux/cli-samples?toc=%2fcli%2fazure%2ftoc.json> and Windows VMs <https://docs.microsoft.com/en-us/azure/virtual-machines/windows/cli-samples?toc=%2fcli%2fazure%2ftoc.json>
* Working with webapps<https://docs.microsoft.com/en-us/azure/app-service/app-service-cli-samples?toc=%2Fcli%2Fazure%2Ftoc.json> and Azure Functions <https://docs.microsoft.com/en-us/azure/azure-functions/functions-cli-samples?toc=%2fcli%2fazure%2ftoc.json>
* Working with databases - Azure SQL databases <https://docs.microsoft.com/en-us/azure/sql-database/sql-database-cli-samples?toc=%2fcli%2fazure%2ftoc.json>, PostgreSQL<https://docs.microsoft.com/en-us/azure/postgresql/sample-scripts-azure-cli?toc=%2fcli%2fazure%2ftoc.json>, MySQL<https://docs.microsoft.com/en-us/azure/mysql/sample-scripts-azure-cli?toc=%2fcli%2fazure%2ftoc.json>, and CosmosDB<https://docs.microsoft.com/en-us/azure/cosmos-db/cli-samples?toc=%2fcli%2fazure%2ftoc.json>.

In-depth CLI documentation

There are also topics that go deeper into the CLI features that were shown in the tutorial.

* Learn more about output formats <https://docs.microsoft.com/en-us/cli/azure/format-output-azure-cli?view=azure-cli-latest>
* Learn more about output queries <https://docs.microsoft.com/en-us/cli/azure/query-azure-cli?view=azure-cli-latest>
* Learn more about authorization in Azure <https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli?view=azure-cli-latest>

Other useful documentation

You might want to take time to explore more advanced features of the CLI, like configuring defaults<https://docs.microsoft.com/en-us/cli/azure/azure-cli-configuration?view=azure-cli-latest> or extensions <https://docs.microsoft.com/en-us/cli/azure/azure-cli-extensions-overview?view=azure-cli-latest>.
Feedback

If you'd like to give feedback, suggestions, or ask questions about the CLI, there are a number of ways for you to get in touch.

* az feedback is a built-in command for the CLI that allows providing free-form feedback to the team.
* File a feature request or a bug report with the CLI in the Azure CLI repository<https://github.com/Azure/azure-cli>.
* Ask a question or get clarification by filing an issue in the Azure CLI documentation repository<https://github.com/MicrosoftDocs/azure-docs-cli/issues>.

We hope that you enjoy using the Azure CLI!

https://github.com/Azure/azure-cli
