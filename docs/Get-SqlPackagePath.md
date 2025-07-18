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

Checks the following locations: 

    ${env:ProgramFiles}\Microsoft SQL Server\*\DAC\bin
    ${env:ProgramFiles}\Microsoft SQL Server\*\Tools\Binn
    ${env:ProgramFiles(x86)}\Microsoft SQL Server\*\Tools\Binn
    ${env:ProgramFiles(x86)}\Microsoft SQL Server\*\DAC\bin
    ${env:ProgramFiles(x86)}\Microsoft Visual Studio *\Common7\IDE\Extensions\Microsoft\SQLDB\DAC
    ${env:ProgramFiles(x86)}\Microsoft Visual Studio\*\*\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\
    $env:CustomSqlPackageInstallLocation

The environment variable $env:CustomSqlPackageInstallLocation allows you to specify your own custom install directory.

For information on SqlPackage.exe see https://docs.microsoft.com/en-us/sql/tools/sqlpackage

## EXAMPLES

### EXAMPLE 1
```
Get-SqlPackagePath -Version 13
```

Returns the path to the SQL Server 2016 version of SqlPackage.exe (if present on the machine).

### EXAMPLE 2
```
Get-SqlPackagePath -Version latest
```

Return the full path to a latest version of SqlPackage.exe

## PARAMETERS

### -Version
Defines the specific version of SqlPackage.exe to which you wish to obtain the path.
Valid values for -Version are:

    latest = use the latest version of SqlPackage.exe
    17 = SQL Server 2025
    16 = SQL Server 2022
    15 = SQL Server 2019
    14 = SQL Server 2017
    13 = SQL Server 2016
    12 = SQL Server 2014
    11 = SQL Server 2012

If you are unsure which version(s) of SqlPackage.exe you have installed, use the function **Find-SqlPackageLocations** to obtain a full list.

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
Written by (c) Dr.
John Tunnicliffe, 2019-2025 https://github.com/DrJohnT/PublishDacPac
This PowerShell script is released under the MIT license http://www.opensource.org/licenses/MIT
Install SqlPackage.exe from https://learn.microsoft.com/en-us/sql/tools/sqlpackage/sqlpackage
SqlPackage.exe will also be installed with Visual Studio.

## RELATED LINKS

[https://github.com/DrJohnT/PublishDacPac](https://github.com/DrJohnT/PublishDacPac)

