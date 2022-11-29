#SCRIPTNAME: Hunt Mailexfil with permission settings

#Target: setzen von Berechtingsänderungen
#Cloud Service: Exchange Online
#Risiko: unbemerktes berechtigen von mailboxen
#Quelle: SANS DFIR SUMMIT 2022

#CONFIG: Berechtigung Full Access setzen
Add-MailboxPermission -Identity victim -User Attacker -AccessRights FullAccess

#CONFIG: Berechtigung SendAs setzen
Add-recipientPermission -AccessRights SendAs -Trustee Attacker -Identity victim

#REPORT: Alle Mailboxen mit Fullaccess
Get-Mailbox -Resultsize Unlimited | Get-MailboxPermission | Where-Object {
    ($_.Accessrights -like "FullAccess")}

#REPORT: Alle Mailboxen mit SendAs
Get-Mailbox -Resultsize Unlimited | Get-RecipientPermission | where-Object { ($_.Accessrights -like "SendAs")}


#DETECT: Admin Audit Logs
Search-AdminAuditLog -Cmdlets Add-MailboxPermission -Parameters AccessRights

#DETECT: Admin Audit Logs
Search-AdminAuditLog -Cmdlets Add-RecipientPermission -Parameters AccessRights

#DETECT: Unified Audit Logs Full Access
$logs = Search-UnifiedAuditLog -operations add-mailboxpermission -StartDate 2022-01-01 -EndDate 2022-07-08
ForEach ($record in $logs){
$AuditData = $record.AuditData | ConvertFrom-Json
if ( $AuditData.Parameters | Where-Object {($_.Value -eq 'FullAccess')})
{$record}}

#DETECT: Unified audit Logs SendAs
$logs = Search-UnifiedAuditLog -operations Add-RecipientPermission -StartDate 2022-01-01 -EndDate 2022-
07-20
ForEach ($record in $logs){
$AuditData = $record.AuditData | ConvertFrom-Json
if ( $AuditData.Parameters | Where-Object {($_.Value -eq 'SendAs')})
{$record}}

#WE>>MER