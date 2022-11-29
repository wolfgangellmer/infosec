#SCRIPTNAME: Hunt sharepoinbt online external sahring

#Target: external sharing of data
#Cloud Service: Sharepoint Online
#Risiko: unbemerktes zugreifen auf Daten in der cloud
#Quelle: SANS DFIR SUMMIT 2022

#CONFIG: jeder user

#REPORT: extern shareing möglich
Get-SPOTenant | select-object SharingCapability


#DETECT: Unified audit Logs Extern shareing
$logs = Search-UnifiedAuditLog -recordtype Sharepoint -operations SharingPolicyChanged -startdate 2022-07-30 -
enddate 2022-08-01
ForEach ($record in $logs){
$AuditData = $record.AuditData | ConvertFrom-Json
if ( $AuditData.ModifiedProperties | Where-Object {($_.NewValue -eq 'ExtranetWithShareByLink')})
{$record}}

#DETECT: Unified audit Logs Extern shareing anonym mit link erstellt/aktualisiert
Search-UnifiedAuditLog -recordtype SharePointSharingOperation -operations 'anonymouslinkcreated,anonymouslinkupdated' -startdate 2022-07-30 -enddate 2022-08-01

#DETECT: Unified audit Logs Extern shareing anonym mit link verwendet
Search-UnifiedAuditLog -recordtype SharePointSharingOperation -operations 'AnonymousLinkUsed' -startdate 2022-07-30 -enddate 2022-08-01

#WE>>MER