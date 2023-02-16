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

For information on SqlPackage.exe see https://docs.microsoft.com/en-us/sql/tools/sqlpackage

## EXAMPLES

### EXAMPLE 1
```
Select-SqlPackageVersion -PreferredVersion latest
```

Attempt to find latest version of SqlPackage.exe

### EXAMPLE 2
```
Select-SqlPackageVersion -PreferredVersion 13
```

Return the SQL Server 2016 version of SqlPackage.exe if it exists, otherwise return latest

## PARAMETERS

### -PreferredVersion
Defines the preferred version of SqlPackage.exe you wish to find. 
Use 'latest' for the latest version, or do not provide the parameter.
Valid values for -Version are: ('16', '15', '14', '13', '12', '11') which translate as follows:

    latest = use the latest version of SqlPackage.exe
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

### Returns the version of SqlPackage.exe found.
## NOTES
Written by (c) Dr.
John Tunnicliffe, 2019-2023 https://github.com/DrJohnT/PublishDacPac
This PowerShell script is released under the MIT license http://www.opensource.org/licenses/MIT

## RELATED LINKS

[https://github.com/DrJohnT/PublishDacPac](https://github.com/DrJohnT/PublishDacPac)

