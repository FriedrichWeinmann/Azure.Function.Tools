function Connect-ClientSecret {
	<#
		.SYNOPSIS
			Connects to AzureAD using a client secret.
		
		.DESCRIPTION
			Connects to AzureAD using a client secret.
		
		.PARAMETER ClientID
			The ID of the registered app used with this authentication request.
		
		.PARAMETER TenantID
			The ID of the tenant connected to with this authentication request.
		
		.PARAMETER ClientSecret
			The actual secret used for authenticating the request.

		.PARAMETER Resource
			The resource the token grants access to.
            
		.EXAMPLE
			PS C:\> Connect-ClientSecret -ClientID $clientID -TenantID $tenantID -ClientSecret $secret -Resource $apiID
		
			Connects to the specified tenant using the specified client and secret.
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[string]
		$ClientID,
			
		[Parameter(Mandatory = $true)]
		[string]
		$TenantID,
			
		[Parameter(Mandatory = $true)]
		[securestring]
		$ClientSecret,

		[Parameter(Mandatory = $true)]
		[string]
		$Resource
	)
		
	process {
		$body = @{
			client_id     = $ClientID
			client_secret = [PSCredential]::new('NoMatter', $ClientSecret).GetNetworkCredential().Password
			scope         = $Scopes -join " "
			grant_type    = 'client_credentials'
			resource      = $Resource
		}
		try { $authResponse = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$TenantId/oauth2/token" -Body $body -ErrorAction Stop }
		catch { $PSCmdlet.ThrowTerminatingError($_) }
		$authResponse
	}
}