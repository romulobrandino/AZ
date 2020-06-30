PowerShell Commands

Test-NetConnection
```PowerShell
$ Test-NetConnection -ComputerName management.azure.com -Port 443
```

```PowerShell
$resource = Get-AzResource -Name '*****' -ResourceGroupName '*****'
$resource.Tags.Add("testkey","testvalue")
$resource | Set-AzResource -Force
```