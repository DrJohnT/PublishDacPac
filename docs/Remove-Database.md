---
external help file: PublishDacPac-help.xml
Module Name: PublishDacPac
online version: https://github.com/DrJohnT/PublishDacPac
schema: 2.0.0
---

# Remove-Database

## SYNOPSIS
Removes (Drops) the specified SQL database

## SYNTAX

```
Remove-Database [-Server] <String> [-Database] <String> [[-Credential] <PSCredential>] [<CommonParameters>]
```

## DESCRIPTION
Removes / Drops the specified SQL database from the SQL Server instance

## EXAMPLES

### EXAMPLE 1
```
Remove-Database -Server 'localhost' -Database 'MyTestDB'
```

Connects to the server localhost to remove the database MyTestDB

### EXAMPLE 2
```
Remove-Database -Server 'localhost' -Database 'MyTestDB' -Credential myCred
```

Connects to the server localhost using the credential supplied in myCred to remove the database MyTestDB

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

### -Database
The name of the database to be deleted.

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

### -Credential
\[Optional\] A PSCredential object containing the credentials to connect to the AAS server.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
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

