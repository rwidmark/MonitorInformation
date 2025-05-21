
NAME
    Get-RSMonitorInformation
    
SYNOPSIS
    Returns information about all the monitors that has been connected to the computer
    
    
SYNTAX
    Get-RSMonitorInformation [[-ComputerName] <String[]>] [<CommonParameters>]
    
    
DESCRIPTION
    With this script you can get information about all of the monitors that has been connected to a local or remote computer.
    You can also run this against multiple remote computers at the same time.
    

PARAMETERS
    -ComputerName <String[]>
        If you want to run this against a remote computer you specify which computer with this parameter.
        You can add multiple computers like this: -ComputerName "Win11-Test", "Win10"
        
        Required?                    false
        Position?                    1
        Default value                localhost
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
    
    PS > Get-RSMonitorInformation
    # Returns information about the monitors on the local computer
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS > Get-RSMonitorInformation -ComputerName "Win11"
    # Return information about the monitor on a remote computer named "Win11"
    
    
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS > Get-RSMonitorInformation -ComputerName "Win10", "Win11"
    # Return information about the monitor from both remote computer named Win10 and Win11
    
    
    
    
    
    
    
RELATED LINKS
    https://github.com/rwidmark/MonitorInformation/blob/main/README.md


