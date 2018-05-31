Import-Module -Name $env:CI_MODULE_MANIFEST_PATH -Force

$systemUnderTest = ( Split-Path -Leaf $MyInvocation.MyCommand.Path ) -replace '\.Tests\.', '.'

$function = $systemUnderTest.Split( '.' )[0]
$describe = $Global:PublicFunctionForm -f $function
Describe -Name $describe -Tag 'Function', 'Public', $function -Fixture {
    #region init
    $help = Get-Help -Name $function -Full

    $Global:ArmorSession = [ArmorSession]::New( 'api.armor.com', 443, 'v1.0' )
    #endregion

    $splat = @{
        'ExpectedFunctionName' = $function
        'FoundFunctionName'    = $help.Name
    }
    TestAdvancedFunctionName @splat

    TestAdvancedFunctionHelpMain -Help $help

    TestAdvancedFunctionHelpInputs -Help $help

    $splat = @{
        'ExpectedOutputTypeNames' = 'System.Management.Automation.PSObject[]'
        'Help'                    = $help
    }
    TestAdvancedFunctionHelpOutputs @splat

    $splat = @{
        'ExpectedParameterNames' = 'ID', 'NewName', 'ApiVersion', 'WhatIf', 'Confirm'
        'Help'                   = $help
    }
    TestAdvancedFunctionHelpParameters @splat

    $splat = @{
        'ExpectedNotes' = $Global:FunctionHelpNotes
        'Help'          = $help
    }
    TestAdvancedFunctionHelpNotes @splat

    Context -Name $Global:Execution -Fixture {
        InModuleScope -ModuleName $Env:CI_MODULE_NAME -ScriptBlock {
            #region init
            $invalidID = 0
            $validID = 1
            $invalidNewName = ''
            $validNewName = 'FakeName'
            $invalidApiVersion = 'v0.0'
            $validApiVersion = 'v1.0'
            #endregion

            $testCases = @(
                @{
                    'ID'         = $invalidID
                    'NewName'    = $validNewName
                    'ApiVersion' = $validApiVersion
                },
                @{
                    'ID'         = $validID
                    'NewName'    = $invalidNewName
                    'ApiVersion' = $validApiVersion
                },
                @{
                    'ID'         = $validID
                    'NewName'    = $validNewName
                    'ApiVersion' = $invalidApiVersion
                }
            )
            $testName = 'should fail when set to: ID: <ID>, NewName: <NewName>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $ID, [String] $NewName, [String] $ApiVersion )
                { Rename-ArmorCompleteVM -ID $ID -NewName $NewName -ApiVersion $ApiVersion -Confirm:$false } |
                    Should -Throw
            } # End of It

            Mock -CommandName Test-ArmorSession -Verifiable -MockWith {}
            Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
                @{
                    'StatusCode'        = 200
                    'StatusDescription' = 'OK'
                    'Content'           = $Global:JsonResponseBody.VMs1
                }
            }

            $testCases = @(
                @{
                    'ID'         = $validID
                    'NewName'    = $validNewName
                    'ApiVersion' = $validApiVersion
                }
            )
            $testName = 'should not fail when set to: ID: <ID>, NewName: <NewName>, ApiVersion: <ApiVersion>'
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $ID, [String] $NewName, [String] $ApiVersion )
                { Rename-ArmorCompleteVM -ID $ID -NewName $NewName -ApiVersion $ApiVersion -Confirm:$false } |
                    Should -Not -Throw
            } # End of It
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Test-ArmorSession -Times 1
            Assert-MockCalled -CommandName Invoke-WebRequest -Times 1
        } # End of InModuleScope
    } # End of Context

    Context -Name $Global:ReturnTypeContext -Fixture {
        InModuleScope -ModuleName $Env:CI_MODULE_NAME -ScriptBlock {
            Mock -CommandName Test-ArmorSession -Verifiable -MockWith {}
            Mock -CommandName Invoke-WebRequest -Verifiable -MockWith {
                @{
                    'StatusCode'        = 200
                    'StatusDescription' = 'OK'
                    'Content'           = $Global:JsonResponseBody.VMs1
                }
            }

            $testCases = @(
                @{
                    'FoundReturnType'    = ( Rename-ArmorCompleteVM -ID 1 -NewName 'FakeName' -Confirm:$false -ErrorAction 'Stop' ).GetType().FullName
                    'ExpectedReturnType' = 'System.Management.Automation.PSCustomObject'
                }
            )
            $testName = $Global:ReturnTypeForm
            It -Name $testName -TestCases $testCases -Test {
                param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
                $FoundReturnType |
                    Should -Be $ExpectedReturnType
            } # End of It
            Assert-VerifiableMock
            Assert-MockCalled -CommandName Test-ArmorSession -Times 1
            Assert-MockCalled -CommandName Invoke-WebRequest -Times 1

            # $testName = "has an 'OutputType' entry for <FoundReturnType>"
            # It -Name $testName -TestCases $testCases -Test {
            #     param ( [String] $FoundReturnType, [String] $ExpectedReturnType )
            #     $FoundReturnType |
            #         Should -BeIn ( Get-Help -Name 'Rename-ArmorCompleteVM' -Full ).ReturnValues.ReturnValue.Type.Name
            # } # End of It
        } # End of InModuleScope
    } # End of Context
} # End of Describe
