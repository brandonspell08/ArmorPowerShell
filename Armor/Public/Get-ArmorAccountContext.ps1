function Get-ArmorAccountContext {
    <#
        .SYNOPSIS
        Retrieves the Armor Anywhere or Armor Complete account currently in context.

        .DESCRIPTION
        If your user account has access to more than one Armor Anywhere and/or Armor
        Complete accounts, this cmdlet allows you to get the current context, which all
        future requests will reference.

        .INPUTS
        None- this function does not accept pipeline inputs

        .NOTES
        - Troy Lindsay
        - Twitter: @troylindsay42
        - GitHub: tlindsay42

        .EXAMPLE
        Get-ArmorAccountContext
        Retrieves the Armor account currently in context.

        .LINK
        https://tlindsay42.github.io/ArmorPowerShell/public/Get-ArmorAccountContext/

        .LINK
        https://github.com/tlindsay42/ArmorPowerShell/blob/master/Armor/Public/Get-ArmorAccountContext.ps1

        .LINK
        https://docs.armor.com/display/KBSS/Log+into+Armor+API

        .LINK
        https://developer.armor.com/

        .COMPONENT
        Armor API

        .FUNCTIONALITY
        Armor session management
    #>

    [CmdletBinding()]
    [OutputType( [ArmorAccount] )]
    param ()

    begin {
        $function = $MyInvocation.MyCommand.Name

        Write-Verbose -Message "Beginning: '${function}'."
    } # End of begin

    process {
        [ArmorAccount] $return = $Global:ArmorSession.GetAccountContext()

        $return
    } # End of process

    end {
        Write-Verbose -Message "Ending: '${function}'."
    } # End of end
} # End of function
