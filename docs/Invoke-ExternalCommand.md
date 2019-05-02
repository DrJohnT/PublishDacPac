---
external help file: PublishDacPac-help.xml
Module Name: PublishDacPac
online version:
schema: 2.0.0
---

# Invoke-ExternalCommand

## SYNOPSIS
Invokes (executes) an external executable via the command-line

## SYNTAX

```
Invoke-ExternalCommand [-Command] <String> [-Arguments] <String[]> [[-PipeOutNull] <Boolean>]
 [<CommonParameters>]
```

## DESCRIPTION
Invokes (executes) an external executable via the command-line

## EXAMPLES

### EXAMPLE 1
```
Invoke-ExternalCommand -Command bcp.exe -Arguments $myStringArray
```

Invokes bcp (SQL Bulk Copy) with the parameters stored in $myStringArray.
Note that the above will only work if bcp.exe is in your PATH. 
Otherwise, use the full path to bcp.exe

## PARAMETERS

### -Command
The command-line or windows executable you wish to execute. 
Should be a full path to the file if the executable is not in the PATH.

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

### -Arguments
An array of parameters to the passed on the command-line

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PipeOutNull
Windows executables are started in thier own process, so we stop this by piping the output to Out-Null;

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
