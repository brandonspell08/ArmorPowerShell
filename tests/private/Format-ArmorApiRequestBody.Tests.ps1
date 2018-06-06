Import-Module -Name $Env:CI_MODULE_MANIFEST_PATH -Force

$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'
$filePath = Join-Path -Path $Env:CI_MODULE_PRIVATE_PATH -ChildPath $systemUnderTest

. $filePath

$function = $systemUnderTest.Split( '.' )[0]
$describe = $Global:PrivateFunctionForm -f $function
Describe -Name $describe -Tag 'Function', 'Private', $function -Fixture {
    #region init
    $help = Get-Help -Name $function -Full
    $validKeys = 'code', 'grant_type', 'array', 'switch'
    $validParameters = [PSCustomObject] @{
        'Code'      = '+8oaKtcO9kuVbjUXlfnlHCY3HmXXCidHjzOBGwr+iTo='
        'GrantType' = 'authorization_code'
        'Array'     = 'test1', 'test2'
        'Switch'    = $true
    }

    function Test-FormatArmorApiRequestBody1 {
        param ( [String] $Code, [String] $GrantType, [String[]] $Array, [Switch] $Switch )
        $parameters = ( Get-Command -Name $MyInvocation.MyCommand.Name ).Parameters.Values
        Format-ArmorApiRequestBody -Keys $validKeys -Parameters $parameters
    }
    #endregion

    $splat = @{
        'ExpectedFunctionName' = $function
        'FoundFunctionName'    = $help.Name
    }
    TestAdvancedFunctionName @splat

    TestAdvancedFunctionHelpMain -Help $help

    TestAdvancedFunctionHelpInputs -Help $help

    $splat = @{
        'ExpectedOutputTypeNames' = 'System.String'
        'Help'                    = $help
    }
    TestAdvancedFunctionHelpOutputs @splat

    $splat = @{
        'ExpectedParameterNames' = 'Keys', 'Parameters'
        'Help'                   = $help
    }
    TestAdvancedFunctionHelpParameters @splat

    $splat = @{
        'ExpectedNotes' = $Global:FunctionHelpNotes
        'Help'          = $help
    }
    TestAdvancedFunctionHelpNotes @splat

    Context -Name $Global:Execution -Fixture {
        #region init
        #endregion

        $testCases = @(
            @{
                'Keys'       = ''
                'Parameters' = $validParameters
            },
            @{
                'Keys'       = 'key1', ''
                'Parameters' = $validParameters
            },
            @{
                'Keys'       = $validKeys
                'Parameters' = ''
            },
            @{
                'Keys'       = $validKeys
                'Parameters' = @()
            },
            @{
                'Keys'       = $validKeys
                'Parameters' = 'parameter1', ''
            }
        )
        $testName = 'should fail when set to: Keys: <Keys>, Parameters: <Parameters>'
        It -Name $testName -TestCases $testCases -Test {
            param ( [String[]] $Keys, [PSCustomObject[]] $Parameters )
            { Format-ArmorApiRequestBody -Keys $Keys -Parameters $Parameters } |
                Should -Throw
        } # End of It

        $splat = @{
            'Code'        = $validParameters.Code
            'GrantType'   = $validParameters.GrantType
            'Array'       = $validParameters.Array
            'Switch'      = $true
        }
        $testName = "should not fail when set to: Code: '" + $validParameters.Code + "', " +
            "GrantType: '" + $validParameters.GrantType + "', Array: '" + $validParameters.Array + "', " +
            "Switch: '" + $validParameters.Switch + "'"
        It -Name $testName -Test {
            { Test-FormatArmorApiRequestBody1 @splat } |
                Should -Not -Throw
        } # End of It
    } # End of Context

    Context -Name $Global:ReturnTypeContext -Fixture {
        #region init
        $splat = @{
            'Code'        = $validParameters.Code
            'GrantType'   = $validParameters.GrantType
            'Array'       = $validParameters.Array
            'Switch'      = $true
            'ErrorAction' = 'Stop'
        }
        #endregion

        $testCases = @(
            @{
                'FoundReturnType'    = ( Test-FormatArmorApiRequestBody1 @splat ).GetType().FullName
                'ExpectedReturnType' = 'System.String'
            }
        )
        $testName = $Global:ReturnTypeForm
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
            $FoundReturnType |
                Should -Be $ExpectedReturnType
        } # End of It

        $testName = "has an 'OutputType' entry for <FoundReturnType>"
        It -Name $testName -TestCases $testCases -Test {
            param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
            $FoundReturnType |
                Should -BeIn ( Get-Help -Name 'Format-ArmorApiRequestBody' ).ReturnValues.ReturnValue.Type.Name
        } # End of It
    } # End of Context
} # End of Describe
