if (!(Get-PSSnapin -Name VMware.VimAutomation.Core -ErrorAction SilentlyContinue))
{
            Add-PSSnapin VMware.VimAutomation.Core
}
Connect-VIServer -Server SERVER -User USER -Password PASSWORD

Get-VM  | where {$_.powerstate -eq "PoweredOff"} | Select Name, VMHost, PowerState, Version, Description | Sort-Object Name
