if (!(Get-PSSnapin -Name VMware.VimAutomation.Core -ErrorAction SilentlyContinue))
{
            Add-PSSnapin VMware.VimAutomation.Core
}

Connect-VIServer -Server SERVER -User USER -Password PASSWORD

$VM = Get-VM | where {$_.powerstate -eq "PoweredOn"} 
$VM | Select Name, NumCpu, MemoryMB, `
	@{N="CPU Maximum";E={[Math]::Round((($_ | Get-Stat -Stat Cpu.UsageMhz.Average -Start (Get-Date).AddDays(-30) -MaxSamples (30000) | Measure-Object Value -Average -Maximum).Maximum))}}, `
	@{N="Mem Maximum";E={[Math]::Round(((($_ | Get-Stat -Stat Mem.Consumed.Average -Start (Get-Date).AddDays(-30) -MaxSamples (30000) | Measure-Object Value -Average -Maximum).Maximum)/1024))}}, `
	@{N="CPU Average";E={[Math]::Round((($_ | Get-Stat -Stat Cpu.UsageMhz.Average -Start (Get-Date).AddDays(-30) -MaxSamples (30000) | Measure-Object Value -Average -Maximum).Average))}}, `
	@{N="Mem Average";E={[Math]::Round(((($_ | Get-Stat -Stat Mem.Consumed.Average -Start (Get-Date).AddDays(-30) -MaxSamples (30000) | Measure-Object Value -Average -Maximum).Average)/1024))}} `
	| Sort-Object Name

