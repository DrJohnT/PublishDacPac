﻿function Publish-DacPac {
<#
    .SYNOPSIS
    Publish-DacPac allows you to deploy a SQL Server Database using a DacPac to a SQL Server instance.

    .DESCRIPTION
    Publishes a SSDT DacPac using a specified DacPac publish profile from your solution.
    Basically deploys the DacPac by invoking SqlPackage.exe using a DacPac Publish profile.
    The SqlPackage.exe publish operation incrementally updates the schema of a target database to match the structure of a source database. 

    Note that the XML of the DAC Publish Profile will updated with the Server, Database and SqlCmdVariables variables and a new file written to same folder as the DACPAC called
    "$Database.deploy.publish.xml" where $Database is the value passed to the -Database parameter.

    More information on SqlPackage.exe can be found here: https://docs.microsoft.com/en-us/sql/tools/sqlpackage/sqlpackage
    This module requires SqlPackage.exe to be installed on the host machine. See https://docs.microsoft.com/en-us/sql/tools/sqlpackage/sqlpackage-download

    .PARAMETER DacPacPath
    Full path to your database DACPAC (e.g. C:\Dev\YourDB\bin\Debug\YourDB.dacpac)

    .PARAMETER DacPublishProfile
    Name of the DAC Publish Profile to be found in the same folder as your DACPAC (e.g. YourDB.CI.publish.xml)
    You can also provide the full path to an alternative DAC Publish Profile.

    .PARAMETER Server
    Name of the target server, including instance and port if required.  Note that this overwrites the server defined in
    the DAC Publish Profile

    .PARAMETER Database
    Normally, the database will be named the same as your DACPAC. However, by adding the -Database parameter, you can name the database anything you like.
    Note that this overwrites the database name defined in the DAC Publish Profile.

    .PARAMETER SqlCmdVariables
    A string array containing SqlCmd variables to be updated in the DAC Publish Profile. These should be name/value pairs with no delimiters.  For example:

        var1=varvalue1
        var2=varvalue2
        var3=varvalue3

    The simplest way of creating this in PowerShell is

        [string[]]$SqlCmdVariables = @();
        $SqlCmdVariables += "var1=varvalue1";
        $SqlCmdVariables += "var2=varvalue2";
        $SqlCmdVariables += "var3=varvalue3";
    
    And pass $SqlCmdVariables to the -SqlCmdVariables parameter.

    .PARAMETER PreferredVersion
    Defines the preferred version of SqlPackage.exe you wish to use.  Use 'latest' for the latest version, or do not provide the parameter at all.
    Recommed you use the latest version of SqlPackage.exe as this will deploy to all previous version of SQL Server.

        latest = use the latest version of SqlPackage.exe
        16 = SQL Server 2022
        15 = SQL Server 2019
        14 = SQL Server 2017
        13 = SQL Server 2016
        12 = SQL Server 2014
        11 = SQL Server 2012

    .PARAMETER DeployScriptPath
    Specifies an optional file path to output the deployment script. For Azure deployments, if there are T-SQL commands to create or modify the master database, a script will be written to the same path but with "Filename_Master.sql" as the output file name.
    Note that providing the DeployScriptPath parameter will cause SqlPackage.exe to be called with the /Action:Script parameter and the database will NOT be deployed but scripted out.

    .PARAMETER DeployReportPath
    Specifies an optional file path to output the deployment report xml file.

    .PARAMETER AuthenticationMethod
    Indicates which method to use to connect to the target SQL Server instance in order to deploy the database DacPac.
    Valid options are:

        windows - Windows authentication (default) will be used to deploy the DacPac to the target SQL Server instance
        sqlauth - SQL Server authentication will be used to deploy the DacPac to the target SQL Server instance either on-premise or in Azure

    .PARAMETER AuthenticationUser
    UserID for the AuthenticationUser
    Only required if AuthenticationMethod = sqlauth
    
    .PARAMETER AuthenticationPassword
    Password for the AuthenticationUser
    Only required if AuthenticationMethod = sqlauth

    .PARAMETER EncryptConnection
    Specifies if SQL encryption should be used for the target database connection.

    .EXAMPLE
    Publish-DacPac -Server 'YourDBServer' -Database 'NewDatabaseName' -DacPacPath 'C:\Dev\YourDB\bin\Debug\YourDB.dacpac' -DacPublishProfile 'YourDB.CI.publish.xml'

    Publish your database to server 'YourDBServer' with the name 'NewDatabaseName', using the DACPAC 'C:\Dev\YourDB\bin\Debug\YourDB.dacpac' and the DAC Publish profile 'YourDB.CI.publish.xml'.

    .EXAMPLE
    Publish-DacPac -Server 'YourDBServer' -DacPacPath 'C:\Dev\YourDB\bin\Debug\YourDB.dacpac' -DacPublishProfile 'YourDB.CI.publish.xml'

    Simplist form

    .EXAMPLE
    Publish-DacPac -Server 'YourDBServer' -DacPacPath 'C:\Dev\YourDB\bin\Debug\YourDB.dacpac' -DacPublishProfile 'YourDB.CI.publish.xml' -PreferredVersion 130;

    Request a specific version of SqlPackage.exe

    .EXAMPLE
    [string[]]$SqlCmdVariables = @();
    $SqlCmdVariables += "var1=varvalue1";
    $SqlCmdVariables += "var2=varvalue2";
    $SqlCmdVariables += "var3=varvalue3";
    Publish-DacPac -Server 'YourDBServer' -DacPacPath 'C:\Dev\YourDB\bin\Debug\YourDB.dacpac' -DacPublishProfile 'YourDB.CI.publish.xml' -SqlCmdVariables $SqlCmdVariables;

    Shows how to pass values to the -SqlCmdVariables parameter. These will be written to the SqlCmdVariable section of the DAC publish profile.
    
    .LINK
    https://github.com/DrJohnT/PublishDacPac

	.NOTES
    Written by (c) Dr. John Tunnicliffe, 2019-2021 https://github.com/DrJohnT/PublishDacPac
    This PowerShell script is released under the MIT license http://www.opensource.org/licenses/MIT

#>

	[CmdletBinding()]
	param
	(
        [String] [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $DacPacPath,

        [String] [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $DacPublishProfile,

        [String] [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Server,

        [String] [Parameter(Mandatory = $false)]
        $Database,

        [String[]] [Parameter(Mandatory = $false)]
        $SqlCmdVariables,

        [String] [Parameter(Mandatory = $false)]
        [ValidateSet('150', '140', '130', '120', '110', '16', '15', '14', '13', '12', '11', 'latest')]
        $PreferredVersion = 'latest',

        [String] [Parameter(Mandatory = $false)]        
        $DeployScriptPath,

        [String] [Parameter(Mandatory = $false)]
        $DeployReportPath,

        [String] [Parameter(Mandatory = $false)]
        [ValidateSet('windows', 'sqlauth')]
        $AuthenticationMethod = 'windows',

        [String] [Parameter(Mandatory = $false)]
        $AuthenticationUser,

        [String] [Parameter(Mandatory = $false)]
        $AuthenticationPassword,

        [bool] [Parameter(Mandatory = $false)]
        $EncryptConnection = $false
	)

	$global:ErrorActionPreference = 'Stop';

    try {
        if ([string]::IsNullOrEmpty($PreferredVersion)) {
            $PreferredVersion = 'latest';
        }
        # find the specific version of SqlPackage or the latest if not available
        $Version = Select-SqlPackageVersion -PreferredVersion $PreferredVersion;
        $SqlPackageExePath = Get-SqlPackagePath -Version $Version;

	    if (!(Test-Path -Path $SqlPackageExePath)) {
		    Write-Error "Could not find SqlPackage.exe in order to deploy the database DacPac!";
            Write-Warning "For install instructions, see https://docs.microsoft.com/en-us/sql/tools/sqlpackage/sqlpackage-download/";
            throw "Could not find SqlPackage.exe in order to deploy the database DacPac!";
	    }


        [String]$ProductVersion = (Get-Item $SqlPackageExePath).VersionInfo.ProductVersion;

	    if (!(Test-Path -Path $DacPacPath)) {
		    throw "DacPac path does not exist in $DacPacPath";
	    }

	    $DacPacName = Split-Path $DacPacPath -Leaf;
	    $OriginalDbName = $DacPacName -replace ".dacpac", ""
	    $DacPacFolder = Split-Path $DacPacPath -Parent;
        if ([string]::IsNullOrEmpty($Database)) {
		    $Database = $OriginalDbName;
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

        Write-Output "Publish-DacPac resolved the following parameters:";
        Write-Output "DacPacPath                  : $DacPacName from $DacPacFolder";
        Write-Output "DacPublishProfile           : $ProfileName from $DacPacPublishProfilePath";
        Write-Output "Server                      : $Server";
        Write-Output "Database                    : $Database";
        Write-Output "SqlPackage.exe              : $Version (v$ProductVersion) from $SqlPackageExePath";

        [xml]$DacPacDacPublishProfile = [xml](Get-Content $DacPacPublishProfilePath);

        # update the database name and deployment server connection string in the DAC Publish Profile
        $DacPacDacPublishProfile.Project.PropertyGroup.TargetDatabaseName = $Database;
        $ExistingConnectionString = $DacPacDacPublishProfile.Project.PropertyGroup.TargetConnectionString
        $ConnBuilder = New-Object System.Data.OleDb.OleDbConnectionStringBuilder($ExistingConnectionString);
        $ConnBuilder["Data Source"] = $Server;
        $DacPacDacPublishProfile.Project.PropertyGroup.TargetConnectionString = $ConnBuilder.ConnectionString;

        # update the SqlCmdVariables (if any)
        if ($SqlCmdVariables.Count -gt 0) {
            $namesp = 'http://schemas.microsoft.com/developer/msbuild/2003';
            [System.Xml.XmlNamespaceManager] $nsmgr = $DacPacDacPublishProfile.NameTable;
            $nsmgr.AddNamespace('n', $namesp);

            <#
                # adding new nodes it not a good idea as they come up as warnings during deployment
                $ItemNode = $DacPacDacPublishProfile.SelectSingleNode('//n:ItemGroup', $nsmgr);
                if ($null -eq $ItemNode) {
                    Write-Information 'Creating ItemGroup to contain SqlCmdVariables';
                    $NewElement = $DacPacDacPublishProfile.CreateNode('element', 'ItemGroup', $namesp);
                    $ItemNode = $DacPacDacPublishProfile.DocumentElement.AppendChild($NewElement);
                }
            #>
            foreach ($SqlCmdVariable in $SqlCmdVariables) {
                [string[]]$NameValuePair = $SqlCmdVariable -split "=" | ForEach-Object { $_.trim() }
                $name = $NameValuePair[0];
                $value = $NameValuePair[1];

                # find the matching node (if any)
                $SqlCmdVariableNode = $DacPacDacPublishProfile.SelectNodes('//n:ItemGroup/n:SqlCmdVariable', $nsmgr) | Where-Object { ($_.Include -eq $name) };

                if ($null -eq $SqlCmdVariableNode) {
                    <#
                        # adding new nodes it not a good idea as they come up as warnings during deployment
                        # note missing, so create it
                        Write-Output "Adding SqlCmdVariable   name: $name  value: $value";
                        $NewSqlCmdVariableElement = $DacPacDacPublishProfile.CreateNode('element', 'SqlCmdVariable', $namesp);
                        $IncludeAttr = $DacPacDacPublishProfile.CreateAttribute('Include');
                        $IncludeAttr.Value = $name;
                        $NewSqlCmdVariableElement.Attributes.Append($IncludeAttr) | Out-Null; # do this to stop write to std output
                        $ItemNode.AppendChild($NewSqlCmdVariableElement) | Out-Null; # do this to stop write to std output
                        # add inner Value element
                        $NewValueElement = $DacPacDacPublishProfile.CreateNode('element', 'Value', $namesp);
                        $NewValueElement.InnerText = $value;
                        $NewSqlCmdVariableElement.AppendChild($NewValueElement) | Out-Null; # do this to stop write to std output

                    #>
                    Write-Warning "SqlCmdVariable '$name' was not found in DAC publish profile";
                } else {
                    # node present, so update it
                    Write-Output "Updating SqlCmdVariable name: $name  value: $value";
                    $SqlCmdVariableNode.Value = $value;
                }
            }
        }
        $DacPacUpdatedProfilePath = "$DacPacFolder\$Database.deploy.publish.xml";
        $DacPacDacPublishProfile.Save($DacPacUpdatedProfilePath);
        Write-Output "Updated DacPublishProfile   : $DacPacUpdatedProfilePath";

        Write-Output "Following output generated by SqlPackage.exe";
        Write-Output "==============================================================================";

		$global:lastexitcode = 0;

        $ArgList = @(
            "/SourceFile:$DacPacPath",
            "/Profile:$DacPacUpdatedProfilePath",
            "/Diagnostics:true"
        );
        if ("$DeployScriptPath" -eq "") {
            $ArgList += "/Action:Publish";
            Write-Verbose "Publish-DacPac: Deploying database '$Database' to server '$Server' using DacPac '$DacPacName'"
        } else {
            $ArgList += "/Action:Script";
            $ArgList += "/DeployScriptPath:$DeployScriptPath";
            Write-Verbose "Publish-DacPac: Scripting database '$Database' for deployment to server '$Server' using DacPac '$DacPacName'"
        }
        if ("$DeployReportPath" -ne "") {
            $ArgList += "/DeployReportPath:$DeployReportPath";
        }
        if ($AuthenticationMethod -eq "sqlauth") { 
            # For SQL Server Auth scenarios, defines the SQL Server user/password to use to access the target database instance.
            $ArgList += "/TargetUser:$AuthenticationUser";
            $ArgList += "/TargetPassword:$AuthenticationPassword";            
        }
        if ($EncryptConnection) {
            $ArgList += "/TargetEncryptConnection:true";
        }

        Invoke-ExternalCommand -Command "$SqlPackageExePath" -Arguments $ArgList;
        
    } catch {
        Write-Error "Publish-DacPac Error: $_";
    }
}
