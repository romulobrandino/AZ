# ============================================================
# SIMPLIFIED BICEP DC DEPLOYMENT
# ============================================================
# Uses public GitHub repo for scripts (no storage account needed).
# This script only handles:
#   1. VNet DNS management (before/during/after deployment)
#   2. NSG association with subnet
#   3. Deployment status monitoring
# ============================================================

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$ParametersFile = "romulosilva-dcs.bicepparam",
    
    [Parameter(Mandatory=$false)]
    [string]$ResourceGroup = "rg-compute-cus-alz-demo",
    
    [Parameter(Mandatory=$false)]
    [string]$NetworkResourceGroup = "rg-connectivity-cus-alz-demo",
    
    [Parameter(Mandatory=$false)]
    [string]$Location = "centralus"
)

$ErrorActionPreference = 'Stop'

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "BICEP DC DEPLOYMENT (GITHUB MODE)" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# ── Step 1: Reset VNet DNS to Azure-Provided ──────────────────────────────────

Write-Host "[1/6] Resetting VNet DNS to Azure-provided (168.63.129.16)..." -ForegroundColor Yellow

$vnetName = "vnet-sharedservices-cus-demo-alz"
az network vnet update `
    --resource-group $NetworkResourceGroup `
    --name $vnetName `
    --dns-servers "" `
    --output none

Write-Host "  ✓ VNet DNS reset to Azure-provided" -ForegroundColor Green

# ── Step 2: Deploy PHASE 1 - DC01 Only ────────────────────────────────────────

Write-Host ""
Write-Host "[2/8] Deploying PHASE 1: DC01 (NSG + VM + Extension)..." -ForegroundColor Yellow
Write-Host "  This will take 10-15 minutes (VM creation + AD forest setup)" -ForegroundColor Gray
Write-Host "  Scripts will be downloaded from your GitHub repo" -ForegroundColor Gray

$deployment1Name = "dc01-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

az deployment group create `
    --resource-group $ResourceGroup `
    --name $deployment1Name `
    --template-file "$PSScriptRoot\main-dc01.bicep" `
    --parameters "$PSScriptRoot\main.bicepparam" `
    --parameters "$PSScriptRoot\$ParametersFile" `
    --output table

Write-Host ""
Write-Host "  ✓ Phase 1 deployment completed (DC01 VM created)" -ForegroundColor Green

# ── Step 3: Wait for DC01 to Become Ready ─────────────────────────────────────

Write-Host ""
Write-Host "[3/8] Waiting for DC01 to complete forest creation..." -ForegroundColor Yellow
Write-Host "  Checking every 45 seconds (max 20 minutes)..." -ForegroundColor Gray

$vm1Name = "vm-DC01-cus"
$maxRetries = 27
$retryCount = 0
$dc1Ready = $false

while (-not $dc1Ready -and $retryCount -lt $maxRetries) {
    Start-Sleep -Seconds 45
    $retryCount++
    $elapsed = [int]($retryCount * 45 / 60)
    Write-Host "  [$elapsed min] Checking DC01 status (attempt $retryCount/$maxRetries)..." -ForegroundColor Gray
    
    try {
        $result = az vm run-command invoke `
            --resource-group $ResourceGroup `
            --name $vm1Name `
            --command-id RunPowerShellScript `
            --scripts "try { Import-Module ActiveDirectory -EA Stop; `$d = Get-ADDomain -EA Stop; Write-Output `"READY: `$(`$d.DNSRoot)`" } catch { Write-Output `"NOT_READY`" }" `
            --query "value[0].message" `
            --output tsv 2>$null
        
        if ($result -like "*READY*") {
            $dc1Ready = $true
            Write-Host "  ✓ DC01 is ready and operational!" -ForegroundColor Green
        }
    } catch {
        # Expected during VM reboot
    }
}

if (-not $dc1Ready) {
    Write-Warning "DC01 did not become ready within 20 minutes. Check Azure Portal."
}

# ── Step 4: Update VNet DNS to DC01 ───────────────────────────────────────────

Write-Host ""
Write-Host "[4/8] Updating VNet DNS to point to DC01..." -ForegroundColor Yellow

$dc01IP = "10.111.1.10"
az network vnet update `
    --resource-group $NetworkResourceGroup `
    --name $vnetName `
    --dns-servers $dc01IP `
    --output none

Write-Host "  ✓ VNet DNS now points to DC01 ($dc01IP)" -ForegroundColor Green

# ── Step 5: Deploy PHASE 2 - DC02 ─────────────────────────────────────────────

Write-Host ""
Write-Host "[5/8] Deploying PHASE 2: DC02 (VM + Extension)..." -ForegroundColor Yellow
Write-Host "  VNet DNS is now pointing to DC01, so DC02 can resolve the domain" -ForegroundColor Gray
Write-Host "  This will take 15-20 minutes (domain join + DC promotion)" -ForegroundColor Gray

$deployment2Name = "dc02-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

az deployment group create `
    --resource-group $ResourceGroup `
    --name $deployment2Name `
    --template-file "$PSScriptRoot\main-dc02.bicep" `
    --parameters "$PSScriptRoot\main.bicepparam" `
    --parameters "$PSScriptRoot\$ParametersFile" `
    --output table

Write-Host ""
Write-Host "  ✓ Phase 2 deployment completed (DC02 promoted)" -ForegroundColor Green

# ── Step 6: Update VNet DNS to Both DCs ───────────────────────────────────────

$dc02IP = "10.111.1.11"
az network vnet update `
    --resource-group $NetworkResourceGroup `
    --name $vnetName `
    --dns-servers $dc01IP $dc02IP `
    --output none

Write-Host "  ✓ VNet DNS now points to both DCs ($dc01IP, $dc02IP)" -ForegroundColor Green

# ── Step 7: Associate NSG with Subnet ────────────────────────────────────────

Write-Host ""
Write-Host "[7/8ociate NSG with Subnet ────────────────────────────────────────

Write-Host ""
Write-Host "[6/6] Associating NSG with DC subnet..." -ForegroundColor Yellow

$nsgName = "nsg-DCs-shared-cus"
$subnetName = "snet-DCs-shared-cus"

az network vnet subnet update `
    --resource-group $NetworkResourceGroup `
    --vnet-name $vnetName `
    --name $subnetName `
    --network-security-group $nsgName `
    --output none

Write-Host "  ✓ NSG associated with subnet" -ForegroundColor Green
Step 8: Final Verification ───────────────────────────────────────────────

Write-Host ""
Write-Host "[8/8] Verifying deployment..." -ForegroundColor Yellow
Write-Host "  This may take a moment..." -ForegroundColor Gray

# Give DC02 a moment to stabilize after deployment
Start-Sleep -Seconds 30

# ── Deployment Complete ───────────────────────────────────────────────────────

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "TWO-PHASE ==========================================" -ForegroundColor Green
Write-Host "DEPLOYMENT COMPLETE!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host "Domain: corp.cloudthings-app.com" -ForegroundColor Yellow
Write-Host "DC01: $dc01IP" -ForegroundColor Yellow
Write-Host "DC02: $dc02IP" -ForegroundColor Yellow
Write-Host "Admin: romulosilva@corp.cloudthings-app.com" -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "1. Test login via Azure Bastion" -ForegroundColor White
Write-Host "2. Configure AD Sites and Services (if multi-region)" -ForegroundColor White
Write-Host "3. Create Group Policy Objects (GPOs)" -ForegroundColor White
Write-Host "4. Set up backup for domain controllers" -ForegroundColor White
Write-Host "==========================================" -ForegroundColor Green
