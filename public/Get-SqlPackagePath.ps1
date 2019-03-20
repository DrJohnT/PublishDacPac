function Get-SqlPackagePath {
    <#
		.SYNOPSIS
		Find path to specific version of SqlPackage.exe
	#>
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Version
    )

    try {
        # always return x64 version if present
        $SqlPackageExes = Get-Childitem -Path "${env:ProgramFiles}\Microsoft SQL Server\$Version" -Recurse -Include "SqlPackage.exe" -ErrorAction SilentlyContinue;
        foreach ($SqlPackageExe in $SqlPackageExes) {
            $SqlPackageExePath = $SqlPackageExe.FullName;
            $ProductVersion = $SqlPackageExe.VersionInfo | Select-Object ProductVersion;
            break;
        }

        if (!($SqlPackageExePath)) {
            # try to find x86 version
            $SqlPackageExes = Get-Childitem -Path "${env:ProgramFiles(x86)}\Microsoft SQL Server\$Version" -Recurse -Include "SqlPackage.exe" -ErrorAction SilentlyContinue;

            foreach ($SqlPackageExe in $SqlPackageExes) {
                $SqlPackageExePath = $SqlPackageExe.FullName;
                $ProductVersion = $SqlPackageExe.VersionInfo | Select-Object ProductVersion;
                break;
            }
        }

        if (!($SqlPackageExePath)) {
            $VsPaths = Resolve-Path "${env:ProgramFiles(x86)}\Microsoft Visual Studio\*\*\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\$Version";
            foreach ($VsPath in $VsPaths) {
                $SqlPackageExes = Get-Childitem -Path $VsPath -Recurse -Include "SqlPackage.exe" -ErrorAction SilentlyContinue;
                foreach ($SqlPackageExe in $SqlPackageExes) {
                    $SqlPackageExePath = $SqlPackageExe.FullName;
                    $ProductVersion = $SqlPackageExe.VersionInfo | Select-Object ProductVersion;

                    break;
                    break;
                }
            }
        }

        if (!($SqlPackageExePath)) {
            $VsPaths = Resolve-Path "${env:ProgramFiles(x86)}\Microsoft Visual Studio*\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\$Version";

            foreach ($VsPath in $VsPaths) {
                $SqlPackageExes = Get-Childitem -Path $VsPath -Recurse -Include "SqlPackage.exe" -ErrorAction SilentlyContinue;
                foreach ($SqlPackageExe in $SqlPackageExes) {
                    $SqlPackageExePath = $SqlPackageExe.FullName;
                    $ProductVersion = $SqlPackageExe.VersionInfo | Select-Object ProductVersion;
                    break;
                    break;
                }
            }
        }

        Write-Verbose "SqlPackage $ProductVersion found here $SqlPackageExePath";
    }
    catch {
        Write-Error "Get-SqlPackagePath failed with error $Error";
    }
    return $SqlPackageExePath;
}


