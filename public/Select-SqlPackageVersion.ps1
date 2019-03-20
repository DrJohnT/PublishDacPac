function Select-SqlPackageVersion {
    <#
		.SYNOPSIS
		Selects a version of SqlPackage.exe to use
	#>
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $PreferredVersion
    )

    try {
        $specificVersion = $PreferredVersion -and $PreferredVersion -ne 'latest'
        $versions = '150', '140', '130', '120' | Where-Object { $_ -ne $PreferredVersion }

        # Look for a specific version of Microsoft SQL Server SqlPackage.exe
        if ($specificVersion) {
            if ((Get-SqlPackagePath -Version $PreferredVersion)) {
                return $PreferredVersion
            }

            Write-Information "Version '$PreferredVersion' not found. Looking for alternative version."
        }

        # Look for latest or a previous version.
        foreach ($version in $versions) {
            if ((Get-SqlPackagePath -Version $version)) {
                # Warn falling back.
                if ($specificVersion) {
                    $msg = "SQLPackage.exe version '{0}' not found. Using version '{1}'." -f $PreferredVersion, $version;
                    Write-Information $msg
                }

                return $version;
            }
        }

        # Warn not found.
        if ($specificVersion) {
            $msg = "SQLPackage.exe version '{0}' not found." -f $PreferredVersion;
            Write-Information $msg;
        }
        else {
            Write-Warning ("SQLPackage was not found on the build agent server. Try installing Microsoft SQL Server Data-Tier Application Framework");
            Write-Warning ("For install instructions, see https://www.microsoft.com/en-us/download/details.aspx?id=57784/");
        }
    }
    catch {
        Write-Error "Select-SqlPackageVersion failed with error $Error";
    }
}
