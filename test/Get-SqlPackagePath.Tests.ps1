import-Module -Name ..\PublishDacPac.psd1

$ExeName = "*SqlPackage.exe";

Describe "Get-SqlPackagePath" {
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

        It "Finds SqlPackage.exe version 120" {
            ( Get-SqlPackagePath -Version 120 ) -like $ExeName | Should -Be $true
        }

        It "Fails to find SqlPackage.exe version 110" {
            Get-SqlPackagePath -Version 110 | Should -Be $null
        }

        It "Fails to find SqlPackage.exe version XXX" {
            Get-SqlPackagePath -Version XXX | Should -Be $null
        }

    }
}

Remove-Module -Name PublishDacPac