$ModulePath = Split-Path -Parent $MyInvocation.MyCommand.Path;
$ModulePath = Resolve-Path "$ModulePath\..\PublishDacPac\PublishDacPac.psd1";
import-Module -Name $ModulePath;

Describe "Select-SqlPackageVersion" {

    It "Finds latest version" {
        Select-SqlPackageVersion -PreferredVersion latest | Should -Be 150
    }
    It "Finds version 150" {
        Select-SqlPackageVersion -PreferredVersion 150 | Should -Be 150
    }
    It "Finds version 140" {
        Select-SqlPackageVersion -PreferredVersion 140 | Should -Be 140
    }
    It "Finds version 130" {
        Select-SqlPackageVersion -PreferredVersion 130 | Should -Be 130
    }

    #It "Finds version 120" {
    #    Select-SqlPackageVersion -PreferredVersion 120 | Should -Be 120
    #}

    It "Does not find SqlPackage.exe version 120 so should return 150 (latest)" {
        Select-SqlPackageVersion -PreferredVersion 120 | Should -Be 150;
    }

    It "Unsupported SqlPackage.exe version 110 so should Throw" {
        { Select-SqlPackageVersion -PreferredVersion 110 } | Should Throw;
    }

    It "Unsupported SqlPackage.exe version 100 so should Throw" {
        { Select-SqlPackageVersion -PreferredVersion 100 } | Should Throw;
    }

    It "Invalid version XXX so should throw" {
        { Select-SqlPackageVersion -PreferredVersion XXX } | Should Throw;
    }
}

Remove-Module -Name PublishDacPac