if (!(Get-PSSnapin -Name VMware.VimAutomation.Core -ErrorAction SilentlyContinue))
{
            Add-PSSnapin VMware.VimAutomation.Core
}

Connect-VIServer -Server SERVER -User USER -Password PASSWORD

Get-VM |  where {$_.Guest.OSFullName -match "Linux" -and $_.powerstate -eq "PoweredOn"} | Select Name, VMHost, Version, Description | Sort-Object Name