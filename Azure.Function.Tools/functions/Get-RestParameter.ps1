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
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingEmptyCatchBlock", "")]
	[OutputType([hashtable])]
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true)]
		$Request,

		[Parameter(Mandatory = $true)]
		[string]
		$Command
	)

	begin {
		$newRequest = [PSCustomObject]@{
			Query = $Request.Query
			Body  = $Request.Body
		}
		if ($newRequest.Body -and $newRequest.Body -is [string]) {
			# Try json conversion
			try { $newRequest.Body = $newRequest.Body | ConvertFrom-Json -AsHashtable -ErrorAction Stop }
			catch {
				# Try HTML decoding
				try {
					$data = @{ }
					$newRequest.Body -split "&" | ForEach-Object { [System.Web.HttpUtility]::UrlDecode($_) } | ConvertFrom-StringData -ErrorAction Stop | ForEach-Object {
						$data += $_
					}
					$newRequest.Body = $data
				}
				catch { }
			}
		}
		if ($newRequest.Query -and $newRequest.Query -is [string]) {
			# Try Json conversion
			try { $newRequest.Query = $newRequest.Query | ConvertFrom-Json -AsHashtable -ErrorAction Stop }
			catch {
				# Try HTML decoding
				try {
					$data = @{ }
					$newRequest.Query -split "&" | ForEach-Object { [System.Web.HttpUtility]::UrlDecode($_) } | ConvertFrom-StringData -ErrorAction Stop | ForEach-Object {
						$data += $_
					}
					$newRequest.Query = $data
				}
				catch { }
			}
		}
	}
	process {
		$commandInfo = Get-Command -Name $Command
		$results = @{ }
		foreach ($parameter in $commandInfo.Parameters.Keys) {
			$value = Get-RestParameterValue -Request $newRequest -Name $parameter
			if ($null -ne $value) { $results[$parameter] = $value }
		}
		$results
	}
}