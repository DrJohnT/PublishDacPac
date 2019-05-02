---
external help file: PublishDacPac-help.xml
Module Name: PublishDacPac
online version:
schema: 2.0.0
---

# Publish-DacPac

## SYNOPSIS
Publish-DacPac allows you to deploy a SQL Server Database using a DACPAC to a SQL Server instance.

## SYNTAX

```
Publish-DacPac [-DacPacPath] <String> [-DacPublishProfile] <String> [-Server] <String> [[-Database] <String>]
 [[-PreferredVersion] <String>] [<CommonParameters>]
```

## DESCRIPTION
Publishes a SSDT DacPac using a specified DacPac publish profile from your solution.
Basically deploys the DACPAC by invoking SqlPackage.exe using a DacPac Publish profile

This module requires SqlPackage.exe to be installed on the host machine. 
This can be done by installing
Microsoft SQL Server Management Studio from https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-2017

Written by (c) Dr.
John Tunnicliffe, 2019 https://github.com/DrJohnT/PublishDacPac
This PowerShell script is released under the MIT license http://www.opensource.org/licenses/MIT

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
Publish-DacPac -Server 'YourDBServer' -DacPacPath 'C:\Dev\YourDB\bin\Debug\YourDB.dacpac' -DacPublishProfile 'YourDB.CI.publish.xml' -PreferredVersion 130
```

Request a specific version of SqlPackage.exe

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

### -PreferredVersion
Defines the preferred version of SqlPackage.exe you wish to use. 
Use 'latest' for the latest version, or do not provide the parameter at all.
Recommed you use the latest version of SqlPackage.exe as this will deploy to all previous version of SQL Server.

    latest = use the latest version of SqlPackage.exe
    150 = SQL Server 2019
    140 = SQL Server 2017
    130 = SQL Server 2016
    120 = SQL Server 2014
    110 = SQL Server 2012

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: Latest
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
This module requires SqlPackage.exe to be installed on the host machine.
This can be done by installing Microsoft SQL Server Management Studio from https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-2017

## RELATED LINKS
