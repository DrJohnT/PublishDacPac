function Publish-DacPac {
    <#
		.SYNOPSIS
        Publish-DacPac allows you to deploy a SQL Server Database using a DACPAC to a SQL Server instance.

		.DESCRIPTION
        Publishes a SSDT DacPac using a specified DacPac publish profile from your solution.
        Basically deploys the DACPAC by invoking SqlPackage.exe using a DacPac Publish profile

		Written by (c) Dr. John Tunnicliffe, 2019 https://github.com/DrJohnT/PublishDacPac
		This PowerShell script is released under the MIT license http://www.opensource.org/licenses/MIT

        .PARAMETER DacPacPath
        Full path to your database DACPAC (e.g. C:\Dev\YourDB\bin\Debug\YourDB.dacpac)

        .PARAMETER DacPublishProfile
        Name of the DAC Publish Profile to be found in the same folder as your DACPAC (e.g. YourDB.CI.publish.xml)
        You can also provide the full path to an alternative DAC Publish Profile.

        .PARAMETER TargetServerName
        Name of the target server, including instance and port if required.

        .PARAMETER TargetDatabaseName
        Normally, the database will be named the same as your DACPAC. However, by adding the -TargetDatabaseName parameter, you can name the database anything you like.

        .PARAMETER PreferredVersion
        Defines the preferred version of SqlPackage.exe you wish to use.  Use 'latest' for the latest version, or do not provide the parameter.

        .PARAMETER TestMode
        For use with Pester tests, this simply switches off the actual deployment of the database with SqlPackage.exe.

		.EXAMPLE
        Publish-DacPac -DacPacPath "C:\Dev\YourDB\bin\Debug\YourDB.dacpac" -DacPublishProfile "YourDB.CI.publish.xml" -TargetServerName "YourDBServer"
    #>

	[CmdletBinding()]
	param
	(
        [String] [Parameter(Mandatory = $true)]
        $DacPacPath,

        [String] [Parameter(Mandatory = $true)]
        $DacPublishProfile,

        [String] [Parameter(Mandatory = $true)]
        $TargetServerName,

        [String] [Parameter(Mandatory = $false)]
        $TargetDatabaseName,

        [String] [Parameter(Mandatory = $false)]
        $PreferredVersion,

        [Boolean] [Parameter(Mandatory = $false)]
        $TestMode
	)

	$global:ErrorActionPreference = 'Stop';

    try {
        # find the specific version of SqlPackage or the latest if not available
        $Version = Select-SqlPackageVersion -PreferredVersion $PreferredVersion;
        $SqlPackageExePath = Get-SqlPackagePath -Version $Version;

	    if (!(Test-Path -Path $SqlPackageExePath)) {
		    Write-Error "Could not find SqlPackage.exe in order to deploy the database DacPac!";
            Write-Warning "For install instructions, see https://www.microsoft.com/en-us/download/details.aspx?id=57784/";
            throw "Could not find SqlPackage.exe in order to deploy the database DacPac!";
	    }


        [String]$ProductVersion = (Get-Item $SqlPackageExePath).VersionInfo.ProductVersion;

	    if (!(Test-Path -Path $DacPacPath)) {
		    throw "DacPac path does not exist in $DacPacPath";
	    }

	    $DacPacName = Split-Path $DacPacPath -Leaf;
	    $OriginalDbName = $DacPacName -replace ".dacpac", ""
	    $DacPacFolder = Split-Path $DacPacPath -Parent;
	    if ($TargetDatabaseName -eq "") {
		    $TargetDatabaseName = $OriginalDbName;
	    }

        # figure out if we have a full path to the DAC Publish Profile or just the filename of the DAC Publish Profile in the same folder as the DACPAC
        if (Test-Path($DacPublishProfile)) {
            $DacPacPublishProfilePath = $DacPublishProfile;
        } else {
            try {
                $DacPacPublishProfilePath = Resolve-Path "$DacPacFolder\$DacPublishProfile";
            } catch {
                throw "DAC Publish Profile does not exist";
            }
        }

        $ProfileName = Split-Path $DacPacPublishProfilePath -Leaf;

        Write-Verbose "Publish-DacPac: Target database '$TargetDatabaseName'";
        Write-Verbose "Publish-DacPac: Target server '$TargetServerName'";
        Write-Verbose "Publish-DacPac: DacPac '$DacPacName' from '$DacPacFolder'";
        Write-Verbose "Publish-DacPac: Dac Profile '$ProfileName' from '$DacPacPublishProfilePath'";
        Write-Verbose "Publish-DacPac: SqlPackage.exe version $ProductVersion from '$SqlPackageExePath'";

		#Write-Verbose "Publish-DacPac: DacPacDacPublishProfileTemplate = $DacPacPublishProfilePath";

		[xml]$DacPacDacPublishProfile = [xml](Get-Content $DacPacPublishProfilePath);
		$DacPacDacPublishProfile.Project.PropertyGroup.TargetDatabaseName = "$TargetDatabaseName";
		$DacPacDacPublishProfile.Project.PropertyGroup.TargetConnectionString = "Data Source=$TargetServerName;Integrated Security=True";
		$DacPacUpdatedProfilePath = "$DacPacFolder\$OriginalDbName.deploy.publish.xml";
		$DacPacDacPublishProfile.Save($DacPacUpdatedProfilePath);


		$global:lastexitcode = 0;

        if (!(Ping-SqlServer -ServerName $TargetServerName)) {
            throw "Server '$TargetServerName' does not exist!";
        } else {
            #if ($global:Debug) {
            if ($TestMode) {
                Write-Information "In 'Don't Deploy' Mode, so will not deploy";
            } else {
                Write-Verbose "Publish-DacPac: Deploying database '$TargetDatabaseName' to server '$TargetServerName' using DacPac '$DacPacName'"
                #Write-Verbose "$SqlPackageExePath /Action:Publish /SourceFile:$DacPacPath /Profile:$DacPacUpdatedProfilePath";

                &"$SqlPackageExePath" /Action:Publish /SourceFile:"$DacPacPath" /Profile:"$DacPacUpdatedProfilePath"
                if ($lastexitcode -ne 0) {
                    Write-Error "Error executing $SqlPackageExePath deployment";
                }
            }
        }
    } catch {
        Write-Error "Error: $_";
    }
}
