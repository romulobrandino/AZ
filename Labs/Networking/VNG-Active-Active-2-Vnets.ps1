
# Step 1 - Create and configure VNet1

# 1. Declare your variables, If you need

Connect-AzAccount
Select-AzSubscription -SubscriptionName $Sub1

# The example below declares the variables using the values for this exercise. 
# Be sure to replace the values with your own when configuring for production. 
# You can use these variables if you are running through the steps to become familiar with this type of configuration. 
# Modify the variables, and then copy and paste into your PowerShell console.

$Sub1 = "Ross"
$RG1 = "v-romubr"
$Location1 = "East US"
$VNetName1 = "Romulo-Vnet-1"
$FESubName1 = "FrontEnd"
$BESubName1 = "Backend"
$GWSubName1 = "GatewaySubnet"
$VNetPrefix11 = "10.11.0.0/16"
$VNetPrefix12 = "10.12.0.0/16"
$FESubPrefix1 = "10.11.0.0/24"
$BESubPrefix1 = "10.12.0.0/24"
$GWSubPrefix1 = "10.12.255.0/27"
$VNet1ASN = 65010
$DNS1 = "8.8.8.8"
$GWName1 = "VNet1GW"
$GW1IPName1 = "VNet1GWIP1"
$GW1IPName2 = "VNet1GWIP2"
$GW1IPconf1 = "gw1ipconf1"
$GW1IPconf2 = "gw1ipconf2"
$Connection12 = "VNet1toVNet2"
$Connection151 = "VNet1toSite5_1"
$Connection152 = "VNet1toSite5_2"

# 2. Create a new resource group If needed
# New-AzResourceGroup -Name $RG1 -Location $Location1

# 3. Create TestVNet1
$fesub1 = New-AzVirtualNetworkSubnetConfig -Name $FESubName1 -AddressPrefix $FESubPrefix1
$besub1 = New-AzVirtualNetworkSubnetConfig -Name $BESubName1 -AddressPrefix $BESubPrefix1
$gwsub1 = New-AzVirtualNetworkSubnetConfig -Name $GWSubName1 -AddressPrefix $GWSubPrefix1

New-AzVirtualNetwork -Name $VNetName1 -ResourceGroupName $RG1 -Location $Location1 -AddressPrefix $VNetPrefix11,$VNetPrefix12 -Subnet $fesub1,$besub1,$gwsub1

# Step 2 - Create the VPN gateway for TestVNet1 with active-active mode




