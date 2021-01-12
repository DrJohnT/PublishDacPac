function Remove-Database {
<#
    .SYNOPSIS
    Removes (Drops) the specified SQL database

    .DESCRIPTION
    Removes / Drops the specified SQL database from the SQL Server instance

    .PARAMETER Server
    Name of the target server, including instance and port if required.

    .PARAMETER Database
    The name of the database to be deleted.

    .PARAMETER AuthenticationMethod
    Indicates which method to use to connect to the target SQL Server instance in order to deploy the database DacPac.
    Valid options are:

        windows    - Windows authentication (default) will be used to deploy the DacPac to the target SQL Server instance
        sqlauth    - SQL Server authentication will be used to deploy the DacPac to the target SQL Server instance
        credential - Use a PSCredential to connect to the SQL Server instance

    .PARAMETER AuthenticationUser
    UserID for the AuthenticationUser
    Only required if AuthenticationMethod = sqlauth
    
    .PARAMETER AuthenticationPassword
    Password for the AuthenticationUser
    Only required if AuthenticationMethod = sqlauth
    
    .PARAMETER AuthenticationCredential
    A PSCredential object containing the credentials to connect to the SQL Server instance
    Only required if AuthenticationMethod = credential

    .EXAMPLE
    Remove-Database -Server 'localhost' -Database 'MyTestDB'

    Connects to the server localhost to remove the database MyTestDB

    .EXAMPLE
    Remove-Database -Server 'localhost' -Database 'MyTestDB' -Credential myCred

    Connects to the server localhost using the credential supplied in myCred to remove the database MyTestDB

    .LINK
    https://github.com/DrJohnT/PublishDacPac

    .NOTES
    Written by (c) Dr. John Tunnicliffe, 2019-2021 https://github.com/DrJohnT/PublishDacPac
    This PowerShell script is released under the MIT license http://www.opensource.org/licenses/MIT
#>
    [CmdletBinding()]
	param
	(
        [String] [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Server,

        [String] [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Database,
        
        [String] [Parameter(Mandatory = $false)]
        [ValidateSet('windows', 'sqlauth', 'credential')]
        $AuthenticationMethod = 'windows',

        [String] [Parameter(Mandatory = $false)]
        $AuthenticationUser,

        [String] [Parameter(Mandatory = $false)]
        $AuthenticationPassword,

        [PSCredential] [Parameter(Mandatory = $false)]
        $AuthenticationCredential
    )

    $sqlCmd = "drop database [$Database]";
    switch ($AuthenticationMethod) {
           'windows' {
                Invoke-Sqlcmd -Server $Server -Database 'master' -Query $sqlCmd -ErrorAction Stop;
            }
            'sqlauth' {
                Invoke-Sqlcmd -Server $Server -Database 'master' -Query $sqlCmd -ErrorAction Stop -Username $AuthenticationUser -Password $AuthenticationPassword;
            }
            'credential' {
                Invoke-Sqlcmd -Server $Server -Database 'master' -Query $sqlCmd -ErrorAction Stop -Credential $Credential;
            }
    }
    
}
New-Alias -Name Remove-Database -Value Unpublish-Database;