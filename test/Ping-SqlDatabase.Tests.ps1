$ModulePath = Split-Path -Parent $MyInvocation.MyCommand.Path;
$ModulePath = Resolve-Path "$ModulePath\..\PublishDacPac\PublishDacPac.psd1";
import-Module -Name $ModulePath;

Describe "Ping-SqlDatabase" {
    Context "Testing Inputs" {
        It "Should have Server as a mandatory parameter" {
            (Get-Command Ping-SqlDatabase).Parameters['Server'].Attributes.mandatory | Should -Be $true
        }
        It "Should have DatabaseName as a mandatory parameter" {
            (Get-Command Ping-SqlDatabase).Parameters['Database'].Attributes.mandatory | Should -Be $true
        }
    }

    It "Invalid server" {
        ( Ping-SqlDatabase -Server "InvalidServer" -Database "master" ) | Should -Be $false;
    }

    It "Valid server and invalid database" {
        ( Ping-SqlDatabase -Server "localhost" -Database "InvalidDatabase" ) | Should -Be $false;
    }

    It "Valid server and database" {
        ( Ping-SqlDatabase -Server "localhost" -Database "master" ) | Should -Be $true;
    }

}

Remove-Module -Name PublishDacPac
