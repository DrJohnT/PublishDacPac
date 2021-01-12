---
external help file: PublishDacPac-help.xml
Module Name: PublishDacPac
online version: https://github.com/DrJohnT/PublishDacPac
schema: 2.0.0
---

# Publish-DacPac

## SYNOPSIS
Publish-DacPac allows you to deploy a SQL Server Database using a DacPac to a SQL Server instance.

## SYNTAX

```
Publish-DacPac [-DacPacPath] <String> [-DacPublishProfile] <String> [-Server] <String> [[-Database] <String>]
 [[-SqlCmdVariables] <String[]>] [[-PreferredVersion] <String>] [[-DeployScriptPath] <String>]
 [[-DeployReportPath] <String>] [[-AuthenticationMethod] <String>] [[-AuthenticationUser] <String>]
 [[-AuthenticationPassword] <String>] [[-EncryptConnection] <Boolean>] [<CommonParameters>]
```

## DESCRIPTION
Publishes a SSDT DacPac using a specified DacPac publish profile from your solution.
Basically deploys the DacPac by invoking SqlPackage.exe using a DacPac Publish profile.
The SqlPackage.exe publish operation incrementally updates the schema of a target database to match the structure of a source database. 

Note that the XML of the DAC Publish Profile will updated with the Server, Database and SqlCmdVariables variables and a new file written to same folder as the DACPAC called
"$Database.deploy.publish.xml" where $Database is the value passed to the -Database parameter.

More information on SqlPackage.exe can be found here: https://docs.microsoft.com/en-us/sql/tools/sqlpackage/sqlpackage
This module requires SqlPackage.exe to be installed on the host machine.
See https://docs.microsoft.com/en-us/sql/tools/sqlpackage/sqlpackage-download

## EXAMPLES

### EXAMPLE 1
```
Publish-DacPac -Server 'YourDBServer' -Database 'NewDatabaseName' -DacPacPath 'C:\Dev\YourDB\bin\Debug\YourDB.dacpac' -DacPublishProfile 'YourDB.CI.publish.xml'
```

Publish your database to server 'YourDBServer' with the name 'NewDatabaseName', using the DACPAC 'C:\Dev\YourDB\bin\Debug\YourDB.dacpac' and the DAC Publish profile 'YourDB.CI.publish.xml'.

### EXAMPLE 2
```
Publish-DacPac -Server 'YourDBServer' -DacPacPath 'C:\Dev\YourDB\bin\Debug\YourDB.dacpac' -DacPublishProfile 'YourDB.CI.publish.xml'
```

Simplist form

### EXAMPLE 3
```
Publish-DacPac -Server 'YourDBServer' -DacPacPath 'C:\Dev\YourDB\bin\Debug\YourDB.dacpac' -DacPublishProfile 'YourDB.CI.publish.xml' -PreferredVersion 130;
```

Request a specific version of SqlPackage.exe

### EXAMPLE 4
```
[string[]]$SqlCmdVariables = @();
```

$SqlCmdVariables += "var1=varvalue1";
$SqlCmdVariables += "var2=varvalue2";
$SqlCmdVariables += "var3=varvalue3";
Publish-DacPac -Server 'YourDBServer' -DacPacPath 'C:\Dev\YourDB\bin\Debug\YourDB.dacpac' -DacPublishProfile 'YourDB.CI.publish.xml' -SqlCmdVariables $SqlCmdVariables;

Shows how to pass values to the -SqlCmdVariables parameter.
These will be written to the SqlCmdVariable section of the DAC publish profile.

## PARAMETERS

### -DacPacPath
Full path to your database DACPAC (e.g.
C:\Dev\YourDB\bin\Debug\YourDB.dacpac)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DacPublishProfile
Name of the DAC Publish Profile to be found in the same folder as your DACPAC (e.g.
YourDB.CI.publish.xml)
You can also provide the full path to an alternative DAC Publish Profile.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Server
Name of the target server, including instance and port if required. 
Note that this overwrites the server defined in
the DAC Publish Profile

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Database
Normally, the database will be named the same as your DACPAC.
However, by adding the -Database parameter, you can name the database anything you like.
Note that this overwrites the database name defined in the DAC Publish Profile.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SqlCmdVariables
A string array containing SqlCmd variables to be updated in the DAC Publish Profile.
These should be name/value pairs with no delimiters. 
For example:

    var1=varvalue1
    var2=varvalue2
    var3=varvalue3

The simplest way of creating this in PowerShell is

    \[string\[\]\]$SqlCmdVariables = @();
    $SqlCmdVariables += "var1=varvalue1";
    $SqlCmdVariables += "var2=varvalue2";
    $SqlCmdVariables += "var3=varvalue3";

And pass $SqlCmdVariables to the -SqlCmdVariables parameter.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PreferredVersion
Defines the preferred version of SqlPackage.exe you wish to use. 
Use 'latest' for the latest version, or do not provide the parameter at all.
Recommed you use the latest version of SqlPackage.exe as this will deploy to all previous version of SQL Server.

    latest = use the latest version of SqlPackage.exe
    15 = SQL Server 2019
    14 = SQL Server 2017
    13 = SQL Server 2016
    12 = SQL Server 2014
    11 = SQL Server 2012

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: Latest
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeployScriptPath
Specifies an optional file path to output the deployment script.
For Azure deployments, if there are T-SQL commands to create or modify the master database, a script will be written to the same path but with "Filename_Master.sql" as the output file name.
Note that providing the DeployScriptPath parameter will cause SqlPackage.exe to be called with the /Action:Script parameter and the database will NOT be deployed but scripted out.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeployReportPath
Specifies an optional file path to output the deployment report xml file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AuthenticationMethod
Indicates which method to use to connect to the target SQL Server instance in order to deploy the database DacPac.
Valid options are:

    windows - Windows authentication (default) will be used to deploy the DacPac to the target SQL Server instance
    sqlauth - SQL Server authentication will be used to deploy the DacPac to the target SQL Server instance either on-premise or in Azure

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: Windows
Accept pipeline input: False
Accept wildcard characters: False
```

### -AuthenticationUser
UserID for the AuthenticationUser
Only required if AuthenticationMethod = sqlauth

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AuthenticationPassword
Password for the AuthenticationUser
Only required if AuthenticationMethod = sqlauth

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EncryptConnection
Specifies if SQL encryption should be used for the target database connection.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Written by (c) Dr.
John Tunnicliffe, 2019-2021 https://github.com/DrJohnT/PublishDacPac
This PowerShell script is released under the MIT license http://www.opensource.org/licenses/MIT

## RELATED LINKS

[https://github.com/DrJohnT/PublishDacPac](https://github.com/DrJohnT/PublishDacPac)

