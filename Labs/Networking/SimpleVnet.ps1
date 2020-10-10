# Create the virtual network
# New-AzVirtualNetwork

$virtualNetwork = New-AzVirtualNetwork `
  -ResourceGroupName myResourceGroup `
  -Location EastUS `
  -Name myVirtualNetwork `
  -AddressPrefix 10.0.0.0/16

# Add a subnet
# Add-AzVirtualNetworkSubnetConfig

$subnetConfig = Add-AzVirtualNetworkSubnetConfig `
  -Name PublicSubnet `
  -AddressPrefix 10.0.1.0/24 `
  -VirtualNetwork $virtualNetwork

# Associate the subnet to the virtual network
$virtualNetwork | Set-AzVirtualNetwork