function Get-VaultCredential {
	<#
	.SYNOPSIS
		Reads a credential object from Azure KeyVault.
	
	.DESCRIPTION
		Reads a credential object from Azure KeyVault.
		There are two ways to provide a credential object through this command:

		+ Inline: The credentials are stored in a single secret, separated by a pipe symbol:
		          <username>|<password>
		+ Dual: The credentials are stored in two secrets. The secret names must then both start with the specified -SecretName,
		        then end in ".UserName" and ".Password". E.g. "MySecret.UserName" and "MySecret.Password"
	
	.PARAMETER SecretName
		The name of the secret storing the credentials.
	
	.PARAMETER Type
		The type of credentials to retrieve.
		This can be either "Inline" or "Dual".
		See the description for details.
	
	.PARAMETER VaultName
		The name of the Key Vault from which to retrieve the certificate.
		Defaults to whatever is configured under the configuration entry "VaultName"
		(See Import-Config and Get-ConfigValue for details)
	
	.EXAMPLE
		PS C:\> Get-VaultCredential -SecretName myCred -Type Inline
		
		Retrieves the credentials stored in the myCred secret within the configured default Key Vault.
	#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '')]
	[OutputType([PSCredential])]
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, Position = 0)]
		[string]
		$SecretName,

		[Parameter(Mandatory = $true)]
		[ValidateSet('Inline','Dual')]
		[string]
		$Type,

		[string]
		$VaultName = (Get-ConfigValue -Name VaultName)
	)

	if (-not $VaultName) {
		throw "No vault name found! Either use the -VaultName parameter or provide a configuration setting for 'VaultName'"
	}

	switch ($Type) {
		'Inline' {
			try { $secret = Get-AzKeyVaultSecret -VaultName $VaultName -Name $SecretName -ErrorAction Stop }
			catch { throw }

			$value = [PSCredential]::New("Irrelevant", $secret.SecretValue).GetNetworkCredential().Password
			$name, $password = $value -split "\|",2
			[PSCredential]::new($name, ($password | ConvertTo-SecureString -AsPlainText -Force))
		}
		'Dual' {
			try { $secretName = Get-AzKeyVaultSecret -VaultName $VaultName -Name "$SecretName.UserName" -ErrorAction Stop }
			catch { throw }
			try { $secretPassword = Get-AzKeyVaultSecret -VaultName $VaultName -Name "$SecretName.Password" -ErrorAction Stop }
			catch { throw }
			$userName = [PSCredential]::New("Irrelevant", $secretName.SecretValue).GetNetworkCredential().Password
			[PSCredential]::new($userName, $secretPassword.SecretValue)
		}
	}
}