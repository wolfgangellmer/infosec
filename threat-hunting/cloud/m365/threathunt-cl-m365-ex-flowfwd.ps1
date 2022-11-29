#SCRIPTNAME: Hunt Mailforward with flow

#Target: automation setzen mit flow
#Cloud Service: Exchange Online Microsoft flow
#Risiko: unbemerktes weiterleiten von Daten
#Quelle: SANS DFIR SUMMIT 2022

#CONFIG: Flow einrichten gui


#REPORT: Alle Mailboxen mit und anonyme zugriffe anzeigen


#DETECT: Unified audit Logs flow Created
Search-UnifiedAuditLog -operations createflow -startdate 2022-01-01 -enddate 2022-06-30

#DETECT: Unified audit operation send
Search-UnifiedAuditLog -operations Send -startdate 2022-01-01 -enddate 2022-06-30

#DETECT: Unified audit Log alle flows anzeigen
$flowCollection = @()
Connect-MsolService
$users = Get-MsolUser -All | Select-Object UserPrincipalName, ObjectId
$flows = get-AdminFlow
foreach($flow in $flows){
$flowProperties = $flow.internal.properties
$Creator = $users | where-object{$_.ObjectId -eq $flowProperties.creator.UserID}
$triggers = $flowProperties.definitionsummary.triggers
$actions = $flowProperties.definitionsummary.actions | where-object {$_.swaggerOperationId}
[datetime]$modifiedTime = $flow.LastModifiedTime
[datetime]$createdTime = $flowProperties.createdTime
$flowCollection += new-object psobject -property @{displayName= $flowProperties.displayName;environment = $flowProperties.Environment.name;State = $flowProperties.State;Triggers = $triggers.swaggerOperationId;Actions = $actions.swaggerOperationId;Created = $createdTime.ToString("dd-MM-yyyy HH:mm:ss");Modified = $modifiedTime.ToString("dd-MMyyyyHH:mm:ss");CreatedBy = $Creator.userPrincipalName
}
$flowCollection
}

#WE>>MER