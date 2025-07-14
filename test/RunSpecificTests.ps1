<#
$CurrentFolder = Split-Path -Parent $PSScriptRoot;
    $ModulePath = Resolve-Path "$CurrentFolder\PublishDacPac\PublishDacPac.psd1";
    Import-Module -Name $ModulePath;
    
$value = [Environment]::GetEnvironmentVariable("CustomSqlPackageInstallLocation");
        if ("$value" -ne "") {
            Clear-Item -Path Env:CustomSqlPackageInstallLocation;
        }

$output = Find-SqlPackageLocations
write-host $output

Remove-Module -Name PublishDacPac;
#>

Invoke-Pester -Tag "Round1";  # only one Round in these tests

#Invoke-Pester -Script .\AnalyzePSScripts.Tests.ps1
#Invoke-Pester -Script .\Find-SqlPackageLocations.Tests.ps1
#Invoke-Pester -Script .\Get-SqlPackagePath.Tests.ps1
#Invoke-Pester -Script .\Select-SqlPackageVersion.Tests.ps1

#Invoke-Pester -Script .\Publish-DacPac.Tests.ps1

#Invoke-Pester -Script .\Remove-Database.Tests.ps1





