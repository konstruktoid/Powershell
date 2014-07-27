if (!(Get-PSSnapin -Name VMware.VimAutomation.Core -ErrorAction SilentlyContinue))
{
            Add-PSSnapin VMware.VimAutomation.Core
}

Connect-VIServer -Server SERVER -User USER -Password PASSWORD

Get-VM | % { get-view $_.ID } | Where {$_.guest.toolsstatus -notContains "toolsOk"}|
Select Name, @{ Name="hostName"; Expression={$_.guest.hostName}}, @{ Name="ToolsStatus"; Expression={$_.guest.toolsstatus}}, @{ Name="ToolsVersion"; Expression={$_.config.tools.toolsVersion}} | 
Sort-object Name 
