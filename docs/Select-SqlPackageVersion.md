---
external help file: PublishDacPac-help.xml
Module Name: PublishDacPac
online version: https://github.com/DrJohnT/PublishDacPac
schema: 2.0.0
---

# Select-SqlPackageVersion

## SYNOPSIS
Selects (finds) a specific version of SqlPackage.exe to use in subsequent commands.

## SYNTAX

```
Select-SqlPackageVersion [-PreferredVersion] <String> [<CommonParameters>]
```

## DESCRIPTION
Selects (finds) a specific version of SqlPackage.exe to use in subsequent commands.

Written by (c) Dr.
John Tunnicliffe, 2019 https://github.com/DrJohnT/PublishDacPac
This PowerShell script is released under the MIT license http://www.opensource.org/licenses/MIT

## EXAMPLES

### EXAMPLE 1
```
Select-SqlPackageVersion -PreferredVersion latest
```

Attempt to find latest version of SqlPackage.exe

### EXAMPLE 2
```
Select-SqlPackageVersion -PreferredVersion 130
```

Return the SQL Server 2016 version of SqlPackage.exe if it exists, otherwise return latest

## PARAMETERS

### -PreferredVersion
Defines the preferred version of SqlPackage.exe you wish to find. 
Use 'latest' for the latest version, or do not provide the parameter.

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

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Returns the version of SqlPackage.exe found.
## NOTES
This module requires SqlPackage.exe to be installed on the host machine.
This can be done by installing Microsoft SQL Server Management Studio from https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-2017

## RELATED LINKS
