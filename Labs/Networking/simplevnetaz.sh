#!/bin/bash

# Create a vnet
# az network vnet create

az network vnet create -g v-romubr -n BrazilVnet --address-prefix 172.16.0.0/16 \
    --subnet-name GatewaySubnet --subnet-prefix 172.16.0.0/27 \
    --subnet-name PublicSubnet --subnet-prefix 172.16.1.0/24 \
    --subnet-name PrivateSubnet --subnet-prefix 172.16.2.0/24 \
    --subnet-name AzureBastionSubnet --subnet-prefix 172.16.100.0/27

# Examples:
# az network vnet create -g MyResourceGroup -n MyVnet


#az network vnet create --name
#                       --resource-group
#                       [--address-prefixes]
#                       [--ddos-protection {false, true}]
#                       [--ddos-protection-plan]
#                       [--defer]
#                       [--dns-servers]
#                       [--location]
#                       [--network-security-group]
#                       [--subnet-name]
#                       [--subnet-prefixes]
#                       [--subscription]
#                       [--tags]
#                       [--vm-protection {false, true}]


