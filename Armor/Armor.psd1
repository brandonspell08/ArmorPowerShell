#
# Module manifest for module 'Armor'
#
# Generated by: Troy Lindsay
#
# Generated on: 10/22/2017
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'Armor.psm1'

# Version number of this module.
ModuleVersion = '1.0.0.27'

# ID used to uniquely identify this module
GUID = '226c1ea9-1078-402a-861c-10a845a0d173'

# Author of this module
Author = 'Troy Lindsay'

# Company or vendor of this module
CompanyName = 'Armor'

# Copyright statement for this module
Copyright = '(c) 2017 Troy Lindsay. All rights reserved.'

# Description of the functionality provided by this module
Description = 'This is a community project that provides a Microsoft PowerShell module for managing and monitoring your Armor Complete and Anywhere environments.'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.0'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
ProcessorArchitecture = 'None'

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module
FunctionsToExport = 'Connect-Armor', 'Disconnect-Armor', 'Get-ArmorAccount', 
               'Get-ArmorLocation', 'Get-ArmorUser', 'Get-ArmorVm', 'Rename-ArmorVM', 
               'Reset-ArmorVM', 'Restart-ArmorVM', 'Set-ArmorAccountContext', 
               'Start-ArmorVM', 'Stop-ArmorVM'

# Cmdlets to export from this module
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = 'global:ArmorConnection'

# Aliases to export from this module
AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
FileList = 'Armor.psd1', 'Armor.psm1', 'ConvertFrom-JsonXL.ps1', 
               'Expand-ArmorApiResult.ps1', 'Expand-JsonItem.ps1', 
               'Format-ArmorApiJsonRequestBody.ps1', 'Get-ArmorApiData.ps1', 
               'New-ArmorApiToken.ps1', 'New-ArmorApiUriQueryString.ps1', 
               'New-ArmorApiUriString.ps1', 'Select-ArmorApiResult.ps1', 
               'Submit-ArmorApiRequest.ps1', 'Test-ArmorConnection.ps1', 
               'Update-ArmorApiToken.ps1', 'Connect-Armor.ps1', 
               'Disconnect-Armor.ps1', 'Get-ArmorAccount.ps1', 
               'Get-ArmorLocation.ps1', 'Get-ArmorUser.ps1', 'Get-ArmorVm.ps1', 
               'Rename-ArmorVM.ps1', 'Reset-ArmorVM.ps1', 'Restart-ArmorVM.ps1', 
               'Set-ArmorAccountContext.ps1', 'Start-ArmorVM.ps1', 
               'Stop-ArmorVM.ps1'

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = 'Armor','Defense','Cloud','Security','Performance','Complete','Anywhere','Compliant','PCI-DSS','HIPAA','IaaS','SaaS'

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/tlindsay42/ArmorPowerShell/blob/master/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/tlindsay42/ArmorPowerShell'

        # A URL to an icon representing this module.
        IconUri = 'http://i.imgur.com/fbXjkCn.png'

        # ReleaseNotes of this module
        # ReleaseNotes = ''

        # External dependent modules of this module
        # ExternalModuleDependencies = ''

    } # End of PSData hashtable
    
 } # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

