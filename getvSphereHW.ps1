if (!(Get-PSSnapin -Name VMware.VimAutomation.Core -ErrorAction SilentlyContinue))
{
            Add-PSSnapin VMware.VimAutomation.Core
}

Connect-VIServer -Server SERVER -User USER -Password PASSWORD

Get-VMHost | Get-View | Select Name, Parent, 
@{N="Type";E={$_.Hardware.SystemInfo.Vendor+ " " + $_.Hardware.SystemInfo.Model}},
@{N="CPU";E={"PROC:" + $_.Hardware.CpuInfo.NumCpuPackages + " CORES:" + $_.Hardware.CpuInfo.NumCpuCores + " MHZ: " + [math]::round($_.Hardware.CpuInfo.Hz / 1000000, 0)}},
@{N="MEM";E={"" + [math]::round($_.Hardware.MemorySize / 1GB, 0) + " GB"}} | Sort-Object Name