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

        It "Should have 64bit as a parameter" {
            (Get-Command Get-SqlPackagePath).Parameters['Use64BitPaths'].Attributes.mandatory | Should -BeFalse;
        }
    }

    Context "Finds SqlPackage.exe version" {
        It "Finds SqlPackage.exe latest version" {
            ( Get-SqlPackagePath -Version:"latest" ) -like "*SqlPackage.exe" | Should -BeTrue;
        }

        It "Finds SqlPackage.exe version 17" {
            ( Get-SqlPackagePath -Version 17 ) -like "*SqlPackage.exe" | Should -BeTrue;
        }

        It "Finds SqlPackage.exe version 16" {
            ( Get-SqlPackagePath -Version 16 ) -like "*SqlPackage.exe" | Should -BeTrue;
        }

        It "Does not find SqlPackage.exe version 15 so returns latest" {
            ( Get-SqlPackagePath -Version 15 ) -like "*SqlPackage.exe" | Should -BeTrue;
        }

        It "Finds SqlPackage.exe version 14" {
            ( Get-SqlPackagePath -Version 14 ) -like "*SqlPackage.exe" | Should -BeTrue;
        }

        It "Does not find SqlPackage.exe version 13 so returns latest" {
            ( Get-SqlPackagePath -Version 13 ) -like "*SqlPackage.exe" | Should -BeTrue;
        }

        It "Does not find SqlPackage.exe version 12 so returns latest" {
            ( Get-SqlPackagePath -Version 12 ) -like "*SqlPackage.exe" | Should -BeTrue;
        }

        It "Does not find SqlPackage.exe version 11 so returns latest" {
            ( Get-SqlPackagePath -Version 11 ) -like "*SqlPackage.exe" | Should -BeTrue;
        }

        It "Valid folder location and SqlPackage.exe present" {
            ResetEnv;
            $ExePath = Split-Path -Parent $PSScriptRoot;
            $ExePath = Resolve-Path "$ExePath\examples\ForTests\CustomSqlPackageInstallLocation";
            $env:CustomSqlPackageInstallLocation = $ExePath;
            ( Get-SqlPackagePath -Version 12 ) -like "*SqlPackage.exe" | Should -BeTrue;
        }        
        
        It "Finds SqlPackage.exe version 17 32-bit" {
            ( Get-SqlPackagePath -Version 17 -Use64BitPaths $false ) -like "*SqlPackage.exe" | Should -BeTrue;
        }

        It "Finds SqlPackage.exe version 16 32-bit" {
            ( Get-SqlPackagePath -Version 16 -Use64BitPaths $false ) -like "*SqlPackage.exe" | Should -BeTrue;
        }

        It "Finds SqlPackage.exe version 12 32-bit" {
            ( Get-SqlPackagePath -Version 12 -Use64BitPaths $false ) -like "*SqlPackage.exe" | Should -BeTrue;
        }
    }
}

AfterAll {
    Remove-Module -Name PublishDacPac;
}
 