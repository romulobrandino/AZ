# ============================================================
# DC01 SETUP SCRIPT
# ============================================================
# Executed by CustomScriptExtension on DC01.
# Phase 0 (this script): Initialize disk, install AD DS, create forest
# Phase 1 (scheduled task after reboot): Configure domain, create admin user
# ============================================================

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$DomainName,
    
    [Parameter(Mandatory=$true)]
    [string]$AdminPassword,
    
    [Parameter(Mandatory=$true)]
    [string]$PrimaryAdmin
)

$ErrorActionPreference = 'Stop'

# ── PHASE 0: Disk Initialization + AD DS Installation ────────────────────────

Write-Output "============================================================"
Write-Output "DC01 SETUP - PHASE 0: Disk Init + Forest Creation"
Write-Output "============================================================"

# Create C:\Tools directory
if (-not (Test-Path 'C:\Tools')) {
    New-Item -Path 'C:\Tools' -ItemType Directory -Force | Out-Null
    Write-Output "Created C:\Tools folder"
} else {
    Write-Output "C:\Tools folder already exists"
}

# Download Azure CLI
Write-Output ""
Write-Output "Downloading Azure CLI..."
$azCliFolder = 'C:\Tools\azcli'
if (-not (Test-Path $azCliFolder)) {
    New-Item -Path $azCliFolder -ItemType Directory -Force | Out-Null
    Write-Output "Created $azCliFolder folder"
}

$azCliUrl = 'https://aka.ms/installazurecliwindows'
$azCliPath = Join-Path $azCliFolder 'AzureCLI.msi'

try {
    if (-not (Test-Path $azCliPath)) {
        Write-Output "Downloading Azure CLI from $azCliUrl..."
        Invoke-WebRequest -Uri $azCliUrl -OutFile $azCliPath -UseBasicParsing
        $fileSize = [math]::Round((Get-Item $azCliPath).Length / 1MB, 2)
        Write-Output "SUCCESS: Azure CLI downloaded ($fileSize MB) to $azCliPath"
    } else {
        Write-Output "Azure CLI installer already exists at $azCliPath"
    }
} catch {
    Write-Output "WARNING: Failed to download Azure CLI: $($_.Exception.Message)"
    Write-Output "Continuing with AD setup..."
}

# Initialize and format the data disk (F:)
Write-Output ""
Write-Output "Initializing data disk..."
$rawDisk = Get-Disk |
    Where-Object { $_.PartitionStyle -eq 'RAW' -and $_.OperationalStatus -eq 'Online' } |
    Sort-Object Size -Descending |
    Select-Object -First 1

if ($rawDisk) {
    Write-Output "Found RAW disk: Number $($rawDisk.Number), Size $([math]::Round($rawDisk.Size/1GB,2))GB"
    Initialize-Disk -Number $rawDisk.Number -PartitionStyle GPT | Out-Null
    New-Partition -DiskNumber $rawDisk.Number -UseMaximumSize -DriveLetter F | Out-Null
    Format-Volume -DriveLetter F -FileSystem NTFS -NewFileSystemLabel 'ADDS-Data' -Confirm:$false -Force | Out-Null
    Write-Output "SUCCESS: Disk initialized and formatted as F:"
} else {
    Write-Output "ERROR: No RAW disk found to initialize"
    exit 1
}

Get-Volume -DriveLetter F | Format-List DriveLetter, FileSystemLabel, FileSystem, Size

# Install AD Domain Services role
Write-Output ""
Write-Output "Installing AD-Domain-Services role..."
$featureResult = Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

if ($featureResult.Success) {
    Write-Output "SUCCESS: AD-Domain-Services role installed"
    Write-Output "Installed: $($featureResult.FeatureResult.Name -join ', ')"
} else {
    Write-Output "ERROR: Failed to install AD-Domain-Services"
    exit 1
}

# Import ADDSDeployment module
Write-Output ""
Write-Output "Importing ADDSDeployment module..."
Import-Module ADDSDeployment -ErrorAction Stop
Write-Output "SUCCESS: ADDSDeployment module loaded"

# ── Create Phase 1 Script (runs after reboot) ────────────────────────────────

Write-Output ""
Write-Output "Creating post-reboot configuration script..."

$phase1Script = @"
`$ErrorActionPreference = 'Stop'
`$logFile = 'C:\Tools\DC01-Phase1.log'

