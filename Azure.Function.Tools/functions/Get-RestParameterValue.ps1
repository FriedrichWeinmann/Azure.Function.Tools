function Get-RestParameterValue {
	<#
	.SYNOPSIS
		Extract the exact value of a parameter provided by the user.
	
	.DESCRIPTION
		Extract the exact value of a parameter provided by the user.
		Expects either query or body parameters from the rest call to the http trigger.
	
	.PARAMETER Request
		The request object provided as part of the function call.
	
	.PARAMETER Name
		The name of the parameter to provide.
	
	.EXAMPLE
		PS C:\> Get-RestParameterValue -Request $Request -Name Type

		Returns the value of the parameter "Type", as provided by the caller
	#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $Request,

        [Parameter(Mandatory = $true)]
        [string]
        $Name
    )

    if ($Request.Query.$Name) {
        return $Request.Query.$Name
    }
    $Request.Body.$Name
}