# Application Gateway - Stop and Start with Azure CLI

## Overview
This guide provides Azure CLI commands to stop and start Azure Application Gateway instances. Stopping an Application Gateway when not in use can help reduce costs.

## Prerequisites
- Azure CLI installed and configured
- Appropriate permissions to manage Application Gateway resources
- Active Azure subscription

## Login to Azure
```bash
az login
az account set --subscription "<subscription-id-or-name>"
```

## Stop Application Gateway

### Stop a specific Application Gateway
```bash
az network application-gateway stop \
  --name <gateway-name> \
  --resource-group <resource-group-name>
```

### Example
```bash
az network application-gateway stop \
  --name myAppGateway \
  --resource-group myResourceGroup
```

## Start Application Gateway

### Start a specific Application Gateway
```bash
az network application-gateway start \
  --name <gateway-name> \
  --resource-group <resource-group-name>
```

### Example
```bash
az network application-gateway start \
  --name myAppGateway \
  --resource-group myResourceGroup
```

## Check Application Gateway Status

### Show Application Gateway details (including operational state)
```bash
az network application-gateway show \
  --name <gateway-name> \
  --resource-group <resource-group-name> \
  --query "{Name:name, ProvisioningState:provisioningState, OperationalState:operationalState}" \
  --output table
```

### Check if gateway is running
```bash
az network application-gateway show \
  --name <gateway-name> \
  --resource-group <resource-group-name> \
  --query "operationalState" \
  --output tsv
```

## List All Application Gateways

### List all Application Gateways in a resource group
```bash
az network application-gateway list \
  --resource-group <resource-group-name> \
  --output table
```

### List all Application Gateways in the subscription
```bash
az network application-gateway list \
  --output table
```

## Automation Script Example

### Bash script to stop Application Gateway
```bash
#!/bin/bash
RESOURCE_GROUP="myResourceGroup"
GATEWAY_NAME="myAppGateway"

echo "Stopping Application Gateway: $GATEWAY_NAME"
az network application-gateway stop \
  --name $GATEWAY_NAME \
  --resource-group $RESOURCE_GROUP

if [ $? -eq 0 ]; then
  echo "Application Gateway stopped successfully"
else
  echo "Failed to stop Application Gateway"
  exit 1
fi
```

### Bash script to start Application Gateway
```bash
#!/bin/bash
RESOURCE_GROUP="myResourceGroup"
GATEWAY_NAME="myAppGateway"

echo "Starting Application Gateway: $GATEWAY_NAME"
az network application-gateway start \
  --name $GATEWAY_NAME \
  --resource-group $RESOURCE_GROUP

if [ $? -eq 0 ]; then
  echo "Application Gateway started successfully"
else
  echo "Failed to start Application Gateway"
  exit 1
fi
```

## Important Notes

1. **Cost Implications**: Stopping an Application Gateway reduces costs, but you're still charged for the provisioned instance. To eliminate all costs, you must delete the gateway.

2. **Startup Time**: Starting an Application Gateway can take several minutes (typically 5-10 minutes) as Azure provisions the required resources.

3. **State Persistence**: Configuration and settings are preserved when you stop and start the gateway.

4. **Availability**: While stopped, the Application Gateway will not route traffic. Plan maintenance windows accordingly.

5. **Automation**: Consider using Azure Automation, Logic Apps, or scheduled scripts to automatically stop/start gateways based on usage patterns.

## Troubleshooting

### Check Azure CLI version
```bash
az --version
```

### Enable debug output
```bash
az network application-gateway stop \
  --name <gateway-name> \
  --resource-group <resource-group-name> \
  --debug
```

### View activity logs
```bash
az monitor activity-log list \
  --resource-group <resource-group-name> \
  --offset 1h \
  --query "[?contains(resourceId, 'applicationGateways')]" \
  --output table
```

## Related Commands

### Delete Application Gateway (to completely stop billing)
```bash
az network application-gateway delete \
  --name <gateway-name> \
  --resource-group <resource-group-name>
```

### Update Application Gateway settings
```bash
az network application-gateway update \
  --name <gateway-name> \
  --resource-group <resource-group-name> \
  --set tags.Environment=Production
```

## Additional Resources
- [Azure Application Gateway Documentation](https://docs.microsoft.com/azure/application-gateway/)
- [Azure CLI Reference - Application Gateway](https://docs.microsoft.com/cli/azure/network/application-gateway)
- [Azure Application Gateway Pricing](https://azure.microsoft.com/pricing/details/application-gateway/)

# Azure Login in Azure CLI
az login

# Sign in with credentials on the command line
az login -u <username> -p <password>

# Get a list of application gateways
az network application-gateway list -o table

# Stop-AzApplicationGateway
az network application-gateway stop -g MyResourceGroup -n MyAppGateway

# Start-AzApplicationGateway
az network application-gateway start -g MyResourceGroup -n MyAppGateway

# Get a specified application gateway
az network application-gateway show -g MyResourceGroup -n MyAppGateway
