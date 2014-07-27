if (!(Get-PSSnapin -Name VMware.VimAutomation.Core -ErrorAction SilentlyContinue))
{
            Add-PSSnapin VMware.VimAutomation.Core
}

Connect-VIServer -Server SERVER -User USER -Password PASSWORD

Get-view -ViewType HostSystem | select Name,@{N="FullName";E={$_.Config.Product.FullName}},@{N="Build";E={$_.Config.Product.Build}}, OverallStatus, ConfigStatus | Sort-Object Name 

