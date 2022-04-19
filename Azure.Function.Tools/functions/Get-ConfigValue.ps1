function Get-ConfigValue {
	<#
	.SYNOPSIS
		Returns a configured value.
	
	.DESCRIPTION
		Returns a configured value.
		Use Import-Config to define configuration values.
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

	if (-not $Global:config) {
		Write-Warning "[Get-ConfigValue] No configuration defined yet."
		return
	}

	if ($Global:config.Keys -notcontains $Name) {
		Write-Warning "[Get-ConfigValue] Configuration entry not found: $Name"
		return
	}
	$Global:config.$Name
}