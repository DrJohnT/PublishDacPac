$ModulePath = Split-Path -Parent $MyInvocation.MyCommand.Path;
$ModulePath = Resolve-Path "$ModulePath\..\PublishDacPac\PublishDacPac.psd1";
import-Module -Name $ModulePath;

$ExeName = "*SqlPackage.exe";

Describe "Get-SqlPackagePath" {

    Context "Testing Inputs" {
        It "Should have Version as a mandatory parameter" {
            (Get-Command Get-SqlPackagePath).Parameters['Version'].Attributes.mandatory | Should -Be $true
        }
    }

    Context "Finds SqlPackage.exe version" {
        It "Finds SqlPackage.exe version 150" {
            ( Get-SqlPackagePath -Version 150 ) -like $ExeName | Should -Be $true
        }

        It "Finds SqlPackage.exe version 140" {
            ( Get-SqlPackagePath -Version 140 ) -like $ExeName | Should -Be $true
        }

        It "Finds SqlPackage.exe version 130" {
            ( Get-SqlPackagePath -Version 130 ) -like $ExeName | Should -Be $true
        }

        It "Does not find SqlPackage.exe version 120" {
            ( Get-SqlPackagePath -Version 120 ) -like $ExeName | Should -Be $false
        }

        It "Does not find SqlPackage.exe version 110" {
            ( Get-SqlPackagePath -Version 110 ) -like $ExeName | Should -Be $false
        }

        It "Unsupported SqlPackage.exe version 100 so should Throw" {
            { Get-SqlPackagePath -Version 100 } | Should Throw;
        }

        It "Invalid SqlPackage.exe version XXX should Throw" {
            { Get-SqlPackagePath -Version XXX } | Should Throw;
        }

    }
}

Remove-Module -Name PublishDacPac