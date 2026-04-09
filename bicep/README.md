# Azure Domain Controllers Deployment - Bicep

Deploy two Windows Server 2025 domain controllers in Azure using Bicep templates.

## Repository Structure

```
bicep/
├── 📄 main.bicep                    ← Main template (PUBLISH TO GITHUB)
├── 📄 main.bicepparam               ← Generic parameters (PUBLISH TO GITHUB)
├── 🔒 romulosilva-dcs.bicepparam    ← Your personal config (KEEP LOCAL)
├── 📜 deploy-simple.ps1             ← Deployment script (PUBLISH TO GITHUB)
├── 📁 modules/                      ← Bicep modules (PUBLISH TO GITHUB)
│   ├── nsg.bicep
│   ├── dc01.bicep
│   └── dc02.bicep
└── 📁 scripts/                      ← PowerShell scripts (PUBLISH TO GITHUB)
    ├── setup-dc01.ps1
    └── setup-dc02.ps1
```

## What to Publish vs Keep Private

### ✅ Safe to Publish (No Secrets)
- `main.bicep` - Generic infrastructure template
- `main.bicepparam` - Generic parameter placeholders
- `modules/*.bicep` - All module templates
- `scripts/*.ps1` - Setup scripts (use parameters, no hardcoded secrets)
- `deploy-simple.ps1` - Deployment orchestration script
- `README.md` - This file

### 🔒 Keep Private/Local
- `romulosilva-dcs.bicepparam` - Contains your specific:
  - Subscription ID
  - Resource group names
  - Key Vault reference
  - Domain name
  - IP addresses

### ⚠️ Never Commit
- Passwords
- SAS tokens (not needed with GitHub approach)
- Service principal credentials

## Deployment Options

### Option 1: Direct Azure CLI (Simplest)

```powershell
cd c:\Tools\dcs-auto\bicep

az deployment group create `
  --resource-group rg-compute-cus-alz-demo `
  --template-file main.bicep `
  --parameters main.bicepparam `
  --parameters romulosilva-dcs.bicepparam
```

### Option 2: Using deploy-simple.ps1 (Recommended)

```powershell
cd c:\Tools\dcs-auto\bicep
.\deploy-simple.ps1
```

**What it does:**
- Resets VNet DNS before deployment
- Deploys infrastructure
- Waits for DC01 to become ready
- Updates VNet DNS to DC01
- Waits for DC02 promotion
- Updates VNet DNS to both DCs
- Associates NSG with subnet

**Estimated time:** 20-30 minutes

## How It Works

### 1. Scripts are Downloaded from GitHub

The VMs download setup scripts directly from your public GitHub repo:

```bicep
fileUris: [
  'https://raw.githubusercontent.com/romulobrandino/AZ/main/dcs-auto/bicep/scripts/setup-dc01.ps1'
]
```

**No storage account needed!**

### 2. Password Retrieved from Key Vault

Your personal `.bicepparam` file uses `getSecret()`:

```bicep
param adminPassword = getSecret(subscriptionId, 'rg-security-demo-001-cus', 'kv-cloudthings-cus', 'VMsecret')
```

Never stored in code.

### 3. VM Extensions Run Server-Side

Unlike `az vm run-command invoke` (client-side), CustomScriptExtension:
- ✅ Runs on the VM itself
- ✅ Survives terminal disconnection
- ✅ Tracked by Azure Resource Manager
- ✅ Supports post-reboot scheduled tasks

## GitHub Repository Setup

1. **Create folder structure in your repo:**
   ```
   AZ/
   └── dcs-auto/
       └── bicep/
           ├── main.bicep
           ├── main.bicepparam
           ├── deploy-simple.ps1
           ├── modules/
           │   ├── nsg.bicep
           │   ├── dc01.bicep
           │   └── dc02.bicep
           └── scripts/
               ├── setup-dc01.ps1
               └── setup-dc02.ps1
   ```

2. **Add `.gitignore` to exclude personal files:**
   ```gitignore
   # Personal/environment-specific parameter files
   *-dcs.bicepparam
   romulosilva-*.bicepparam
   personal*.bicepparam
   
   # Secrets
   *.secret
   *.key
   ```

3. **Commit and push:**
   ```bash
   git add main.bicep main.bicepparam modules/ scripts/ deploy-simple.ps1
   git commit -m "Add domain controller Bicep templates"
   git push
   ```

## Using Your Template from GitHub

Anyone can now use your template:

```powershell
# 1. Clone your repo
git clone https://github.com/romulobrandino/AZ.git
cd AZ/dcs-auto/bicep

# 2. Copy and customize the parameters file
cp main.bicepparam my-project.bicepparam
# Edit my-project.bicepparam with your values

# 3. Deploy
az deployment group create `
  --resource-group <your-rg> `
  --template-file main.bicep `
  --parameters main.bicepparam `
  --parameters my-project.bicepparam
```

## Architecture

- **2 VMs:** Windows Server 2025 Datacenter Azure Edition
- **VM Size:** Standard_D2as_v5
- **Security:** TrustedLaunch (Secure Boot + vTPM)
- **Disks:** 127 GB OS + 32 GB data (for NTDS/SYSVOL)
- **Networking:** Static IPs, NSG with AD port rules
- **AD Setup:** New forest → DC01 promoted → DC02 joins and replicates

## Troubleshooting

### Deployment fails during VM extension
- Check GitHub repo is public
- Verify script paths match your repo structure
- Check VM has outbound internet access

### DC01 promotion timeout
- RDP to DC01 and check `C:\Tools\DC01-Phase1.log`
- Verify disk F: was created successfully
- Check Event Viewer → Directory Service logs

### DC02 can't reach DC01
- Verify VNet DNS was updated to DC01 IP
- Check NSG rules allow traffic between DCs
- Restart DC02 to pick up new DNS settings

## Next Steps After Deployment

1. **Validate replication:**
   ```powershell
   repadmin /replsummary
   ```

2. **Create additional OUs and GPOs**

3. **Configure AD Sites and Services** (if multi-region)

4. **Set up backup** for domain controllers

5. **Join application VMs** to the domain
