$ModulePath = Split-Path -Parent $MyInvocation.MyCommand.Path;
$ModulePath = Resolve-Path "$ModulePath\..\PublishDacPac\PublishDacPac.psd1";
import-Module -Name $ModulePath;

Describe "Ping-SqlServer" {
    Context "Testing Inputs" {
        It "Should have Server as a mandatory parameter" {
            (Get-Command Ping-SqlServer).Parameters['Server'].Attributes.mandatory | Should -Be $true
        }
    }

    It "Invalid server" {
        ( Ping-SqlServer -Server "Invalid" ) | Should -Be $false;
    }

    It "Valid server localhost" {
        ( Ping-SqlServer -Server "localhost" ) | Should -Be $true;
    }

    #It "Valid server" {
    #    ( Ping-SqlServer -Server "localhost" ) | Should -Be $true;
    #}

}

Remove-Module -Name PublishDacPac