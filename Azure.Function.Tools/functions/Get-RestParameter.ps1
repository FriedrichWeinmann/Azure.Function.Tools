function Get-RestParameter {
	<#
	.SYNOPSIS
		Parses the rest request parameters for all values matching parameters on the specified command.
	
	.DESCRIPTION
		Parses the rest request parameters for all values matching parameters on the specified command.
		Returns a hashtable ready for splatting.
		Does NOT assert mandatory parameters are specified, so command invocation may fail.
	
	.PARAMETER Request
		The original rest request object, containing the caller's information such as parameters.
	
	.PARAMETER Command
		The command to which to bind input parameters.
	
	.EXAMPLE
		PS C:\> Get-RestParameter -Request $Request -Command Get-AzUser

		Retrieves all parameters on the incoming request that match a parameter on Get-AzUser
	#>
	[OutputType([hashtable])]
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true)]
		$Request,

		[Parameter(Mandatory = $true)]
		[string]
		$Command
	)

	$commandInfo = Get-Command -Name $Command
	$results = @{ }
	foreach ($parameter in $commandInfo.Parameters.Keys) {
		$value = Get-RestParameterValue -Request $Request -Name $parameter
		if ($null -ne $value) { $results[$parameter] = $value }
	}
	$results
}