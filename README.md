![GitHub](https://img.shields.io/github/license/rwidmark/MonitorInformation?style=plastic)  
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/rwidmark/MonitorInformation?sort=semver&style=plastic)  ![Last release](https://img.shields.io/github/release-date/rwidmark/MonitorInformation?style=plastic)
![GitHub last commit](https://img.shields.io/github/last-commit/rwidmark/MonitorInformation?style=plastic)  
![PSGallery downloads](https://img.shields.io/powershellgallery/dt/MonitorInformation?style=plastic)

# MonitorInformation 
This function will return information about monitors from local or remote computer.  
I have added the result from PSScriptAnalyzer in [test folder](https://github.com/rwidmark/MonitorInformation/tree/main/test) 

### This script will return the following information
- Is the monitor active? (connected)
- Status
- Availability
- Manufacturer Name
- Model
- Serial Number
- Year Of Manufacture
- Week Of Manufacture
- You run this on multiple computers at the same time to display the information.

If you use this function on a remote computer you need to make sure that you have [WinRM](https://github.com/rwidmark/Guides/blob/main/Windows/WinRM_GPO.md) activated.

# Links
* [My PowerShell Collection](https://github.com/rwidmark/PSCollection)
* [Webpage/Blog](https://widmark.dev)
* [X](https://twitter.com/widmark_robin)
* [Mastodon](https://mastodon.social/@rwidmark)
* [YouTube](https://www.youtube.com/@rwidmark)
* [LinkedIn](https://www.linkedin.com/in/rwidmark/)
* [GitHub](https://github.com/rwidmark)

# Help
Below I have specified things that I think will help people with this module.  
You can also see the API for each function in the [help folder](https://github.com/rwidmark/MonitorInformation/tree/main/help)

## Install
Install for current user
```
Install-Module -Name MonitorInformation -Scope CurrentUser -Force
```
  
Install for all users
```
Install-Module -Name MonitorInformation -Scope AllUsers -Force
```

## Example
```
Get-RSMonitorInformation
```
Returns information about monitors that are connected to the local computer.  

```
Get-RSMonitorInformation -ComputerName "Win11"
```
Returns information about monitors that are connected to the remote computer named "Win11".  

```
Get-RSMonitorInformation -ComputerName "Win10", "Win11"
```
Returns information about monitors that are connected to the remote computers named "Win10" and "Win11"  
  
It will return similar to this, but if you have more monitor then one you will see information listed from all of them.  
![Screenshot 2023-01-20 at 15 44 00](https://user-images.githubusercontent.com/76907327/213726484-869fb7aa-26cb-45c1-85e9-931ba98e79c7.png)
