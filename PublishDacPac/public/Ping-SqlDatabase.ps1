function Ping-SqlDatabase {
    <#
	.SYNOPSIS
       	Checks that the database exists on the SQL Server
    #>
    [OutputType([Boolean])]
    [CmdletBinding()]
    param
    (
        [String] [Parameter(Mandatory = $true)]
        $ServerName,

        [String] [Parameter(Mandatory = $true)]
        $DatabaseName
    )

    if ($ServerName -eq $null -or $ServerName -eq "") {
        return $false;
    }

    try {
        [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | Out-Null;
        $server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $ServerName;

        $database = $server.Databases["master"];
        if ($database.Name -eq "master") {
            # SQL Server instance exists, so check if the database exists
            $database = $server.Databases[$DatabaseName];
            if ($database.Name -eq $DatabaseName) {
                return $true;
            }
            else {
                return $false;
            }
        }
        else {
            return $false;
        }
    }
    catch {
        Write-Warning "Error $_";
        return $false;
    }
}