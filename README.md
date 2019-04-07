[![Build Status](https://qatar-re.visualstudio.com/QatarRe.BI/_apis/build/status/Test%20and%20Publish%20Package%20PublishDacPac?branchName=master)](https://qatar-re.visualstudio.com/QatarRe.BI/_build/latest?definitionId=51&branchName=master)

### PublishDacPac

# Deploy a SQL Database DACPAC using a DAC Publish Profile

## Overview

**Publish-DacPac** allows you to deploy a SQL Server Database DACPAC to a SQL Server instance using a DAC Publish Profile.

SSDT (SQL Server Data Tools) is Microsoft's tool to design (declare) the entire database model including tables, views, stored procedures, functions, schemas, etc. etc. etc.  SSDT covering **all** aspects of a database design.

SSDT is now fully integrated into Visual Studio.  When you perform a **build** of a SSDT Visual Studio project, it creates a [DACPAC](https://msdn.microsoft.com/en-IN/library/ee210546.aspx) which defines all of the SQL Server objects - like tables, views, and instance objects, including logins - associated with a database.

**Publish-DacPac** simplifies the use of [SqlPackage.exe](https://docs.microsoft.com/en-us/sql/tools/sqlpackage) to deploy a [DACPAC](https://msdn.microsoft.com/en-IN/library/ee210546.aspx) by using a **DAC Publish Profile** which provides for fine-grained control over the database creation and upgrades, including upgrades for schema, triggers, stored
procedures, roles, users, extended properties etc. Using a DAC Publish Profile, multiple different properties can be set to ensure that the database is created or upgraded properly.

**Publish-DacPac** compares the content of a DACPAC to the database already on the target server and generates a deployment script.  You can tailor how publish works using a DAC Publish Profile.

**Publish-DacPac** can be used to automate the deployment of databases, either as part of a build in Azure DevOps, or part of a server deployment using Octopus Deploy or Azure DevOps Release Manager.

To automate build and deployment of databases in Azure DevOps, you can use MsBuild to create DACPAC from your Visual Studio solution.  You can then add a PowerShell task which uses **Publish-DacPac** to invoke SQLPackage.exe to deploy each DACPAC using your own custom DAC Publish Profile.

[DAC Publish Profiles](https://github.com/DrJohnT/PublishDacPac/wiki/DAC-Publish-Profile) are created in Visual Studio when you Publish a database.

## Install

Install from PowerShell gallery using:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ powershell
Install-Module -Name PublishDacPac
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Usage

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ powershell
Publish-DacPac -DacPacPath "C:\Dev\YourDB\bin\Debug\YourDB.dacpac" -DacPublishProfile "YourDB.CI.publish.xml" -TargetServerName "YourDBServer"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Where -DacPacPath is the path to your database DACPAC, -DacPublishProfile is the name of the [DAC Publish Profile](https://github.com/DrJohnT/PublishDacPac/wiki/DAC-Publish-Profile) to be found in the same folder as your DACPAC, and -TargetServerName is the name of the target server (including instance and port if required).  The above is the minimum set of parameters that can be used with **Publish-DacPac**.

Normally, the database will be named the same as your DACPAC (i.e. YourDB in the example above).  However, by adding the -TargetDatabaseName parameter, you can name the database anything you like.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ powershell
Publish-DacPac -DacPacPath "C:\Dev\YourDB\bin\Debug\YourDB.dacpac" -DacPublishProfile "YourDB.CI.publish.xml" -TargetServerName "YourDBServer" -TargetDatabaseName "YourNewNameDB"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can also provide the full path to an alternative [DAC Publish Profile](https://github.com/DrJohnT/PublishDacPac/wiki/DAC-Publish-Profile).

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ powershell
Publish-DacPac -DacPacPath "C:\Dev\YourDB\bin\Debug\YourDB.dacpac" -DacPublishProfile "C:\Dev\YourDB\bin\Debug\YourDB.CI.publish.xml" -TargetServerName "YourDBServer"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Finnally, if there are multiple versions of SqlPackage.exe installed on your build agent, you can specify which version should be used with the  -PreferredVersion option.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ powershell
Publish-DacPac -DacPacPath "C:\Dev\YourDB\bin\Debug\YourDB.dacpac" -DacPublishProfile "C:\Dev\YourDB\bin\Debug\YourDB.CI.publish.xml" -TargetServerName "YourDBServer" -PreferredVersion latest
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Valid values for -PreferredVersion are:

|Version|SQL Server Release|
|-------|------------------|
|latest|Latest SQL Server version found on agent|
|150|SQL Server 2019|
|140|SQL Server 2017|
|130|SQL Server 2016|
|120|SQL Server 2014|


## List of commands

The following is a list of commands provided by this module once you
follow the steps in Installation

| **Function**              | **Description**                                                             |
|--------------------------|-----------------------------------------------------------------------------|
| Publish-DacPac           | Publishes a DACPAC using a [DAC Publish Profile](https://github.com/DrJohnT/PublishDacPac/wiki/DAC-Publish-Profile)  |
| Select-SqlPackageVersion | Finds a specific version of SqlPackage.exe               |
| Get-SqlPackagePath       | Returns the path of a specific version of SqlPackage.exe |
| Ping-SqlServer           | Checks if a specific SQL Server instance is available             |
| Ping-SqlDatabase         | Checks if a database exists on a SQL Server              |
| Find-SqlPackageLocations | Lists all locations of SQLPackage.exe files on the machine              |



## Pre-requisites

The following pre-requisites need to be installed for **Publish-DacPac** to work properly.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ powershell
SqlPackage.exe
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

[SqlPackage.exe](https://docs.microsoft.com/en-us/sql/tools/sqlpackage) is installed when you install Visual Studio or SQL Server.  You can also install SqlPackage.exe using a dedicated installer as outlined below.

## Azure DevOps Agent

**Publish-DacPac** can be run on an in-house hosted Azure DevOps agent when once [SqlPackage.exe](https://docs.microsoft.com/en-us/sql/tools/sqlpackage) is installed:

* By installing SQL Server 2012 or later

* By installing Visual Studio 2012 or later

* By installing the [Microsoft® SQL Server® Data-Tier Application Framework](https://docs.microsoft.com/en-us/sql/tools/sqlpackage-download)

Be aware that it is best to install the latest
[SQLPackage.exe](https://docs.microsoft.com/en-us/sql/tools/sqlpackage-download)
as this provides support for all previous versions of SQL Server as well as the forthcoming SQL Server 2019.

## Example SSDT DACPAC

An example SSDT Visual Studio solution and the associated DACPAC is provided in the .\media folder.  You can use this to test that deployments work correctly.  Note that the SSDT Visual Studio solution is configured to deploy to SQL Server 2016.  Open the Visual Studio solution and change the target version and rebuild the solution if you have a different version of SQL Server installed.

### Issue Reporting

If you are facing problems in making this PowerShell module work, please report any
problems on [PublishDacPac GitHub Project
Page](https://github.com/DrJohnT/PublishDacPac/issues).
