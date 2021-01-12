BeforeAll { 
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

Describe "Get-SqlPackagePath" -Tag "Round1" {

    Context "Testing Inputs" {
        It "Should have Version as a mandatory parameter" {
            (Get-Command Get-SqlPackagePath).Parameters['Version'].Attributes.mandatory | Should -BeTrue;
        }
    }

    Context "Finds SqlPackage.exe version" {
        It "Finds SqlPackage.exe version 15" {
            ( Get-SqlPackagePath -Version 15 ) -like "*SqlPackage.exe" | Should -BeTrue;
        }

        It "Finds SqlPackage.exe version 14" {
            ( Get-SqlPackagePath -Version 14 ) -like "*SqlPackage.exe" | Should -BeTrue;
        }

        It "Does not find SqlPackage.exe version 13" {
            ( Get-SqlPackagePath -Version 13 ) -like "*SqlPackage.exe" | Should -BeFalse;
        }

        It "Does not find SqlPackage.exe version 12" {
            ( Get-SqlPackagePath -Version 12 ) -like "*SqlPackage.exe" | Should -BeFalse;
        }

        It "Does not find SqlPackage.exe version 11" {
            ( Get-SqlPackagePath -Version 11 ) -like "*SqlPackage.exe" | Should -BeFalse;
        }

        It "Unsupported SqlPackage.exe version 10 so Should -Throw;" {
            { Get-SqlPackagePath -Version 10 } | Should -Throw;
        }

        It "Invalid SqlPackage.exe version XX Should -Throw;" {
            { Get-SqlPackagePath -Version XX } | Should -Throw;
        }

        It "Valid folder but SqlPackage.exe is not present in folder" {
            ResetEnv;
            $env:CustomSqlPackageInstallLocation = $PSScriptRoot;
            ( Get-SqlPackagePath -Version 13 ) -like "*SqlPackage.exe" | Should -BeFalse;
        }

        It "Invalid folder location for CustomSqlPackageInstallLocation" {
            ResetEnv;
            $env:CustomSqlPackageInstallLocation = $PSScriptRoot + "\xxx";
            ( Get-SqlPackagePath -Version 13 ) -like "*SqlPackage.exe" | Should -BeFalse;
        }

        It "Valid folder location and SqlPackage.exe present" {
            ResetEnv;
            $ExePath = Split-Path -Parent $PSScriptRoot;
            $ExePath = Resolve-Path "$ExePath\examples\ForTests\CustomSqlPackageInstallLocation";
            $env:CustomSqlPackageInstallLocation = $ExePath;
            ( Get-SqlPackagePath -Version 12 ) -like "*SqlPackage.exe" | Should -BeTrue;
        }

        It "Valid folder location and SqlPackage.exe present but is not 13" {
            ResetEnv;
            $ExePath = Split-Path -Parent $PSScriptRoot;
            $ExePath = Resolve-Path "$ExePath\examples\ForTests\CustomSqlPackageInstallLocation";
            $env:CustomSqlPackageInstallLocation = $ExePath;
            ( Get-SqlPackagePath -Version 13 ) -like "*SqlPackage.exe" | Should -BeFalse;
        }
        
    }
}

AfterAll {
    Remove-Module -Name PublishDacPac;
}
 