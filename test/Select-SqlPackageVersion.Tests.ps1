import-Module -Name ..\PublishDacPac.psd1

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
    It "Finds version 120" {
        Select-SqlPackageVersion -PreferredVersion 120 | Should -Be 120
    }
    It "Does not find version 100 so returns latest" {
        Select-SqlPackageVersion -PreferredVersion 100 | Should -Be 150
    }
    It "Does not find version XXX" {
        Select-SqlPackageVersion -PreferredVersion XXX | Should -Be 150
    }
}

Remove-Module -Name PublishDacPac