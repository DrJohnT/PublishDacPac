BeforeAll { 
    $CurrentFolder = Split-Path -Parent $PSScriptRoot;
    $ModulePath = Resolve-Path "$CurrentFolder\PublishDacPac\PublishDacPac.psd1";
    Import-Module -Name $ModulePath;
}

Describe "Ping-SqlDatabase" {
    Context "Testing Inputs" {
        It "Should have Server as a mandatory parameter" {
            (Get-Command Ping-SqlDatabase).Parameters['Server'].Attributes.mandatory | Should -BeTrue;
        }
        It "Should have DatabaseName as a mandatory parameter" {
            (Get-Command Ping-SqlDatabase).Parameters['Database'].Attributes.mandatory | Should -BeTrue;
        }
    }

    It "Invalid server" {
        ( Ping-SqlDatabase -Server "InvalidServer" -Database "master" ) | Should -BeFalse;
    }

    It "Valid server and invalid database" {
        ( Ping-SqlDatabase -Server "localhost" -Database "InvalidDatabase" ) | Should -BeFalse;
    }

    It "Valid server and database" {
        ( Ping-SqlDatabase -Server "localhost" -Database "master" ) | Should -BeTrue;
    }

}

AfterAll {
    Remove-Module -Name PublishDacPac;
}
