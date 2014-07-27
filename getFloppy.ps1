if (!(Get-PSSnapin -Name VMware.VimAutomation.Core -ErrorAction SilentlyContinue))
{
            Add-PSSnapin VMware.VimAutomation.Core
}

Connect-VIServer -Server SERVER -User USER -Password PASSWORD

Get-VM | Get-FloppyDrive | Where {$_.ConnectionState -Like "* StartConnected"} | Select Parent, Name
