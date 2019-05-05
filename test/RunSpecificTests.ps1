#$BootStrapPath = Join-Path -Path $PSScriptRoot -ChildPath '.\bootstrap.ps1' -Resolve;

#. $BootStrapPath;

#Invoke-Pester -Script .\AnalyzePSScripts.Tests.ps1
#Invoke-Pester -Script .\Get-SqlPackagePath.Tests.ps1
#Invoke-Pester -Script .\Select-SqlPackageVersion.Tests.ps1
#Invoke-Pester -Script .\Ping-SqlServer.Tests.ps1
#Invoke-Pester -Script .\Ping-SqlDatabase.Tests.ps1
Invoke-Pester -Script .\Publish-DacPac.Tests.ps1
