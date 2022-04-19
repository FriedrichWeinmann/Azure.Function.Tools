function Write-FunctionResult {
	<#
	.SYNOPSIS
		Reports back the output / result of the function app.
	
	.DESCRIPTION
		Reports back the output / result of the function app.
	
	.PARAMETER Status
		Whether the function succeeded or not.
	
	.PARAMETER Body
		Any data to include in the response.
	
	.EXAMPLE
		PS C:\> Write-FunctionResult -Status OK -Body $newUser

		Reports success while returning the content of $newUser as output
	#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Net.HttpStatusCode]
        $Status,

		[AllowNull()]
        $Body
    )

    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
            StatusCode = $Status
            Body       = $Body
        })
}