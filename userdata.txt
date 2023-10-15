<powershell>
##variables
$ServerName = "${ServerName}"
$DomainName = "${DomainName}"
$DomainMode = "${DomainMode}"
$ForestMode = "${ForestMode}"
$DomainNetbiosName = $DomainName.Split(".") | Select -First 1
$SecureAdminSafeModePassword = ConvertTo-SecureString -String "${AdminSafeModePassword}" -AsPlainText -Force

Rename-Computer -NewName $ServerName

Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

Import-Module ADDSDeployment

Install-ADDSForest `
-confirm:$false `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode $DomainMode `
-DomainName $DomainName `
-DomainNetbiosName $DomainNetbiosName `
-ForestMode $ForestMode `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-SysvolPath "C:\Windows\SYSVOL" `
-SafeModeAdministratorPassword $SecureAdminSafeModePassword `
-NoRebootOnCompletion:$false `
-Force:$true
</powershell>
<persist>true</persist>