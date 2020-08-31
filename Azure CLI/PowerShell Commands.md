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

## PSPING

The PsPing command tests ping connectivity through an endpoint. This command also measures the latency and bandwidth availability to a service. To verify that a route is available from your client to a VM through Load Balancer, use the following command. Replace <ip address> and <port> with the IP address and front-end port of the Load Balancer instance.
    
```bash
psping -n 100 -i 0 -q -h <ip address>:<port>
```
Flag	Description
-n	Specifies the number of pings to do.
-i	Indicates the interval in seconds between iterations.
-q	Suppresses output during the pings. Only a summary is shown at the end.
-h	Prints a histogram that shows the latency of the requests.





https://docs.microsoft.com/en-us/powershell/module/nettcpip/test-netconnection?view=win10-ps

