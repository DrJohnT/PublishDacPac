function Get-SqlPackagePath {
<#
    .SYNOPSIS
    Find path to specific version of SqlPackage.exe

    .DESCRIPTION
    Finds the path to specific version of SqlPackage.exe

    Checks the following locations: 
    
        ${env:ProgramFiles}\Microsoft SQL Server\*\DAC\bin
        ${env:ProgramFiles}\Microsoft SQL Server\*\Tools\Binn
        ${env:ProgramFiles(x86)}\Microsoft SQL Server\*\Tools\Binn
        ${env:ProgramFiles(x86)}\Microsoft SQL Server\*\DAC\bin
        ${env:ProgramFiles(x86)}\Microsoft Visual Studio *\Common7\IDE\Extensions\Microsoft\SQLDB\DAC
        ${env:ProgramFiles(x86)}\Microsoft Visual Studio\*\*\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\
        $env:CustomSqlPackageInstallLocation
    
    The environment variable $env:CustomSqlPackageInstallLocation allows you to specify your own custom install directory.

    For information on SqlPackage.exe see https://docs.microsoft.com/en-us/sql/tools/sqlpackage

    .PARAMETER Version
    Defines the specific version of SqlPackage.exe to which you wish to obtain the path.
    Valid values for -Version are:

        latest = use the latest version of SqlPackage.exe
        17 = SQL Server 2025
        16 = SQL Server 2022
        15 = SQL Server 2019
        14 = SQL Server 2017
        13 = SQL Server 2016
        12 = SQL Server 2014
        11 = SQL Server 2012

    If you are unsure which version(s) of SqlPackage.exe you have installed, use the function **Find-SqlPackageLocations** to obtain a full list.

    .OUTPUTS
    The full path to the specific version of SqlPackage.exe you requested

    .EXAMPLE
    Get-SqlPackagePath -Version 13

    Returns the path to the SQL Server 2016 version of SqlPackage.exe (if present on the machine).

    .EXAMPLE
    Get-SqlPackagePath -Version latest

    Return the full path to a latest version of SqlPackage.exe

    .LINK
    https://github.com/DrJohnT/PublishDacPac

    .NOTES
    Written by (c) Dr. John Tunnicliffe, 2019-2025 https://github.com/DrJohnT/PublishDacPac
    This PowerShell script is released under the MIT license http://www.opensource.org/licenses/MIT
    Install SqlPackage.exe from https://learn.microsoft.com/en-us/sql/tools/sqlpackage/sqlpackage
    SqlPackage.exe will also be installed with Visual Studio.
#>
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Version,

        [Parameter(Mandatory = $false)]
        [Boolean] $Use64BitPaths = $true
    )

    [string] $ExeName = "SqlPackage.exe";
    [string] $bitVersion = if ($Use64BitPaths) { "64-bit" } else { "32-bit" };

    $Version = $Version.Substring(0,2);
    [System.Management.Automation.PathInfo[]]$PathsToSearch = @(); 
    
    if ($Use64BitPaths) {
        $PathsToSearch += Resolve-Path -Path "${env:ProgramFiles}\Microsoft SQL Server\*\DAC\bin" -ErrorAction SilentlyContinue;
        $PathsToSearch += Resolve-Path -Path "${env:ProgramFiles}\Microsoft Visual Studio\*\*\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\" -ErrorAction SilentlyContinue;
        $PathsToSearch += Resolve-Path -Path "${env:USERPROFILE}\.dotnet\tools" -ErrorAction SilentlyContinue;
        $PathsToSearch += Resolve-Path -Path "${env:ProgramFiles}\Microsoft SQL Server\*\Tools\Binn" -ErrorAction SilentlyContinue;            
        
        # For those that install SQLPackage.exe in a completely different location, set environment variable CustomSqlPackageInstallLocation
        $CustomInstallLocation = [Environment]::GetEnvironmentVariable('CustomSqlPackageInstallLocation');
        if ("$CustomInstallLocation" -ne "") {
            if (Test-Path $CustomInstallLocation) {
                $PathsToSearch += Resolve-Path -Path "$CustomInstallLocation" -ErrorAction SilentlyContinue;
            }        
        }
    } else {
        $PathsToSearch += Resolve-Path -Path "${env:ProgramFiles(x86)}\Microsoft SQL Server\*\DAC\bin" -ErrorAction SilentlyContinue;
        $PathsToSearch += Resolve-Path -Path "${env:ProgramFiles(x86)}\Microsoft Visual Studio *\Common7\IDE\Extensions\Microsoft\SQLDB\DAC" -ErrorAction SilentlyContinue;
        $PathsToSearch += Resolve-Path -Path "${env:ProgramFiles(x86)}\Microsoft Visual Studio\*\*\Common7\IDE\Extensions\Microsoft\SQLDB\DAC" -ErrorAction SilentlyContinue;
        $PathsToSearch += Resolve-Path -Path "${env:ProgramFiles(x86)}\Microsoft SQL Server\*\Tools\Binn" -ErrorAction SilentlyContinue;       
    }

    Write-Verbose "Looking for $bitVersion SqlPackage.exe files in the following locations:`n$($PathsToSearch -join "`n")";

    $SqlPackageExes = @();
    foreach ($PathToSearch in $PathsToSearch) {
        $SqlPackageExes += Get-Childitem -Path $PathToSearch -Recurse -Include $ExeName -ErrorAction SilentlyContinue;           
    }
    
    # If we have no SqlPackage.exe files, then throw an error
    if ($SqlPackageExes.Count -eq 0) {
        Write-Error "No $bitVersion SqlPackage.exe files found in the following locations:`n$($PathsToSearch -join "`n")";
        return $null;
    }

  
    # Find the maximum version 
    $MaxVersionExe = $null;
    $MaxVersion = 0;
    foreach ($SqlPackageExe in $SqlPackageExes) {
        $ver = [int]$SqlPackageExe.VersionInfo.ProductVersion.Substring(0,2);
        if ($ver -gt $MaxVersion) {
            $MaxVersion = $ver
            $MaxVersionExe = $SqlPackageExe;
            Write-Verbose "Maximum version found so far: $MaxVersion";
        }
    }

    if ($Version -eq "la") {
        Write-Host "Latest $bitVersion $ExeName version $MaxVersion found here $($MaxVersionExe.FullName)";
        return $MaxVersionExe.FullName;
    }
   
    foreach ($SqlPackageExe in $SqlPackageExes) {
        [string] $ProductVersion = $SqlPackageExe.VersionInfo.ProductVersion.Substring(0,2);      
        
        if ($ProductVersion -eq $Version) {
            Write-Host "$bitVersion $ExeName version $Version found here: $($SqlPackageExe.FullName)";       
            return $SqlPackageExe.FullName;
        }            
    }

    Write-Host "$bitVersion version $Version not found so returning version $MaxVersion found here $($MaxVersionExe.FullName)";
    return $MaxVersionExe.FullName;
    
}


