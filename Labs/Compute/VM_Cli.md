# Pre-defined VM sizes

When you create a virtual machine, you can supply a VM size value that will determine the amount of compute resources that will be devoted to the VM. This includes CPU, GPU, and memory that are made available to the virtual machine from Azure.

Azure defines a set of pre-defined VM sizes for Linux and Windows to choose from based on the expected usage.

Type	Sizes	Description
General purpose	Dsv3, Dv3, DSv2, Dv2, DS, D, Av2, A0-7	Balanced CPU-to-memory. Ideal for dev/test and small to medium applications and data solutions.
Compute optimized	Fs, F	High CPU-to-memory. Good for medium-traffic applications, network appliances, and batch processes.
Memory optimized	Esv3, Ev3, M, GS, G, DSv2, DS, Dv2, D	High memory-to-core. Great for relational databases, medium to large caches, and in-memory analytics.
Storage optimized	Ls	High disk throughput and IO. Ideal for big data, SQL, and NoSQL databases.
GPU optimized	NV, NC	Specialized VMs targeted for heavy graphic rendering and video editing.
High performance	H, A8-11	Our most powerful CPU VMs with optional high-throughput network interfaces (RDMA).

The available sizes change based on the region you're creating the VM in. You can get a list of the available sizes using the vm list-sizes command. Try typing this into Azure Cloud Shell:




Try checking some of the images in the other Azure sandbox available locations:
westus2
southcentralus
centralus
eastus
westeurope
southeastasia
japaneast
brazilsouth
australiasoutheast
centralindia

Tutorial: Create a custom image of an Azure VM with the Azure CLI
https://docs.microsoft.com/en-us/azure/virtual-machines/linux/tutorial-custom-images
