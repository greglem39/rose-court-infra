<powershell>
##variables
$ServerName = "${ServerName}"
$DomainName = "${DomainName}"
$DomainMode = "${DomainMode}"
$ForestMode = "${ForestMode}"
$DomainNetbiosName = $DomainName.Split(".") | Select -First 1
$SecureAdminSafeModePassword = ConvertTo-SecureString -String "${AdminSafeModePassword}" -AsPlainText -Force
$Name = "${UserName}"
$GivenName = "${GivenName}"
$SurName = "${SurName}"
$SamAccountName = "${SamAccountName}"
$DisplayName = "${DisplayName}"
$AccountPassword = ConvertTo-SecureString -String "${AccountPassword}" -AsPlainText -Force 

Rename-Computer -NewName $ServerName -Force

Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

Import-Module ADDSDeployment
Import-Module ActiveDirectory

Install-ADDSForest -confirm:$false -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode $DomainMode -DomainName $DomainName -DomainNetbiosName $DomainNetbiosName -ForestMode $ForestMode -InstallDns:$true -LogPath "C:\Windows\NTDS" -SysvolPath "C:\Windows\SYSVOL" -NoRebootOnCompletion:$false -Force:$true -SafeModeAdministratorPassword $SecureAdminSafeModePassword

#create nicodiangelo user
# https://adamtheautomator.com/new-aduser/

New-ADUser `
    -Name $Name `
    -GivenName $GivenName `
    -Surname $SurName `
    -SamAccountName $SamAccountName `
    -AccountPassword $AccountPassword `
    -ChangePasswordAtLogon $False `
    -DisplayName $DisplayName `
    -Enabled $True

# add to group
# https://community.spiceworks.com/how_to/50409-add-ad-user-to-groups-with-powershell
Add-ADGroupMember -Identity "Administrators" -Members $SamAccountName
Add-LocalGroupMember -Group “Remote Desktop Users” -Members $SamAccountName
</powershell>