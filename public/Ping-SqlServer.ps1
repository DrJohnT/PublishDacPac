function Ping-SqlServer {
	<#
		.SYNOPSIS
		Checks that the SQL Server instance exists
	#>
	[OutputType([Boolean])]
    	[CmdletBinding()]
	param
	(
        	[String] [Parameter(Mandatory = $true)]
        	$ServerName
	)

	if ($ServerName -eq $null -or $ServerName -eq "") {
        	return $false;
	}

	try {
		[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | Out-Null;
		$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $ServerName;

		$database = $server.Databases["master"];
		if ($database.Name -eq "master") {
			return $true;
		} else {
			return $false;
		}
	} catch {
		Write-Error "Error $_";
		return $false;
	}
}