function Write-Log {
    param([string]`$Message)
    `$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    "`$timestamp - `$Message" | Out-File -FilePath `$logFile -Append
    Write-Output `$Message
}

try {
    Write-Log "============================================================"
    Write-Log "DC01 SETUP - PHASE 1: Domain Configuration"
    Write-Log "============================================================"

    # Wait for AD Web Services to be ready
    Write-Log "Waiting for Active Directory Web Services..."
    `$retries = 0
    while (`$retries -lt 20) {
        try {
            Import-Module ActiveDirectory -ErrorAction Stop
            `$domain = Get-ADDomain -ErrorAction Stop
            Write-Log "AD Web Services ready. Domain: `$(`$domain.DNSRoot)"
            break
        } catch {
            Start-Sleep -Seconds 10
            `$retries++
        }
    }

    if (`$retries -ge 20) {
        throw "AD Web Services did not become ready in time"
    }

    # Get domain DN
    `$dn = (Get-ADDomain).DistinguishedName
    Write-Log "Domain DN: `$dn"

    # Add alternate UPN suffix
    Write-Log ""
    Write-Log "Adding alternate UPN suffix..."
    `$upnSuffix = '$DomainName'.Split('.')[1..$('$DomainName'.Split('.').Count-1)] -join '.'
    Get-ADForest | Set-ADForest -UPNSuffixes @{Add=`$upnSuffix} -ErrorAction SilentlyContinue
    Write-Log "UPN suffix added: `$upnSuffix"

    # Create Tier-0 OU structure
    Write-Log ""
    Write-Log "Creating Tier-0 OU structure..."
    New-ADOrganizationalUnit -Name 'Tier-0' -Path `$dn -ProtectedFromAccidentalDeletion `$true -ErrorAction SilentlyContinue
    New-ADOrganizationalUnit -Name 'Admin Accounts' -Path "OU=Tier-0,`$dn" -ErrorAction SilentlyContinue
    Write-Log "OUs created successfully"

    # Create primary domain admin account
    Write-Log ""
    Write-Log "Creating domain admin account: $PrimaryAdmin"
    `$pwd = ConvertTo-SecureString '$AdminPassword' -AsPlainText -Force
    
    New-ADUser -Name '$PrimaryAdmin' ``
        -SamAccountName '$PrimaryAdmin' ``
        -UserPrincipalName '$PrimaryAdmin@$DomainName' ``
        -AccountPassword `$pwd ``
        -Enabled `$true ``
        -Path "OU=Admin Accounts,OU=Tier-0,`$dn" ``
        -ErrorAction Stop
    
    Write-Log "User created successfully"

    # Add to privileged groups
    Write-Log ""
    Write-Log "Adding to privileged groups..."
    Add-ADGroupMember 'Domain Admins' '$PrimaryAdmin' -ErrorAction SilentlyContinue
    Add-ADGroupMember 'Enterprise Admins' '$PrimaryAdmin' -ErrorAction SilentlyContinue
    Add-ADGroupMember 'Schema Admins' '$PrimaryAdmin' -ErrorAction SilentlyContinue
    Write-Log "Group memberships configured"

    Write-Log ""
    Write-Log "============================================================"
    Write-Log "DC01 PHASE 1 COMPLETE"
    Write-Log "============================================================"

    # Unregister this scheduled task
    Unregister-ScheduledTask -TaskName 'DC01-Phase1-Config' -Confirm:`$false -ErrorAction SilentlyContinue

} catch {
    Write-Log "ERROR: `$(`$_.Exception.Message)"
    Write-Log "Stack Trace: `$(`$_.ScriptStackTrace)"
    exit 1
}
"@

Set-Content -Path 'C:\Tools\DC01-Phase1.ps1' -Value $phase1Script -Force
Write-Output "Phase 1 script created: C:\Tools\DC01-Phase1.ps1"

# Create scheduled task to run Phase 1 after reboot
Write-Output "Creating scheduled task for Phase 1..."
$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-ExecutionPolicy Bypass -File C:\Tools\DC01-Phase1.ps1'
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest
Register-ScheduledTask -TaskName 'DC01-Phase1-Config' -Action $action -Trigger $trigger -Principal $principal -Force | Out-Null
Write-Output "Scheduled task registered"

# ── Create New AD Forest ──────────────────────────────────────────────────────

Write-Output ""
Write-Output "============================================================"
Write-Output "Creating new Active Directory forest: $DomainName"
Write-Output "This will trigger an automatic reboot..."
Write-Output "============================================================"

try {
    $securePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force
    
    Install-ADDSForest `
        -DomainName $DomainName `
        -DatabasePath 'F:\NTDS' `
        -LogPath 'F:\NTDS' `
        -SysvolPath 'F:\SYSVOL' `
        -InstallDNS `
        -SafeModeAdministratorPassword $securePassword `
        -Force `
        -NoRebootOnCompletion:$false
    
    Write-Output "SUCCESS: Forest creation initiated"
    Write-Output "VM will reboot automatically and run Phase 1 configuration"
    
} catch {
    Write-Output "ERROR: Forest creation failed: $($_.Exception.Message)"
    exit 1
}
