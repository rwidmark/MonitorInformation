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
        [Parameter(Mandatory = $true, HelpMessage = "Enter the 3 letter manufacturer code")]
        [String]$Manufacturer
    )

    Switch ($Manufacturer) {
        ACI {
            return "Asus"
        }
        ACR {
            return "Acer"
        }
        ACT {
            return "Targa"
        }
        ADI {
            return "ADI Corporation"
        }
        AMW {
            return "AMW"
        }
        AOC {
            return "AOC"
        }
        API {
            return "Acer"
        }
        APP {
            return "Apple"
        }
        ART {
            return "ArtMedia"
        }
        AST {
            return "AST Research"
        }
        AUO {
            return "AU Optronics"
        }
        BMM {
            return "BMM"
        }
        BNQ {
            return "BenQ"
        }
        BOE {
            return "BOE Display Technology"
        }
        CPL {
            return "Compal"
        }
        CPQ {
            return "COMPAQ"
        }
        CTX {
            return "Chuntex"
        }
        DEC {
            return "Digital Equipment Corporation"
        }
        DEL {
            return "Dell"
        }
        DPC {
            return "Delta"
        }
        DWE {
            return "Daewoo"
        }
        ECS {
            return "ELITEGROUP"
        }
        EIZ {
            return "EIZO"
        }
        EPI {
            return "Envision"
        }
        FCM {
            return "Funai"
        }
        FUS {
            return "Fujitsu Siemens"
        }
        GSM {
            return "LG (GoldStar)"
        }
        GWY {
            return "Gateway"
        }
        HEI {
            return "Hyundai Electronics"
        }
        HIQ {
            return "Hyundai ImageQuest"
        }
        HIT {
            return "Hitachi"
        }
        HSD {
            return "Hannspree"
        }
        HSL {
            return "Hansol"
        }
        HTC {
            return "Hitachi / Nissei Sangyo"
        }
        HWP {
            return "Hewlett Packard (HP)"
        }
        HPN {
            return "Hewlett Packard (HP)"
        }
        IBM {
            return "IBM"
        }
        ICL {
            return "Fujitsu"
        }
        IFS {
            return "InFocus"
        }
        IQT {
            return "Hyundai"
        }
        IVM {
            return "Idek Iiyama"
        }
        KDS {
            return "KDS"
        }
        KFC {
            return "KFC Computek"
        }
        LEN {
            return "Lenovo"
        }
        LGD {
            return "LG"
        }
        LKM {
            return "ADLAS / AZALEA"
        }
        LNK {
            return "LINK"
        }
        LPL {
            return "LG Philips"
        }
        LTN {
            return "Lite-On"
        }
        MAG {
            return "MAG InnoVision"
        }
        MAX {
            return "Maxdata"
        }
        MEI {
            return "Panasonic"
        }
        MEL {
            return "Mitsubishi"
        }
        MIR {
            return "miro"
        }
        MTC {
            return "MITAC"
        }
        NAN {
            return "NANAO"
        }
        NEC {
            return "NEC"
        }
        NOK {
            return "Nokia"
        }
        NVD {
            return "Nvidia"
        }
        OQI {
            return "OPTIQUEST"
        }
        PBN {
            return "Packard Bell"
        }
        PCK {
            return "Daewoo"
        }
        PDC {
            return "Polaroid"
        }
        PGS {
            return "Princeton Graphic Systems"
        }
        PHL {
            return "Philips"
        }
        PRT {
            return "Princeton"
        }
        REL {
            return "Relisys"
        }
        SAM {
            return "Samsung"
        }
        SEC {
            return "Seiko Epson"
        }
        SMC {
            return "Samtron"
        }
        SMI {
            return "Smile"
        }
        SNI {
            return "Siemens"
        }
        SNY {
            return "Sony"
        }
        SPT {
            return "Sceptre"
        }
        SRC {
            return "Shamrock"
        }
        STN {
            return "Samtron"
        }
        STP {
            return "Sceptre"
        }
        TAT {
            return "Tatung"
        }
        TRL {
            return "Royal"
        }
        TSB {
            return "Toshiba"
        }
        UNM {
            return "Unisys"
        }
        VSC {
            return "ViewSonic"
        }
        WTC {
            return "Wen"
        }
        ZCM {
            return "Zenith"
        }
        default {
            return $Manufacturer
        }
    }
}
