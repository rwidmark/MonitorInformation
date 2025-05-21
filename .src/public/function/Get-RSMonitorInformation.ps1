Function Get-RSMonitorInformation {
    <#
        .SYNOPSIS
        Returns information about all the monitors that has been connected to the computer

        .DESCRIPTION
        With this script you can get information about all of the monitors that has been connected to a local or remote computer.
        You can also run this against multiple remote computers at the same time.

        .PARAMETER ComputerName
        If you want to run this against a remote computer you specify which computer with this parameter.
        You can add multiple computers like this: -ComputerName "Win11-Test", "Win10"

        .EXAMPLE
        Get-RSMonitorInformation
        # Returns information about the monitors on the local computer

        .EXAMPLE
        Get-RSMonitorInformation -ComputerName "Win11"
        # Return information about the monitor on a remote computer named "Win11"

        .EXAMPLE
        Get-RSMonitorInformation -ComputerName "Win10", "Win11"
        # Return information about the monitor from both remote computer named Win10 and Win11

        .LINK
        https://github.com/rwidmark/MonitorInformation/blob/main/README.md

        .NOTES
        Author:         Robin Widmark
        Mail:           robin@widmark.dev
        Website/Blog:   https://widmark.dev
        X:              https://x.com/widmark_robin
        Mastodon:       https://mastodon.social/@rwidmark
		YouTube:		https://www.youtube.com/@rwidmark
        Linkedin:       https://www.linkedin.com/in/rwidmark/
        GitHub:         https://github.com/rwidmark
    #>

    # PNPDeviceID maps with InstanceName.trim("_0")

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false, HelpMessage = "Enter computer or computernames that you want to run this against")]
        [Alias('computer', 'name')]
        [String[]]$ComputerName = "localhost"
    )

    foreach ($Computer in $ComputerName) {
        if (Test-WSMan -ComputerName $Computer -ErrorAction 'SilentlyContinue') {
            try {
                Write-Output "`n=== Monitor information from $Computer ===`n"
                $CimSession = New-CimSession -ComputerName $Computer
                $PnPInfo = Get-CimInstance -CimSession $CimSession -ClassName Win32_DesktopMonitor
                if ($null -ne $CimSession) {
                    foreach ($MonInfo in $( Get-CimInstance -CimSession $CimSession -ClassName WmiMonitorID -Namespace root\wmi )) {
                        $DisplayPnPInfo = $PnPInfo | Where-Object { $MonInfo.InstanceName.trim("_0") -eq $_.PNPDeviceID }
                        $GetManufacturer = $DisplayPnPInfo | Select-Object -ExpandProperty MonitorManufacturer
                        $GetManufacturer2 = Convert-MonitorManufacturer -Manufacturer $(($MonInfo.ManufacturerName | ForEach-Object { [char]$_ }) -join "")

                        [PSCustomObject]@{
                            Active                = $MonInfo.Active
                            Status                = $DisplayPnPInfo | Select-Object -ExpandProperty Status
                            Availability          = $DisplayPnPInfo | Select-Object -ExpandProperty Availability
                            'Manufacturer Name'   = if ($null -ne $GetManufacturer) { $GetManufacturer } else { $GetManufacturer2 }
                            Model                 = ($MonInfo.UserFriendlyName | ForEach-Object { [char]$_ }) -join ""
                            'Serial Number'       = ($MonInfo.SerialNumberID | ForEach-Object { [char]$_ }) -join ""
                            'Year Of Manufacture' = $MonInfo.YearOfManufacture
                            'Week Of Manufacture' = $MonInfo.WeekOfManufacture
                        }
                    }
                }
                Remove-CimSession -InstanceId $CimSession.InstanceId
            }
            catch {
                Write-Error $PSItem.Exception
                if ($ComputerName -ge 1) {
                    Continue
                }
                else {
                    break
                }
            }
        }
        else {
            Write-Output "$Computer are not connected to the network or it's trouble with WinRM"
        }
    }
}