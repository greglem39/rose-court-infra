<powershell>
##variables
$ServerName = "${ServerName}"
$DomainName = "${DomainName}"
$SecureAdminSafeModePassword = ConvertTo-SecureString -String "${AdminSafeModePassword}" -AsPlainText -Force

Rename-Computer -NewName $ServerName

Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName $DomainName -InstallDNS -SafeModeAdministratorPassword $SecureAdminSafeModePassword
</powershell>
<persist>true</persist>