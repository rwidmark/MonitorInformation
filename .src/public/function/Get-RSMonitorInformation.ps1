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
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Enter computer or computernames that you want to run this against")]
        [Alias('computer', 'name')]
        [String[]]$ComputerName = "localhost"
    )

    begin {
        $MonitorIdNamespace = 'root\wmi'
        $ConvertCharacterCodeArrayToString = {
            Param(
                [UInt16[]]$Value
            )

            if ($null -eq $Value) {
                return [String]::Empty
            }

            $StringBuilder = New-Object System.Text.StringBuilder
            foreach ($CharacterCode in $Value) {
                if ($CharacterCode -eq 0) {
                    continue
                }

                [void]$StringBuilder.Append([char]$CharacterCode)
            }

            return $StringBuilder.ToString().Trim()
        }
    }

    process {
        foreach ($Computer in $ComputerName) {
            if ([String]::IsNullOrWhiteSpace($Computer)) {
                continue
            }

            try {
                [void](Test-WSMan -ComputerName $Computer -ErrorAction Stop)
            }
            catch {
                Write-Warning "$Computer is not connected to the network or there are issues with WinRM"
                continue
            }

            $CimSession = $null

            try {
                Write-Output "`n=== Monitor information from $Computer ===`n"
                $CimSession = New-CimSession -ComputerName $Computer -ErrorAction Stop

                $PnPInfoByDeviceId = @{}
                foreach ($DisplayPnPInfo in @(Get-CimInstance -CimSession $CimSession -ClassName Win32_DesktopMonitor -ErrorAction Stop)) {
                    if (-not [String]::IsNullOrWhiteSpace($DisplayPnPInfo.PNPDeviceID)) {
                        $PnPInfoByDeviceId[$DisplayPnPInfo.PNPDeviceID] = $DisplayPnPInfo
                    }
                }

                foreach ($MonInfo in @(Get-CimInstance -CimSession $CimSession -ClassName WmiMonitorID -Namespace $MonitorIdNamespace -ErrorAction Stop)) {
                    $DisplayPnPInfo = $null
                    if (-not [String]::IsNullOrWhiteSpace($MonInfo.InstanceName)) {
                        $PnPDeviceId = $MonInfo.InstanceName -replace '_0$', ''
                        if ($PnPInfoByDeviceId.ContainsKey($PnPDeviceId)) {
                            $DisplayPnPInfo = $PnPInfoByDeviceId[$PnPDeviceId]
                        }
                    }

                    $ManufacturerCode = & $ConvertCharacterCodeArrayToString $MonInfo.ManufacturerName
                    $ManufacturerName = $null
                    if ($null -ne $DisplayPnPInfo) {
                        $ManufacturerName = $DisplayPnPInfo.MonitorManufacturer
                    }
                    if ([String]::IsNullOrWhiteSpace($ManufacturerName)) {
                        $ManufacturerName = Convert-MonitorManufacturer -Manufacturer $ManufacturerCode
                    }

                    $Status = $null
                    $Availability = $null
                    if ($null -ne $DisplayPnPInfo) {
                        $Status = $DisplayPnPInfo.Status
                        $Availability = $DisplayPnPInfo.Availability
                    }

                    [PSCustomObject]@{
                        Active                = $MonInfo.Active
                        Status                = $Status
                        Availability          = $Availability
                        'Manufacturer Name'   = $ManufacturerName
                        Model                 = & $ConvertCharacterCodeArrayToString $MonInfo.UserFriendlyName
                        'Serial Number'       = & $ConvertCharacterCodeArrayToString $MonInfo.SerialNumberID
                        'Year Of Manufacture' = $MonInfo.YearOfManufacture
                        'Week Of Manufacture' = $MonInfo.WeekOfManufacture
                    }
                }
            }
            catch {
                Write-Error -Message "Failed to retrieve monitor information from $Computer. $($PSItem.Exception.Message)"
            }
            finally {
                if ($null -ne $CimSession) {
                    Remove-CimSession -CimSession $CimSession -ErrorAction SilentlyContinue
                }
            }
        }
    }

    end {
    }
}
