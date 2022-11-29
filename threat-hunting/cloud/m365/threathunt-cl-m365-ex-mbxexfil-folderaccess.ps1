#SCRIPTNAME: Hunt MailExfiltration from Folder Permission

#Target: setzen von folder permissions
#Cloud Service: Exchange Online
#Risiko: unbemerkter zugriff auf Emailordner
#Quelle: SANS DFIR SUMMIT 2022

#CONFIG: Einzelordner zugriff einrichten
Add-MailboxFolderPermission -Identity victim@threathunting.dev:\inbox -User Default -AccessRights owner

#REPORT: Alle Mailboxen mit und anonyme zugriffe anzeigen
Get-Mailbox | Get-MailboxFolderPermission | Where-Object {($_.user -like 'Anonymous') -or ($_.user -like 'Default') -and ($_.AccessRights -ne 'None') } | Format-List

#DETECT: Unified audit Logs Inbox
$mailboxes = Get-Mailbox -ResultSize Unlimited
ForEach ($record in $logs){
    $AuditData = $record.AuditData | ConvertFrom-Json
    if ( $AuditData.Parameters | Where-Object {($_.Value -like 'Anonymous') -or ($_.Value -eq 'Default') }) {$record}}

#DETECT: Unified audit Logs
$logs = Search-UnifiedAuditLog -operations add-MailboxFolderPermission,Set-MailboxFolderPermission -StartDate 2022-01-01 -EndDate 2022-07-08
ForEach ($record in $logs){
$AuditData = $record.AuditData | ConvertFrom-Json
if ( $AuditData.Parameters | Where-Object {($_.Value -like 'Anonymous') -or ($_.Value -eq'Default') }) {$record}
}

#WE>>MER