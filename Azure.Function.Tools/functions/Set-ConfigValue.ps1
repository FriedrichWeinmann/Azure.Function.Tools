function Set-ConfigValue {
	<#
	.SYNOPSIS
		Set a config value.
	
	.DESCRIPTION
		Set a config value.
		Use Get-ConfigValue to later retrieve it.
	
	.PARAMETER Name
		Name of the setting to set
	
	.PARAMETER Value
		Value to set the setting to
	
	.EXAMPLE
		PS C:\> Set-ConfigValue -Name VaultName -Value myVault
	
		Set the config setting "VaultName" to the value "myVault"
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, Position = 0)]
		[string]
		$Name,
		[Parameter(Mandatory = $true, Position = 1)]
		$Value
	)

	if (-not $Global:config) {
		$Global:config = @{ }
	}
	$Global:config[$Name] = $Value
}