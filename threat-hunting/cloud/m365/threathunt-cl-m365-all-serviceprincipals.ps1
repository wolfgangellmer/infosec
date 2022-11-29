#SCRIPTNAME: Hunt sonsent grants application/delegated/effective permission

#Target: permission thru grants
#Cloud Service: Exchange Online Microsoft flow
#Risiko: unbemerktes zugreifen durch zustimmen von externen apps
#Quelle: SANS DFIR SUMMIT 2022

#CONFIG: gui zustimmung externe app


#REPORT: Rollen anzeigen
Get-AzureADServicePrincipal | ForEach-Object{
    $spn = $_;
    $objID = $spn.ObjectID;
    $grants = Get-AzureADServicePrincipalOAuth2PermissionGrant -ObjectId
    $objID;
    foreach ($grant in $grants)
    {
    $user = Get-AzureADUser -ObjectId $grant.PrincipalId;
    $OAuthGrant = New-Object PSObject;
    $OAuthGrant | Add-Member Noteproperty 'ObjectID' $grant.objectId;
    $OAuthGrant | Add-Member Noteproperty 'User' $user.UserPrincipalName;
    $OAuthGrant | Add-Member Noteproperty 'AppDisplayName'
    $spn.DisplayName;
    $OAuthGrant | Add-Member Noteproperty 'AppPublisherName'
    $spn.PublisherName;
    $OAuthGrant | Add-Member Noteproperty 'AppReplyURLs' $spn.ReplyUrls;
    $OAuthGrant | Add-Member Noteproperty 'GrantConsentType'
    $grant.consentType;
    $OAuthGrant | Add-Member Noteproperty 'GrantScopes' $grant.scope;
    }
    Write-Output $OAuthGrant
    }


#DETECT: Unified audit Logs Consent App
Search-UnifiedAuditLog -operations 'Consent to application' -startdate 2022-05-18 -enddate 2022-05-20

#DETECT: Unified audit Logs delegated permission
Search-UnifiedAuditLog -operations 'Add delegated permission grant' -startdate 2022-03-19 -enddate 2022-05-21

#DETECT: Unified audit Logs add service principal
Search-UnifiedAuditLog -operations 'Add Service principal' -startdate 2022-03-19 -enddate 2022-05-21

#DETECT: Unified audit Logs add role assignment to service principal
Search-UnifiedAuditLog -operations 'Add app role assignment to service principal' -startdate 2022-03-19 -enddate 2022-07-31

#WE>>MER