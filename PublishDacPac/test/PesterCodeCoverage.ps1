
Invoke-Pester -Script .\test\Get-SqlPackagePath.Tests.ps1 -CodeCoverage .\public\Get-SqlPackagePath.ps1
Invoke-Pester -Script .\test\Select-SqlPackageVersion.Tests.ps1 -CodeCoverage .\public\Select-SqlPackageVersion.ps1
Invoke-Pester -Script .\test\Publish-DacPac.Tests.ps1 -CodeCoverage .\public\Publish-DacPac.ps1