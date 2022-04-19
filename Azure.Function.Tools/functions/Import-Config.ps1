function Import-Config {
	<#
	.SYNOPSIS
		Imports a set of data into a global config variable.
	
	.DESCRIPTION
		Imports a set of data into a global config variable.
		Used by other commands for default values.
		Use Get-ConfigValue to read config settings.

		Supports both Json and psd1 files, does not resolve any nesting of values.
	
	.PARAMETER Path
		Path to the config file to read
	
	.EXAMPLE
		PS C:\> Import-Config -Path "$PSScriptRoot\config.psd1"

		Loads the config.psd1 file from the folder of the calling file's.
	#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string]
		$Path
	)

	$configData = if ($Path -like "*.psd1") {
		Import-PowerShellDataFile -Path $Path
	}
	else {
		Get-Content -Path $Path | ConvertFrom-Json
	}

	if (-not $global:config) {
		$global:config = @{ }
	}

	if ($configData -is [Hashtable]) {
		foreach ($pair in $configData.GetEnumerator()) {
			$global:config[$pair.Key] = $pair.Value
		}
		return
	}

	foreach ($property in $configData.PSObject.Properties) {
		$global:config[$property.Name] = $property.Value
	}
}