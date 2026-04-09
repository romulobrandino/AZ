# ============================================================
# DC02 SETUP SCRIPT
# ============================================================
# Executed by CustomScriptExtension on DC02.
# Phase 0 (this script): Initialize disk, install AD DS, wait for DC01, join domain
# Phase 1 (scheduled task after reboot): Promote as replica domain controller
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

# ── PHASE 0: Disk Initialization + Domain Join ───────────────────────────────

Write-Output "============================================================"
Write-Output "DC02 SETUP - PHASE 0: Disk Init + Domain Join"
Write-Output "============================================================"

# Create C:\Tools directory
if (-not (Test-Path 'C:\Tools')) {
    New-Item -Path 'C:\Tools' -ItemType Directory -Force | Out-Null
    Write-Output "Created C:\Tools folder"
} else {
    Write-Output "C:\Tools folder already exists"
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
    Write-Output "WARNING: No RAW disk found (may already be initialized)"
}

if (Test-Path 'F:\') {
    Get-Volume -DriveLetter F | Format-List DriveLetter, FileSystemLabel, FileSystem, Size
}

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

# ── Wait for DC01 DNS to become available ─────────────────────────────────────

Write-Output ""
Write-Output "============================================================"
Write-Output "Waiting for DC01 to become ready..."
Write-Output "============================================================"

# DC01 IP address (from VNet configuration)
$dc01IP = "10.111.1.10"

$maxRetries = 40  # 40 retries * 30 seconds = 20 minutes max wait
$retryCount = 0
$dc01Ready = $false

while (-not $dc01Ready -and $retryCount -lt $maxRetries) {
    $retryCount++
    $elapsed = [int]($retryCount * 30 / 60)
    Write-Output "[$elapsed min] Attempt $retryCount of $maxRetries - Checking DC01 DNS..."
    
    try {
        # Try to resolve the domain name using DC01 as DNS server
        $result = Resolve-DnsName -Name $DomainName -Server $dc01IP -Type A -ErrorAction Stop
        
        if ($result) {
            $dc01Ready = $true
            Write-Output "SUCCESS: DC01 DNS is responding!"
            Write-Output "Domain resolved: $($result.Name) -> $($result.IPAddress)"
        }
    } catch {
        Write-Output "  DC01 not ready yet: $($_.Exception.Message)"
        if ($retryCount -lt $maxRetries) {
            Start-Sleep -Seconds 30
        }
    }
}

if (-not $dc01Ready) {
    Write-Output "ERROR: DC01 did not become ready within 20 minutes"
    Write-Output "Cannot proceed with domain join"
    exit 1
}

# ── Create Phase 1 Script (runs after reboot) ────────────────────────────────

Write-Output ""
Write-Output "Creating post-reboot DC promotion script..."

$phase1Script = @"
`$ErrorActionPreference = 'Stop'
`$logFile = 'C:\Tools\DC02-Phase1.log'

function Write-Log {
    param([string]`$Message)
    `$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    "`$timestamp - `$Message" | Out-File -FilePath `$logFile -Append
    Write-Output `$Message
}

try {
    Write-Log "============================================================"
    Write-Log "DC02 SETUP - PHASE 1: Domain Controller Promotion"
    Write-Log "============================================================"

    # Wait a bit for services to stabilize after domain join
    Start-Sleep -Seconds 30

    # Import ADDSDeployment module
    Write-Log "Importing ADDSDeployment module..."
    Import-Module ADDSDeployment -ErrorAction Stop

    # Create domain credentials
    `$securePassword = ConvertTo-SecureString '$AdminPassword' -AsPlainText -Force
    `$domainCred = New-Object PSCredential('$DomainName\$PrimaryAdmin', `$securePassword)

    # Promote as replica domain controller
    Write-Log ""
    Write-Log "Promoting DC02 as replica domain controller..."
    Write-Log "This will trigger an automatic reboot..."

    Install-ADDSDomainController ``
        -DomainName '$DomainName' ``
        -DatabasePath 'F:\NTDS' ``
        -LogPath 'F:\NTDS' ``
        -SysvolPath 'F:\SYSVOL' ``
        -InstallDNS ``
        -Credential `$domainCred ``
        -SafeModeAdministratorPassword `$securePassword ``
        -Force ``
        -NoRebootOnCompletion:`$false

    Write-Log "SUCCESS: DC promotion initiated"
    Write-Log "VM will reboot automatically"

    # Unregister this scheduled task
    Unregister-ScheduledTask -TaskName 'DC02-Phase1-Promotion' -Confirm:`$false -ErrorAction SilentlyContinue

} catch {
    Write-Log "ERROR: `$(`$_.Exception.Message)"
    Write-Log "Stack Trace: `$(`$_.ScriptStackTrace)"
    exit 1
}
"@

Set-Content -Path 'C:\Tools\DC02-Phase1.ps1' -Value $phase1Script -Force
Write-Output "Phase 1 script created: C:\Tools\DC02-Phase1.ps1"

# Create scheduled task to run Phase 1 after reboot
Write-Output "Creating scheduled task for Phase 1..."
$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-ExecutionPolicy Bypass -File C:\Tools\DC02-Phase1.ps1'
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest
Register-ScheduledTask -TaskName 'DC02-Phase1-Promotion' -Action $action -Trigger $trigger -Principal $principal -Force | Out-Null
Write-Output "Scheduled task registered"

# ── Join Domain ───────────────────────────────────────────────────────────────

Write-Output ""
Write-Output "============================================================"
Write-Output "Joining domain: $DomainName"
Write-Output "This will trigger an automatic reboot..."
Write-Output "============================================================"

try {
    $securePassword = ConvertTo-SecureString $AdminPassword -AsPlainText -Force
    $domainCred = New-Object PSCredential("$DomainName\$PrimaryAdmin", $securePassword)
    
    Add-Computer `
        -DomainName $DomainName `
        -Credential $domainCred `
        -Restart `
        -Force
    
    Write-Output "SUCCESS: Domain join initiated"
    Write-Output "VM will reboot and run Phase 1 (DC promotion)"
    
} catch {
    Write-Output "ERROR: Domain join failed: $($_.Exception.Message)"
    exit 1
}
