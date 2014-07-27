if (!(Get-PSSnapin -Name VMware.VimAutomation.Core -ErrorAction SilentlyContinue))
{
            Add-PSSnapin VMware.VimAutomation.Core
}

Connect-VIServer -Server SERVER -User USER -Password PASSWORD

Get-Datacenter | Get-Datastore |  where {$_.Name -match "SAN"} | Select Name, Datacenter, 
    @{N="Capacity Gb";E={[Math]::Round($_.CapacityGB)}}, 
    @{N="FreeSpace Gb";E={[Math]::Round($_.FreespaceGB)}},     @{N="FreeSpace %";E={[Math]::Round(($_.FreespaceGB / $_.CapacityGB) * 100)}},
    @{N="Provisioned %";E={[Math]::Round(((($_.CapacityGB - $_.FreespaceGB +($_.extensiondata.summary.uncommitted/1GB))/$_.CapacityGB))*100)}} | Sort-Object Name 