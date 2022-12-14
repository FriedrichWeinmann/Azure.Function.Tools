function Get-ConfigValue {
	<#
	.SYNOPSIS
		Returns a configured value.
	
	.DESCRIPTION
		Returns a configured value.
		Use Import-Config to define configuration values.
		Supports reading from environment variables, when both are specified, configuration wins.
		Will write warnings if no data found.
	
	.PARAMETER Name
		The name of the setting to retrieve.
	
	.EXAMPLE
		PS C:\> Get-COnfigValue -Name VaultName

		Returns the value configured for the "VaultName" setting
	#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string]
		$Name
	)

	$hasEnvironmentValue = Test-Path -Path "env:$Name"
	
	if (-not $Global:config -and -not $hasEnvironmentValue) {
		Write-Warning "[Get-ConfigValue] No configuration defined yet."
		return
	}

	if ($Global:config.Keys -notcontains $Name -and -not $hasEnvironmentValue) {
		Write-Warning "[Get-ConfigValue] Configuration entry not found: $Name"
		return
	}
	if ($Global:config.Keys -contains $Name) {
		$Global:config.$Name
	}
	else {
		(Get-Item -Path "env:$Name").Value
	}
}