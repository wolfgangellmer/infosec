#SCRIPTNAME: Hunt Application permissions / impersonation

#Target: Application level permission
#Cloud Service: Exchange Online Microsoft flow
#Risiko: unbemerktes zugreifen auf Daten als Applikation
#Quelle: SANS DFIR SUMMIT 2022

#CONFIG: neue applikationsrolle
New-ManagementRoleAssignment –Name:impersonationAssignment –Role:ApplicationImpersonation –User:Attacker

#REPORT: Rollen anzeigen
$AppImperGroups = Get-RoleGroup | Where-Object Roles -like ApplicationImpersonation
ForEach ($Group in $AppImperGroups){ Get-RoleGroupMember $Group.Name }

#REPORT: Rollen anzeigen
Get-ManagementRoleAssignment -Role ApplicationImpersonation

#DETECT: Unified audit Logs
$logs = Search-UnifiedAuditLog -operations 'New-RoleGroup, New-ManagementRoleAssignment,set-
ManagementRoleAssignment' -StartDate 2022-01-01 -EndDate 2022-07-08
ForEach ($record in $logs){
$AuditData = $record.AuditData | ConvertFrom-Json
if ( $AuditData.Parameters | Where-Object {($_.Value -like 'ApplicationImpersonation')})
{$record}}

#WE>>MER