# PowerShell Commands

## Test-Connection
Sends ICMP echo request packets, or pings, to one or more computers. 
```PowerShell
$ Test-Connection -TargetName google.com -Traceroute -IPv4
Test-NetConnection -ComputerName 192.168.2.4 -Port 3389
Test-NetConnection -ComputerName google.com
Test-NetConnection -ComputerName bbc.com

$ Test-Connection
    [-TargetName] <string[]>
    [-Ping]
    [-IPv4]
    [-IPv6]
    [-ResolveDestination]
    [-Source <string>]
    [-MaxHops <int>]
    [-Count <int>]
    [-Delay <int>]
    [-BufferSize <int>]
    [-DontFragment]
    [-TimeoutSeconds <int>]
    [-Quiet]
    [<CommonParameters>]
```

https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/test-connection?view=powershell-7

Test-NetConnection
```PowerShell
$ Test-NetConnection -ComputerName management.azure.com -Port 443
```
```PowerShell
$ Test-NetConnection -InformationLevel "Detailed"
```

```PowerShell
$resource = Get-AzResource -Name '*****' -ResourceGroupName '*****'
$resource.Tags.Add("testkey","testvalue")
$resource | Set-AzResource -Force
```




https://docs.microsoft.com/en-us/powershell/module/nettcpip/test-netconnection?view=win10-ps

