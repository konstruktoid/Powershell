if (!(Get-PSSnapin -Name VMware.VimAutomation.Core -ErrorAction SilentlyContinue))
{
            Add-PSSnapin VMware.VimAutomation.Core
}

Connect-VIServer -Server  -User -Password 

$timeLimit = (Get-Date).AddDays(-30)
$VM = Get-VM  | where {$_.powerstate -ne "PoweredOn"}
foreach ($OffVM in ($VM)) {
	$datastores = Get-Datastore -VM $OffVM | where {$_.type -eq "vmfs"}
	foreach ($datastore in ($datastores)) {
		$lastWrite = (Get-ChildItem -Recurse -Path "vmstore:\" | Where {$_.Name -match "$VM.vmdk"}).LastWriteTime
			if ($lastWrite -lt $timeLimit) {
			 Get-ChildItem -Recurse -Path "vmstore:\" | Where {$_.Name -match "$VM.vmdk"} | select Name,DatastoreFullPath,LastWriteTime
			}
    }
}

Disconnect-VIServer -Server * -Force -Confirm:$false