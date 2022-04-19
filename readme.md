# Azure.Function.Tools

Utility module (mostly) intended for use from within a PowerShell Azure Function App.
Provides some general tools for ...

+ Reading user input / parameters (Get-RestParameter / Get-RestParameterValue)
+ Writing output / return values (Write-FunctionResult)
+ Basic Configuration handling (Import-Config / Get-ConfigValue / Set-ConfigValue)
+ Caller scope validation (Read-TokenScope)
+ Connection Logic for connecting to a Function App using Azure AD auth (`Connect-*` - those are mostly designed for local use, but can also be used for FunctionApp to FunctionApp authentication)
