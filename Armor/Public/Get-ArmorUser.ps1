Function Get-ArmorUser
{
	<#
		.SYNOPSIS
		The Get-ArmorVm retrieves a list of users in your account.

		.DESCRIPTION
		{ required: more detailed description of the function's purpose }

		.NOTES
		Troy Lindsay
		Twitter: @troylindsay42
		GitHub: tlindsay42

		.PARAMETER Parameter
		{ required: description of the specified input parameter's purpose }

		.INPUTS
		{ required: .NET Framework object types that can be piped in and a description of the input objects }

		.OUTPUTS
		{ required: .NET Framework object types that the cmdlet returns and a description of the returned objects }

		.LINK
		https://github.com/tlindsay42/ArmorPowerShell

		.LINK
		https://docs.armor.com/display/KBSS/Armor+API+Guide

		.LINK
		https://developer.armor.com/

		.EXAMPLE
		{required: show one or more examples using the function}
	#>

	[CmdletBinding()]
	Param
	(
		[Parameter( Position = 0 )]
		[String] $Name = $null,
		[Parameter( Position = 1 )]
		[String] $ApiVersion = $global:ArmorConnection.ApiVersion
	)

	Begin
	{
		# The Begin section is used to perform one-time loads of data necessary to carry out the function's purpose
		# If a command needs to be run with each iteration or pipeline input, place it in the Process section

		# Check to ensure that a session to the Armor cluster exists and load the needed header data for authentication
		Test-ArmorConnection

		# API data references the name of the function
		# For convenience, that name is saved here to $function
		$function = $MyInvocation.MyCommand.Name

		Write-Verbose  -Message ( 'Beginning {0}.' -f $function )
	} # End of Begin

	Process
	{
		# Retrieve all of the URI, method, body, query, location, filter, and success details for the API endpoint
		Write-Verbose -Message ( 'Gather API Data for {0}.' -f $function )
		
		$resources = Get-ArmorApiData -Endpoint $function -ApiVersion $ApiVersion

		If ( $Name.Length -eq 0 )
		{
			$uri = New-ArmorApiUriString -Server $global:ArmorConnection.Server -Port $global:ArmorConnection.Port -Endpoint $resources.Uri
		}
		Else
		{
			$uri = New-ArmorApiUriString -Server $global:ArmorConnection.Server -Port $global:ArmorConnection.Port -Endpoint $resources.Uri -Id $Name
		}

		#$uri = Test-QueryParam -QueryKeys $resources.Query.Keys -Parameters ( Get-Command -Name $function ).Parameters.Values -Uri $uri

		$body = Format-ArmorApiJsonRequestBody -BodyKeys $resources.Body.Keys -Parameters ( Get-Command -Name $function ).Parameters.Values

		$result = Submit-ArmorApiRequest -Uri $uri -Headers $global:ArmorConnection.Headers -Method $resources.Method -Body $body

		$result = Format-ArmorApiResult -Result $result -Location $resources.Location

		$result = Select-ArmorApiResult -Result $result -Filter $resources.Filter

		Return $result
	} # End of Process

	End
	{
		Write-Verbose -Message ( 'Ending {0}.' -f $function )
	} # End of End
} # End of Function
