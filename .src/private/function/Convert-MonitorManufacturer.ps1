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
        [AllowEmptyString()]
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
            if ([String]::IsNullOrWhiteSpace($Manufacturer)) {
                return [String]::Empty
            }

            $NormalizedManufacturer = $Manufacturer.Trim().ToUpperInvariant()

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
