function Get-VaultCertificate {
	<#
	.SYNOPSIS
		Retrieve a certificate from Azure KeyVault.
	
	.DESCRIPTION
		Retrieve a certificate from Azure KeyVault.
		Expects to already be logged in using Connect-AzAccount.
	
	.PARAMETER SecretName
		The name of the secret under which the certificate is stored.
	
	.PARAMETER VaultName
		The name of the Key Vault from which to retrieve the certificate.
		Defaults to whatever is configured under the configuration entry "VaultName"
		(See Import-Config and Get-ConfigValue for details)
	
	.EXAMPLE
		PS C:\> Get-VaultCertificate -SecretName myCert

		Retrieves the certificate "myCert" from the configured default Key Vault
	#>
	[OutputType([System.Security.Cryptography.X509Certificates.X509Certificate2])]
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, Position = 0)]
		[string]
		$SecretName,

		[string]
		$VaultName = (Get-ConfigValue -Name VaultName)
	)

	if (-not $VaultName) {
		throw "No vault name found! Either use the -VaultName parameter or provide a configuration setting for 'VaultName'"
	}

	try { $secret = Get-AzKeyVaultSecret -VaultName $VaultName -Name $SecretName -ErrorAction Stop }
	catch { throw }
	$certString = [PSCredential]::New("irrelevant", $secret.SecretValue).GetNetworkCredential().Password
	$bytes = [convert]::FromBase64String($certString)
	[System.Security.Cryptography.X509Certificates.X509Certificate2]::new($bytes)
}