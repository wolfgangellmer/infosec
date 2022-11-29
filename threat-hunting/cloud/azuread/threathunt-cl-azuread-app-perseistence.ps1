#SCRIPTNAME: Hunt Azuread MFA Bypass

#Target: Azuread Apps Service Principal & secrets
#Cloud Service: Exchange Online Microsoft flow
#Risiko: unbemerktes zugreifen auf Daten als Applikation
#Quelle: SANS DFIR SUMMIT 2022

#CONFIG: Add Secrets to App in AAD
Connect-AzureAD;
$startDate = Get-Date;
$endDate = $startDate.AddYears(3);
$aadAppsecret = New-AzureADApplicationPasswordCredential -ObjectId <ObjectId> -CustomKeyIdentifier Secret01 -StartDate $startDate -EndDate $endDate 
$aadAppsecret.Value= <ClearTextSecret>

#CONFIG: Add Secrets to Service Principal in AzureAD
Connect-AzAccount -Tenant <tenantID>
$newCredential = New-AzADSpCredential -ServicePrincipalName <ApplicationID>
$BSTR= [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($newcredential.Secret)
$ClearSecret ==[System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

#CONFIG: Threat actor access to tenant use sp and secret
$passwd = ConvertTo-SecureString -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential (<Appication ID>, $passwd)
Connect-AzAccount -ServicePrincipal -Credential $cred -Tenant <Tenant ID>

#REPORT: List all SPs with secret
$Spns = Get-AzureADServicePrincipal -All $true
foreach ($Spn in $Spns) {
if ($Spn.PasswordCredentials.Count -ne 0 -or $Spn.KeyCredentials.Count -ne 0) {
Write-Host 'Application Display Name::'$Spn.DisplayName
Write-Host 'Application Password Count::' $Spn.PasswordCredentials.Count
Write-Host 'Application Key Count::' $Spn.KeyCredentials.Count
Write-Host ''
} }

#REPORT: List all Apps with secret
$Apps = Get-AzureAD Application -All $True
foreach ($App in $Apps) {
if ($App.PasswordCredentials.Count -ne 0 -or $App.KeyCredentials.Count -ne 0)
{
Write-Host 'Application Display Name::'$App.DisplayName
Write-Host 'Application Password Count::'
$App.PasswordCredentials.Count
Write-Host 'Application Key Count::' $App.KeyCredentials.Count
Write-Host ''
} }

#DETECT: Unified audit Logs Secret assignment
Search-UnifiedAuditLog -operations 'Update application – Certificates and secrets management' -startdate 2022-06-24 -enddate 2022-06-26

#WE>>MER