if (!(Get-PSSnapin -Name VMware.VimAutomation.Core -ErrorAction SilentlyContinue))
{
            Add-PSSnapin VMware.VimAutomation.Core
}

Connect-VIServer -Server SERVER -User USER -Password PASSWORD

$SnapList = @(Get-VM | Get-Snapshot | Where {$_.Created -lt (Get-Date).AddDays(-7)}).count

if ($SnapList -gt 0){
$VM = Get-VM
$VM | Get-Snapshot | Where {$_.Created -lt (Get-Date).AddDays(-7)} | Select VM, Created, @{N="SizeGB";E={[math]::round($_.SizeGB, 1)}}, Name | Sort-Object Created 
} 