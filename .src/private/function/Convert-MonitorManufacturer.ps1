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