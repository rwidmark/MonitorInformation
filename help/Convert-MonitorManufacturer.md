
NAME
    Convert-MonitorManufacturer
    
SYNOPSIS
    This should only be used by Get-RSMonitorInformation
    
    
SYNTAX
    Convert-MonitorManufacturer [-Manufacturer] <String> [<CommonParameters>]
    
    
DESCRIPTION
    Will translate the 3 letter code to the full name of the manufacturer, this should only be used by Get-RSMonitorInformation.
    

PARAMETERS
    -Manufacturer <String>
        Enter the 3 letter manufacturer code.
        
        Required?                    true
        Position?                    1
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
INPUTS
    
OUTPUTS
    
NOTES
    
    
        Author:         Robin Widmark
        Mail:           robin@widmark.dev
        Website/Blog:   https://widmark.dev
        X:              https://x.com/widmark_robin
        Mastodon:       https://mastodon.social/@rwidmark
		YouTube:		https://www.youtube.com/@rwidmark
        Linkedin:       https://www.linkedin.com/in/rwidmark/
        GitHub:         https://github.com/rwidmark
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > Convert-MonitorManufacturer -Manufacturer "PHL"
    # Return the translation of the 3 letter code to the full name of the manufacturer, in this example it will return Philips
    
    
    
    
    
    
    
RELATED LINKS
    https://github.com/rwidmark/MonitorInformation/blob/main/README.md


