$LogNames = @(  
                #BSI EMPFEHLUNGEN
                "Microsoft-Windows-LSA/Operational", 
                "Microsoft-Windows-TerminalServices-RemoteConnectionManager/Operational", 
                "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational",
                "Microsoft-Windows-CAPI2/Operational",
                "Microsoft-Windows-CodeIntegrity/Operational",
                "Microsoft-Windows-GroupPolicy/Operational", 
                "Microsoft-Windows-Kernel-PnP/Configuration", 
                "Microsoft-Windows-TaskScheduler/Operational",
                "Microsoft-Windows-WMI-Activity/Operational", 
                "Microsoft-Windows-WinRM/Operational", 
                "Microsoft-Windows-Windows Firewall With Advanced Security/Firewall", 
                "Microsoft-Windows-Windows Firewall With Advanced Security/FirewallVerbose",
                "Microsoft-Windows-DNS-Client/Operational", 
                "Microsoft-Windows-SMBClient/Connectivity", 
                "Microsoft-Windows-SMBClient/Security", 
                "Microsoft-Windows-SMBClient/Operational", 
                "Microsoft-Windows-SMBServer/Operational", 
                "Microsoft-Windows-SMBServer/Security", 
                "Microsoft-Windows-PowerShell/Operational"                   
                #SOC input
                #medium value low volume
                "Microsoft-Windows-DriverFrameworks-UserMode/Operational"
                "Microsoft-Windows-Bits-Client/Operational"
                "Microsoft-Windows-Windows Defender/Operational"            
            )


$LogNames | Foreach-Object {

    C:\Windows\System32\wevtutil.exe set-log $_ /enabled:true
    C:\Windows\System32\wevtutil.exe set-log $_ /retention:false

    If ($_ -eq "Microsoft-Windows-PowerShell/Operational") {
        C:\Windows\System32\wevtutil.exe set-log $_ /maxsize:536870912        
    } elseif ($_ -eq "Microsoft-Windows-CAPI2/Operational") {
        C:\Windows\System32\wevtutil.exe set-log $_ /maxsize:201326592        
    } elseif ($_ -eq "Microsoft-Windows-DNS-Client/Operational") {
        C:\Windows\System32\wevtutil.exe set-log $_ /maxsize:201326592        
    } else {
        C:\Windows\System32\wevtutil.exe set-log $_ /maxsize:33554432
    }
    Get-WinEvent -ListLog $_ | Select MaximumSizeInBytes, FileSize, IsLogFul, LastAccessTime, LastWriteTime, OldestRecordNumber, RecordCount, LogName, LogType, LogIsolation, IsEnabled, LogMode |ft
    
}


