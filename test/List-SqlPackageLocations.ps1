# Install SqlPackage.exe from https://learn.microsoft.com/en-us/sql/tools/sqlpackage/sqlpackage
    

    [string] $ExeName = "SqlPackage.exe";
    [string] $SqlPackageExePath = $null;
    [System.Management.Automation.PathInfo[]]$PathsToSearch; 
    # 64-bit paths
    $PathsToSearch += Resolve-Path -Path "${env:ProgramFiles}\Microsoft SQL Server\*\DAC\bin" -ErrorAction SilentlyContinue;
    $PathsToSearch += Resolve-Path -Path "${env:ProgramFiles}\Microsoft Visual Studio\*\*\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\" -ErrorAction SilentlyContinue;
    $PathsToSearch += Resolve-Path -Path "${env:USERPROFILE}\.dotnet\tools" -ErrorAction SilentlyContinue;    
    $PathsToSearch += Resolve-Path -Path "${env:ProgramFiles}\Microsoft SQL Server\*\Tools\Binn" -ErrorAction SilentlyContinue;
    # 32-bit paths
    $PathsToSearch += Resolve-Path -Path "${env:ProgramFiles(x86)}\Microsoft SQL Server\*\DAC\bin" -ErrorAction SilentlyContinue;
    $PathsToSearch += Resolve-Path -Path "${env:ProgramFiles(x86)}\Microsoft SQL Server\*\Tools\Binn" -ErrorAction SilentlyContinue;
    $PathsToSearch += Resolve-Path -Path "${env:ProgramFiles(x86)}\Microsoft Visual Studio *\Common7\IDE\Extensions\Microsoft\SQLDB\DAC" -ErrorAction SilentlyContinue;
    $PathsToSearch += Resolve-Path -Path "${env:ProgramFiles(x86)}\Microsoft Visual Studio\*\*\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\" -ErrorAction SilentlyContinue;    

    # For those that install SQLPackage.exe in a completely different location, set environment variable CustomSqlPackageInstallLocation
    $CustomInstallLocation = [Environment]::GetEnvironmentVariable('CustomSqlPackageInstallLocation');
    if ("$CustomInstallLocation" -ne "") {
        if (Test-Path $CustomInstallLocation) {
            $PathsToSearch += Resolve-Path -Path "$CustomInstallLocation\" -ErrorAction SilentlyContinue;
        }        
    }

    foreach ($PathToSearch in $PathsToSearch) {
        [System.IO.FileSystemInfo[]]$SqlPackageExes += Get-Childitem -Path $PathToSearch  -Recurse -Include $ExeName -ErrorAction SilentlyContinue;           
    }

    foreach ($SqlPackageExe in $SqlPackageExes) {
        $ExePath = $SqlPackageExe.FullName;

        [string] $ProductVersion = $SqlPackageExe.VersionInfo.ProductVersion.Substring(0,2);      
        
        $SqlPackageExePath = $ExePath;
        Write-Host "$ExeName version $ProductVersion found here: $SqlPackageExePath";       
      
    }
