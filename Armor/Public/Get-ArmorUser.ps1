function Get-ArmorUser {
    <#
        .SYNOPSIS
        This cmdlet retrieves a list of users in your account.

        .DESCRIPTION
        This cmdlet retrieves details about the user accounts in the
        Armor Anywhere or Armor Complete account in context.  Returns a set of
        user accounts that correspond to the filter criteria provided by the
        cmdlet parameters.

        .INPUTS
        System.UInt16

        System.String

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .EXAMPLE
        {required: show one or more examples using the function}

        .LINK
        http://armorpowershell.readthedocs.io/en/latest/cmd_get.html#get-armoruser

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell

        .LINK
        https://docs.armor.com/display/KBSS/Get+Users

        .LINK
        https://docs.armor.com/display/KBSS/Get+User

        .LINK
        https://developer.armor.com/#!/Account_Management/Users_GetUsers

        .LINK
        https://developer.armor.com/#!/Account_Management/Users_GetUser
    #>

    [CmdletBinding( DefaultParameterSetName = 'ID' )]
    [OutputType( [PSCustomObject[]] )]
    param (
        <#
        Specifies the ID of the Armor user account.
        #>
        [Parameter(
            ParameterSetName = 'ID',
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $ID = 0,

        <#
        Specifies the username of the Armor user account.  Wildcard searches
        are permitted.
        #>
        [Parameter(
            ParameterSetName = 'UserName',
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $UserName = '',

        <#
        Specifies the first name of the Armor user account.  Wildcard searches
        are permitted.
        #>
        [Parameter(
            ParameterSetName = 'Name',
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $FirstName = '',

        <#
        Specifies the last name of the Armor user account.  Wildcard searches
        are permitted.
        #>
        [Parameter(
            ParameterSetName = 'Name',
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $LastName = '',

        <#
        Specifies the API version for this request.
        #>
        [Parameter( Position = 1 )]
        [ValidateSet( 'v1.0' )]
        [String]
        $ApiVersion = $Global:ArmorSession.ApiVersion
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}'."

        Test-ArmorSession
    } # End of begin

    process {
        [PSCustomObject[]] $return = $null

        $resources = Get-ArmorApiData -FunctionName $function -ApiVersion $ApiVersion

        if ( $PsCmdlet.ParameterSetName -eq 'ID' -and $ID -gt 0 ) {
            $uri = New-ArmorApiUri -Endpoints $resources.Endpoints -IDs $ID
        }
        else {
            $uri = New-ArmorApiUri -Endpoints $resources.Endpoints
        }

        $keys = ( $resources.Query | Get-Member -MemberType 'NoteProperty' ).Name
        $parameters = ( Get-Command -Name $function ).Parameters.Values
        $uri = New-ArmorApiUriQuery -Keys $keys -Parameters $parameters -Uri $uri

        $results = Submit-ArmorApiRequest -Uri $uri -Method $resources.Method -Description $resources.Description

        $filters = ( $resources.Filter | Get-Member -MemberType 'NoteProperty' ).Name
        $results = Select-ArmorApiResult -Results $results -Filters $filters

        if ( $results.Count -eq 0 ) {
            Write-Host -Object 'Armor user not found.'
        }
        else {
            $return = $results
        }

        $return
    } # End of process

    end {
        Write-Verbose -Message "Ending: '${function}'."
    } # End of end
} # End of function
