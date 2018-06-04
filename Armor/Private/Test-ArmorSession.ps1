function Test-ArmorSession {
    <#
        .SYNOPSIS
        This cmdlet tests the Armor API session.

        .DESCRIPTION
        Test to see if a session has been established with the Armor API and
        that it has not yet expired.  If no token is found, an error will be
        thrown.  If the session has expired, Disconnect-Armor will be called
        with confirmation disabled to clean up the session.  If less than 2/3
        of the session length remain, Update-ArmorApiToken will be called to
        renew the session.

        This cmdlet should be called in the Begin section of public cmdlets
        for optimal performance, so that the session is not tested repeatedly
        when pipeline input is processed.

        .INPUTS
        None- you cannot pipe objects to this cmdlet.

        .NOTES
        Troy Lindsay
        Twitter: @troylindsay42
        GitHub: tlindsay42

        .EXAMPLE
        Test-ArmorSession


        Description
        -----------
        Validates that the Armor API session stored in $Global:ArmorSession is
        still active.

        .LINK
        http://armorpowershell.readthedocs.io/en/latest/index.html

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Private/Test-ArmorSession.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Armor+API+Guide

        .LINK
        https://developer.armor.com/
    #>

    [CmdletBinding()]
    [OutputType( [Void] )]
    param ()

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}'."
    } # End of begin

    process {
        Write-Verbose -Message 'Verify that the session authorization exists.'
        if ( -not $Global:ArmorSession ) {
            throw 'Session not found.  Please log in again.'
        }
        elseif ( -not $Global:ArmorSession.AuthorizationExists() ) {
            throw 'Session authorization not found.  Please log in again.'
        }

        Write-Verbose -Message 'Verify that the session is active.'
        if ( $Global:ArmorSession.IsActive() ) {
            $minutesRemaining = $Global:ArmorSession.GetMinutesRemaining()

            Write-Verbose -Message "${minutesRemaining} minutes remaining until session expiration."

            if ( $minutesRemaining -lt ( $Global:ArmorSession.SessionLengthInMinutes * ( 2 / 3 ) ) ) {
                Write-Verbose -Message 'Renewing session token.'
                Update-ArmorApiToken -Token $Global:ArmorSession.GetToken()
            }
        }
        else {
            $expirationTime = $Global:ArmorSession.SessionExpirationTime

            Disconnect-Armor -Confirm:$false

            throw "Session expired at ${expirationTime}.  Please log in again."
        }
    } # End of process

    end {
        Write-Verbose -Message "Ending: '${function}'."
    } # End of end
} # End of function
