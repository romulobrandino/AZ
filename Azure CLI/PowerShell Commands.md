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

## netsh

The netsh utility is a general-purpose network configuration tool. Use the trace command in netsh to capture network traffic. Then analyze it by using a tool such as Microsoft Message Analyzer or Wireshark. Use netsh trace to examine the network packets sent and received by psping when you test connectivity through Load Balancer as follows:

1. Start a network trace from a command prompt running as Administrator. The following example traces internet client traffic (HTTP requests) to and from the specified IP address. Replace <ip address> with the address of the Load Balancer instance. The trace data is written to a file named trace.etl:
    
```PowerShell
netsh trace start ipv4.address=<ip address> capture=yes scenario=internetclient tracefile=trace.etl
```
2. Run psping to test connectivity

```PowerShell
psping -n 100 -i 0 -q <ip address>:<port>
```

3. Stop tracing

```PowerShell
netsh trace stop
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

Typical output looks like this:

```bash
TCP connect to nn.nn.nn.nn:nn:
101 iterations (warmup 1) ping test: 100%

TCP connect statistics for nn.nn.nn.nn:nn:
  Sent = 100, Received = 100, Lost = 0 (0% loss),
  Minimum = 7.48ms, Maximum = 9.08ms, Average = 8.30ms

Latency Count
7.48    3
7.56    2
7.65    2
7.73    2
7.82    7
7.90    4
7.98    4
8.07    6
8.15    9
8.24    9
8.32    11
8.40    7
8.49    11
8.57    12
8.66    3
8.74    2
8.82    2
8.91    1
8.99    2
9.08    1
```
## TCPING

The tcping utility is similar to ping except that it operates over a TCP connection instead of ICMP, which Load Balancer doesn't route. Use tcping as follows:

```CMD
tcping <ip address> <port>
```

Typical output looks like this:

```text
Probing nn.nn.nn.nn:nn/tcp - Port is open - time=9.042ms
Probing nn.nn.nn.nn:nn/tcp - Port is open - time=9.810ms
Probing nn.nn.nn.nn:nn/tcp - Port is open - time=9.266ms
Probing nn.nn.nn.nn:nn/tcp - Port is open - time=9.181ms

Ping statistics for nn.nn.nn.nn:nn
     4 probes sent.
     4 successful, 0 failed.  (0.00% fail)
Approximate trip times in milli-seconds:
     Minimum = 9.042ms, Maximum = 9.810ms, Average = 9.325ms
```

https://docs.microsoft.com/en-us/powershell/module/nettcpip/test-netconnection?view=win10-ps

