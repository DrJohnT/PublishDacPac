---
external help file: PublishDacPac-help.xml
Module Name: PublishDacPac
online version: https://github.com/DrJohnT/PublishDacPac
schema: 2.0.0
---

# Get-SqlDatabasePath

## SYNOPSIS
Returns the path to a specific SQL database in the form:
    SQLSERVER:\SQL\YourServer\DEFAULT\Databases\YourSQLDatabase
or
    SQLSERVER:\SQL\YourServer\YourInstance\Databases\YourSQLDatabase
Useful, when wishing to use the SqlServer module to navigate a SQL structure.

## SYNTAX

```
Get-SqlDatabasePath [-Server] <String> [-Database] <String> [<CommonParameters>]
```

## DESCRIPTION
Returns the path to a specific SQL database in the form:
    SQLSERVER:\SQL\YourServer\DEFAULT\Databases\YourSQLDatabase
or
    SQLSERVER:\SQL\YourServer\YourInstance\Databases\YourSQLDatabase
Useful, when wishing to use the SqlServer module to navigate a SQL structure.

## EXAMPLES

### EXAMPLE 1
```
Get-SqlAsPath -Server localhost -SQLDatabase MySQLDB;
```

Returns
    SQLSERVER:\SQL\localhost\DEFAULT\Databases\MySQLDB

### EXAMPLE 2
```
Get-SqlAsPath -Server mydevserver\instance1 -SQLDatabase MySQLDB;
```

Returns
    SQLSERVER:\SQL\mydevserver\instance1\Databases\MySQLDB

## PARAMETERS

### -Server
Name of the SSAS server, including instance and port if required.

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

### -Database
{{ Fill Database Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String
## NOTES
Written by (c) Dr.
John Tunnicliffe, 2019 https://github.com/DrJohnT/PublishDacPac
This PowerShell script is released under the MIT license http://www.opensource.org/licenses/MIT

## RELATED LINKS

[https://github.com/DrJohnT/PublishDacPac](https://github.com/DrJohnT/PublishDacPac)

