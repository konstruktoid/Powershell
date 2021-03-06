# http://www.powershelladmin.com/wiki/SSH_from_PowerShell_using_the_SSH.NET_library
# https://my.vmware.com/web/vmware/info/slug/datacenter_cloud_infrastructure/vmware_vsphere_with_operations_management/5_5#drivers_tools
# 
# adduser --no-create-home --shell /bin/bash RUSER     
# RUSER        ALL=NOPASSWD:/usr/bin/aptitude update, /usr/bin/aptitude -y upgrade
#
# We should be using authorized keys instead but these different PowerShell versions, modules, permissions and what not is as fun as the plague
# 

Import-Module SSH-Sessions

if (!(Get-PSSnapin -Name VMware.VimAutomation.Core -ErrorAction SilentlyContinue))
{
            Add-PSSnapin VMware.VimAutomation.Core
}

Connect-VIServer -Server SERVER -User USER -Password PASSWORD

$VMName = "VM01"
$Username = "RUSER" <# unprivileged user with specific sudo permissions #>
$Password = "RPASSWORD"

$RECV = "YOUR EMAIL <your.email@example.com>"
$Outputfile = ".\PoSHupdate.txt"
$SMTPserver = "smtp.example.com"

$VM = Get-VM $VMName
$IP = $VM.guest.IPAddress[0]
$Date = Get-Date -f yyMMddHHmm
$aptitude = 'echo -e $Password\n|sudo -S /usr/bin/aptitude update && echo -e $Password\n|sudo -S /usr/bin/aptitude -y upgrade'
$logger_start = 'logger -p user.info "`id -r` Aptitude PoSH update starting"'
$logger_end = 'logger -p user.info "`id -r` Aptitude PoSH update completed"'
$release = 'lsb_release -d|sed s/.*://'

New-Snapshot -VM $VM -Memory:$true -Name "Aptitude PoSH update" -Description "Aptitude PoSH update $Date"
New-SshSession -ComputerName $IP -Username $UserName -Password $Password
Invoke-SshCommand -InvokeOnAll -Command $logger_start -q
Invoke-SshCommand -InvokeOnAll -Command $aptitude -q
Invoke-SshCommand -InvokeOnAll -Command $logger_end -q
$VMRelease = Invoke-SshCommand -InvokeOnAll -Command $release -q

Remove-SshSession -RemoveAll

Set-VM -VM $VM -Description "$VMRelease - Patched $Date" -Confirm:$false

"Aptitude PoSH update completed" | Out-File $OutputFile
$VM | Select Name, Description, Host | Format-List | Out-File $OutputFile -Append
$VM | Get-Snapshot | Select Description, Created, IsCurrent | Format-List | Out-File $OutputFile -Append
$body= (Get-Content $OutputFile | Out-String )

Send-MailMessage -from $RECV -to $RECV -subject "Aptitude PoSH update $Date" -body $body -dno onSuccess, onFailure -smtpServer $SMTPserver
