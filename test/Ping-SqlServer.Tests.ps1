BeforeAll { 
    $CurrentFolder = Split-Path -Parent $PSScriptRoot;
    $ModulePath = Resolve-Path "$CurrentFolder\PublishDacPac\PublishDacPac.psd1";
    Import-Module -Name $ModulePath;
}

Describe "Ping-SqlServer" {
    Context "Testing Inputs" {
        It "Should have Server as a mandatory parameter" {
            (Get-Command Ping-SqlServer).Parameters['Server'].Attributes.mandatory | Should -BeTrue;
        }
    }

    It "Invalid server" {
        ( Ping-SqlServer -Server "Invalid" ) | Should -BeFalse;
    }

    It "Valid server localhost" {
        ( Ping-SqlServer -Server "localhost" ) | Should -BeTrue;
    }

    #It "Valid server" {
    #    ( Ping-SqlServer -Server "localhost" ) | Should -BeTrue;
    #}

}

AfterAll {
    Remove-Module -Name PublishDacPac;
}