function Read-TokenScope {
	<#
	.SYNOPSIS
		Reads the scopes of the JWT token provided.
	
	.DESCRIPTION
		Reads the scopes of the JWT token provided.
		Use this to verify, whether a connecting user has the scopes required.
	
	.PARAMETER Token
		The JWT token to parse
	
	.PARAMETER Trigger
		The trigger object provided by an Azure Function Endpoint
	
	.EXAMPLE
		PS C:\> Read-TokenScope -Trigger $TriggerMetadata
		
		Returns the scopes of the user triggering the Azure Function App
	#>
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true, ParameterSetName = 'Token')]
        [string]
        $Token,

        [Parameter(Mandatory=$true, ParameterSetName = 'Trigger')]
        $Trigger
    )

    if ($Trigger) {
        $Token = $Trigger.Headers.Authorization -replace "^Bearer "
    }

    $tokenPayload = $Token.Split(".")[1].Replace('-', '+').Replace('_', '/')
    # Pad with "=" until string length modulus 4 reaches 0
    while ($tokenPayload.Length % 4) { $tokenPayload += "=" }
    $bytes = [System.Convert]::FromBase64String($tokenPayload)
    ([System.Text.Encoding]::ASCII.GetString($bytes) | ConvertFrom-Json).roles
}