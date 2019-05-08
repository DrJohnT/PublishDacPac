---
external help file: PublishDacPac-help.xml
Module Name: PublishDacPac
online version: https://github.com/DrJohnT/PublishDacPac
schema: 2.0.0
---

# Get-SqlPackagePath

## SYNOPSIS
Find path to specific version of SqlPackage.exe

## SYNTAX

```
Get-SqlPackagePath [-Version] <String> [<CommonParameters>]
```

## DESCRIPTION
Finds the path to specific version of SqlPackage.exe

Written by (c) Dr.
John Tunnicliffe, 2019 https://github.com/DrJohnT/PublishDacPac
This PowerShell script is released under the MIT license http://www.opensource.org/licenses/MIT

## EXAMPLES

### EXAMPLE 1
```
Get-SqlPackagePath -Version 130
```

Return the full path to a specific version of SqlPackage.exe

### EXAMPLE 2
```
Get-SqlPackagePath -Version latest
```

Return the full path to a latest version of SqlPackage.exe

## PARAMETERS

### -Version
Defines the specific version of SqlPackage.exe to which you wish to obtain the path
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

### The full path to the specific version of SqlPackage.exe you requested
## NOTES
This module requires SqlPackage.exe to be installed on the host machine.
This can be done by installing Microsoft SQL Server Management Studio from https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-2017

## RELATED LINKS
