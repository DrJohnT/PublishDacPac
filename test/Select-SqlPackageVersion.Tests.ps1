﻿BeforeAll { 
    $CurrentFolder = Split-Path -Parent $PSScriptRoot;
    $ModulePath = Resolve-Path "$CurrentFolder\PublishDacPac\PublishDacPac.psd1";
    Import-Module -Name $ModulePath;

    function ResetEnv {
        $value = [Environment]::GetEnvironmentVariable("CustomSqlPackageInstallLocation");
        if ("$value" -ne "") {
            Clear-Item -Path Env:CustomSqlPackageInstallLocation;
        }
    }
    ResetEnv;
}

Describe "Select-SqlPackageVersion" -Tag "Round1" {

    It "Finds latest version" {
        Select-SqlPackageVersion -PreferredVersion 'latest' | Should -Be 15
    }
    
    It "Finds version 15" {
        Select-SqlPackageVersion -PreferredVersion 15 | Should -Be 15
    }
    
    It "150 Finds version 15" {
        Select-SqlPackageVersion -PreferredVersion 150 | Should -Be 150
    }
    It "Finds version 14" {
        Select-SqlPackageVersion -PreferredVersion 14 | Should -Be 14
    }
    It "Does not find version 13 so should return 15 (latest)" {
        Select-SqlPackageVersion -PreferredVersion 13 | Should -Be 15
    }

    It "Does not find version 12 so should return 15 (latest)" {
        Select-SqlPackageVersion -PreferredVersion 12 | Should -Be 15
    }

    It "Does not find version 11 so should return 15 (latest)" {
        Select-SqlPackageVersion -PreferredVersion 11 | Should -Be 15;
    }

    It "Unsupported version 10 so Should -Throw;" {
        { Select-SqlPackageVersion -PreferredVersion 10 } | Should -Throw;
    }

    It "Invalid version XX so Should -Throw;" {
        { Select-SqlPackageVersion -PreferredVersion XX } | Should -Throw;
    }
    
}

AfterAll {
    Remove-Module -Name PublishDacPac;
}