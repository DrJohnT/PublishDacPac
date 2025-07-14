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

Describe "Find-SqlPackageLocations" -Tag "Round1" {
    Context "Should return output" {
        It "Finds some version" {
            ( Find-SqlPackageLocations ) | Should -Not -Be $null
            $lines = Find-SqlPackageLocations | Measure-Object;
            $lines.Count | Should -Be 4;
        }
<#
        It "Valid folder location and SqlPackage.exe present" {
            ResetEnv;
            $ExePath = Split-Path -Parent $PSScriptRoot;
            $ExePath = Resolve-Path "$ExePath\examples\DeploymentWizard";
            $env:CustomAsDwInstallLocation = $ExePath;

            $lines = Find-SqlPackageLocations | Measure-Object;
            $lines.Count | Should -Be 6;
        }
#>        
    }
}

AfterAll {
    Remove-Module -Name PublishDacPac;
}