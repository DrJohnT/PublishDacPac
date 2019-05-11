[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/PublishDacPac.svg)](https://www.powershellgallery.com/packages/PublishDacPac)
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

## Installation

Install from the PowerShell gallery using:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ powershell
Install-Module -Name PublishDacPac
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## List of commands

The following is a list of commands provided by this module once you
follow the steps in Installation.

Click the link below for full documentation of each function.

| **Function**              | **Description**                                                             |
|--------------------------|-----------------------------------------------------------------------------|
| [Find-SqlPackageLocations](https://github.com/DrJohnT/PublishDacPac/blob/master/docs/Find-SqlPackageLocations.md) | Lists all locations of SQLPackage.exe files on the machine              |
| [Get-SqlDatabasePath](https://github.com/DrJohnT/PublishDacPac/blob/master/docs/Get-SqlDatabasePath.md) | Returns the path to a specific SQL database in the form: SQLSERVER:\SQL\YourServer\DEFAULT\Databases\YourSQLDatabase |
| [Get-SqlPackagePath](https://github.com/DrJohnT/PublishDacPac/blob/master/docs/Get-SqlPackagePath.md) | Returns the path of a specific version of SqlPackage.exe |
| [Invoke-ExternalCommand](https://github.com/DrJohnT/PublishDacPac/blob/master/docs/Invoke-ExternalCommand.md) | Invokes (executes) an external executable via the command-line |
| [Ping-SqlDatabase](https://github.com/DrJohnT/PublishDacPac/blob/master/docs/Ping-SqlDatabase.md) | Checks if a database exists on a SQL Server |
| [Ping-SqlServer](https://github.com/DrJohnT/PublishDacPac/blob/master/docs/Ping-SqlServer.md) | Checks if a specific SQL Server instance is available |
| [Publish-DacPac](https://github.com/DrJohnT/PublishDacPac/blob/master/docs/Publish-DacPac.md) | Publishes a DACPAC using a [DAC Publish Profile](https://github.com/DrJohnT/PublishDacPac/wiki/DAC-Publish-Profile)  |
| [Select-SqlPackageVersion](https://github.com/DrJohnT/PublishDacPac/blob/master/docs/Select-SqlPackageVersion.md) | Finds a specific version of SqlPackage.exe |

## Usage

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ powershell
Publish-DacPac -DacPacPath "C:\Dev\YourDB\bin\Debug\YourDB.dacpac" -DacPublishProfile "YourDB.CI.publish.xml" -Server "YourDBServer"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Where -DacPacPath is the path to your database DACPAC, -DacPublishProfile is the name of the [DAC Publish Profile](https://github.com/DrJohnT/PublishDacPac/wiki/DAC-Publish-Profile) to be found in the same folder as your DACPAC, and -Server is the name of the target server (including instance and port if required).  The above is the minimum set of parameters that can be used with **Publish-DacPac**.

Normally, the database will be named the same as your DACPAC (i.e. YourDB in the example above).  However, by adding the -Database parameter, you can name the database anything you like.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ powershell
Publish-DacPac -DacPacPath "C:\Dev\YourDB\bin\Debug\YourDB.dacpac" -DacPublishProfile "YourDB.CI.publish.xml" -Server "YourDBServer" -Database "YourNewNameDB"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can also provide the full path to an alternative [DAC Publish Profile](https://github.com/DrJohnT/PublishDacPac/wiki/DAC-Publish-Profile).

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ powershell
Publish-DacPac -DacPacPath "C:\Dev\YourDB\bin\Debug\YourDB.dacpac" -DacPublishProfile "C:\Dev\YourDB\bin\Debug\YourDB.CI.publish.xml" -Server "YourDBServer"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Pre-requisites

The following pre-requisites need to be installed for **Publish-DacPac** to work properly.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ powershell
SqlPackage.exe
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

[SqlPackage.exe](https://docs.microsoft.com/en-us/sql/tools/sqlpackage) can be installed by installing:

* [Microsoft® SQL Server® Data-Tier Application Framework](https://docs.microsoft.com/en-us/sql/tools/sqlpackage-download)

* Visual Studio 2012 or later

Note that the latest [SQLPackage.exe](https://docs.microsoft.com/en-us/sql/tools/sqlpackage-download) provides support for all previous versions of SQL Server.

## Azure DevOps Extension

**Publish-DacPac** has been published as an Azure DevOps extension called [Publish DACPAC using a DAC Publish Profile](https://marketplace.visualstudio.com/items?itemName=DrJohnExtensions.PublishDacPac) to enable Continuous Deployment scenarios.

### Octopus Deploy /

## Example SSDT DACPAC

An example SSDT Visual Studio solution and the associated DACPAC is provided in the .\examples folder.  You can use this to test that deployments work correctly.  Note that the SSDT Visual Studio solution is configured to deploy to SQL Server 2016.  Open the Visual Studio solution and change the target version and rebuild the solution if you have a different version of SQL Server installed.

### Issue Reporting

If you are facing problems in making this PowerShell module work, please report any
problems on [PublishDacPac GitHub Project
Page](https://github.com/DrJohnT/PublishDacPac/issues).
