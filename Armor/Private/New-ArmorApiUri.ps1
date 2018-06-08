function New-ArmorApiUri {
    <#
        .SYNOPSIS
        This cmdlet is used to build a valid URI.

        .DESCRIPTION
        { required: more detailed description of the function's purpose }

        .INPUTS
        None- this function does not accept pipeline inputs.

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        New-ArmorApiUri -Server 'api.armor.com' -Port 443 -Endpoint '/auth/authorize'
        This will return 'https://api.armor.com:443/auth/authorize'.

        .LINK
        https://armorpowershell.readthedocs.io/en/latest/index.html

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/New-ArmorApiUri.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/
    #>

    [CmdletBinding()]
    [OutputType( [String] )]
    param (
        # Specifies the Armor API server IP address or FQDN.
        [Parameter( Position = 0 )]
        [ValidateNotNullOrEmpty()]
        [String]
        $Server = $Global:ArmorSession.Server,

        # Specifies the Armor API server port.
        [Parameter( Position = 1 )]
        [ValidateRange( 1, 65535 )]
        [UInt16]
        $Port = $Global:ArmorSession.Port,

        # Specifies the array of available endpoint paths.
        [Parameter(
            Mandatory = $true,
            Position = 2
        )]
        [ValidateScript( { $_ -match '^/' } )]
        [String[]]
        $Endpoints,

        # Specifies the positional ID values to be inserted into the path.
        [Parameter( Position = 3 )]
        [ValidateCount( 0, 2 )]
        [ValidateScript( { $_ -match '^(?:\d+|[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})$' } )]
        [AllowEmptyCollection()]
        [String[]]
        $IDs
    )

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}'."
    } # End of begin

    process {
        [String] $return = $null

        Write-Verbose -Message 'Build the URI.'

        switch ( $IDs.Count ) {
            0 {
                $endpoint = $Endpoints.Where( { $_ -notmatch '{id}' } )

                if ( $endpoint.Count -eq 0 ) {
                    throw 'Endpoint with no ID specification not found.'
                }
                elseif ( $endpoint.Count -ne 1 ) {
                    throw 'More than one endpoint with no ID specification found.'
                }
                else {
                    $endpoint = $endpoint[0]
                }

                $return = "https://${Server}:${Port}${endpoint}"
            }

            1 {
                $endpoint = $Endpoints.Where( { $_ -match '/{id}' -and $_ -notmatch '/{id}.*/{id}' } )

                if ( $endpoint.Count -eq 0 ) {
                    throw 'Endpoint with one ID specification not found.'
                }
                elseif ( $endpoint.Count -ne 1 ) {
                    throw 'More than one endpoint with one ID specification found.'
                }
                else {
                    $endpoint = $endpoint[0]
                }

                $return = "https://${Server}:${Port}${endpoint}"

                # Insert ID in URI string
                $return = $return -replace '{id}', $IDs[0]
            }

            2 {
                $endpoint = $Endpoints.Where( { $_ -match '/{id}.*/{id}' -and $_ -notmatch '/{id}.*/{id}.*/{id}' } )

                if ( $endpoint.Count -eq 0 ) {
                    throw 'Endpoint with two ID specifications not found.'
                }
                elseif ( $endpoint.Count -ne 1 ) {
                    throw 'More than one endpoint with two ID specifications found.'
                }
                else {
                    $endpoint = $endpoint[0]
                }

                $return = "https://${Server}:${Port}${endpoint}"

                # Insert first ID in URI string
                $return = $return -replace '(.*?)/{id}(.*)', "`$1/$( $IDs[0] )`$2"

                # Insert second ID in URI string
                $return = $return -replace '{id}', $IDs[1]
            }
        }

        Write-Verbose -Message "URI = ${return}"

        $return
    } # End of process

    end {
        Write-Verbose -Message "Ending: '${function}'."
    } # End of end
} # End of function
