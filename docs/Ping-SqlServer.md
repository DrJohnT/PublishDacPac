---
external help file: PublishDacPac-help.xml
Module Name: PublishDacPac
online version:
schema: 2.0.0
---

# Ping-SqlServer

## SYNOPSIS
Checks that the SQL Server instance exists

## SYNTAX

```
Ping-SqlServer [-Server] <String> [<CommonParameters>]
```

## DESCRIPTION
Checks that the SQL Server instance exists

Written by (c) Dr.
John Tunnicliffe, 2019 https://github.com/DrJohnT/PublishDacPac
This PowerShell script is released under the MIT license http://www.opensource.org/licenses/MIT

## EXAMPLES

### EXAMPLE 1
```
Ping-SqlDatabase -Server build01
```

Check if server build01 exists and has SQL Server running

## PARAMETERS

### -Server
Name of the target server, including instance and port if required.

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

### Returns $true if the server is found, $false otherwise.
## NOTES

## RELATED LINKS
