if (!(Get-PSSnapin -Name VMware.VimAutomation.Core -ErrorAction SilentlyContinue))
{
            Add-PSSnapin VMware.VimAutomation.Core
}

Connect-VIServer -Server SERVER -User USER -Password PASSWORD

$DiskList = @(Get-VM | Get-Harddisk | Where {$_.Persistence -notContains "Persistent"}).count

if ($DiskList -gt 0){
Get-VM | where {$_.powerstate -eq "PoweredOn"} | Get-Harddisk  | Where {$_.Persistence -notContains "Persistent"} | Select Parent, Persistence, Name, Filename | Sort-Object Parent
} 
