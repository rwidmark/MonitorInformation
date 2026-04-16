<#
MIT License

Copyright (C) 2025 Robin Widmark.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
#>
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
                Test-WSMan -ComputerName $Computer -ErrorAction Stop | Out-Null
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
                    $ManufacturerName = $DisplayPnPInfo.MonitorManufacturer
                    if ([String]::IsNullOrWhiteSpace($ManufacturerName)) {
                        $ManufacturerName = Convert-MonitorManufacturer -Manufacturer $ManufacturerCode
                    }

                    [PSCustomObject]@{
                        Active                = $MonInfo.Active
                        Status                = $DisplayPnPInfo.Status
                        Availability          = $DisplayPnPInfo.Availability
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
Function Convert-MonitorManufacturer {
    <#
        .SYNOPSIS
        This should only be used by Get-RSMonitorInformation

        .DESCRIPTION
        Will translate the 3 letter code to the full name of the manufacturer, this should only be used by Get-RSMonitorInformation.

        .PARAMETER Manufacturer
        Enter the 3 letter manufacturer code.

        .EXAMPLE
        Convert-MonitorManufacturer -Manufacturer "PHL"
        # Return the translation of the 3 letter code to the full name of the manufacturer, in this example it will return Philips

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

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Enter the 3 letter manufacturer code")]
        [String]$Manufacturer
    )

    begin {
        $ManufacturerMap = @{
            ACI = "Asus"
            ACR = "Acer"
            ACT = "Targa"
            ADI = "ADI Corporation"
            AMW = "AMW"
            AOC = "AOC"
            API = "Acer"
            APP = "Apple"
            ART = "ArtMedia"
            AST = "AST Research"
            AUO = "AU Optronics"
            BMM = "BMM"
            BNQ = "BenQ"
            BOE = "BOE Display Technology"
            CPL = "Compal"
            CPQ = "COMPAQ"
            CTX = "Chuntex"
            DEC = "Digital Equipment Corporation"
            DEL = "Dell"
            DPC = "Delta"
            DWE = "Daewoo"
            ECS = "ELITEGROUP"
            EIZ = "EIZO"
            EPI = "Envision"
            FCM = "Funai"
            FUS = "Fujitsu Siemens"
            GSM = "LG (GoldStar)"
            GWY = "Gateway"
            HEI = "Hyundai Electronics"
            HIQ = "Hyundai ImageQuest"
            HIT = "Hitachi"
            HSD = "Hannspree"
            HSL = "Hansol"
            HTC = "Hitachi / Nissei Sangyo"
            HWP = "Hewlett Packard (HP)"
            HPN = "Hewlett Packard (HP)"
            IBM = "IBM"
            ICL = "Fujitsu"
            IFS = "InFocus"
            IQT = "Hyundai"
            IVM = "Idek Iiyama"
            KDS = "KDS"
            KFC = "KFC Computek"
            LEN = "Lenovo"
            LGD = "LG"
            LKM = "ADLAS / AZALEA"
            LNK = "LINK"
            LPL = "LG Philips"
            LTN = "Lite-On"
            MAG = "MAG InnoVision"
            MAX = "Maxdata"
            MEI = "Panasonic"
            MEL = "Mitsubishi"
            MIR = "miro"
            MTC = "MITAC"
            NAN = "NANAO"
            NEC = "NEC"
            NOK = "Nokia"
            NVD = "Nvidia"
            OQI = "OPTIQUEST"
            PBN = "Packard Bell"
            PCK = "Daewoo"
            PDC = "Polaroid"
            PGS = "Princeton Graphic Systems"
            PHL = "Philips"
            PRT = "Princeton"
            REL = "Relisys"
            SAM = "Samsung"
            SEC = "Seiko Epson"
            SMC = "Samtron"
            SMI = "Smile"
            SNI = "Siemens"
            SNY = "Sony"
            SPT = "Sceptre"
            SRC = "Shamrock"
            STN = "Samtron"
            STP = "Sceptre"
            TAT = "Tatung"
            TRL = "Royal"
            TSB = "Toshiba"
            UNM = "Unisys"
            VSC = "ViewSonic"
            WTC = "Wen"
            ZCM = "Zenith"
        }
    }

    process {
        try {
            $NormalizedManufacturer = if ($null -eq $Manufacturer) {
                [String]::Empty
            }
            else {
                $Manufacturer.Trim().ToUpperInvariant()
            }

            if ($ManufacturerMap.ContainsKey($NormalizedManufacturer)) {
                $ManufacturerMap[$NormalizedManufacturer]
            }
            else {
                $NormalizedManufacturer
            }
        }
        catch {
            Write-Error -Message "Failed to resolve monitor manufacturer '$Manufacturer'. $($PSItem.Exception.Message)"
        }
    }

    end {
    }
}
