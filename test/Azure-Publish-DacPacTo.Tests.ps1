BeforeAll { 
    $CurrentFolder = Split-Path -Parent $PSScriptRoot;
    $ModulePath = Resolve-Path "$CurrentFolder\PublishDacPac\PublishDacPac.psd1";
    Import-Module -Name $ModulePath;

    function Get-ConfigData {

        $data = @{};

        if ("" -eq "$Env:AzureSqlUserID")
        {
            throw "Azure AuthenticationUser variable is not set!";
            return $data;
        }
        $data.Server = $Env:AzureSqlServer;
        $data.Database = $Env:AzureSqlDatabase;
        $data.AuthenticationUser = $Env:AzureSqlUserID;
        $data.AuthenticationPassword = $Env:AzureSqlPassword;

        $CurrentFolder = Split-Path -Parent $PSScriptRoot;
        $DacPacFolder = Resolve-Path "$CurrentFolder\examples\DatabaseToPublishToAzureSqlDB\bin\Debug";
        $data.DacPacFolder = $DacPacFolder;

        $DacPac = "DatabaseToPublishToAzureSqlDB.dacpac";
        $data.DacPacPath = Resolve-Path "$DacPacFolder\$DacPac";
        $DacProfile = "DatabaseToPublishToAzure.Upgrade.publish.xml";
        $data.DacProfile = $DacProfile;
    
        return $data;
    }

    function ResetEnv {
        $value = [Environment]::GetEnvironmentVariable("CustomSqlPackageInstallLocation");
        if ("$value" -ne "") {
            Clear-Item -Path Env:CustomSqlPackageInstallLocation;
        }
    }
    ResetEnv;
}

Describe "Publish-DacPac to Azure" -Tag "Azure" {
    Context "Valid parameters" {

        It "Valid parameters so deploy database" {
            $data = Get-ConfigData;
            $Database = $data.Database;
            { Publish-DacPac -DacPacPath $data.DacPacPath -DacPublishProfile $data.DacProfile -Server $data.Server -Database $Database -PreferredVersion latest -AuthenticationMethod sqlauth -AuthenticationUser $data.AuthenticationUser -AuthenticationPassword $data.AuthenticationPassword } | Should -Not -Throw;
        }

        It "Define a DeployScriptPath and check it was created" {
            $data = Get-ConfigData;
            $Database = $data.Database;
            $DeployScriptPath = New-Guid;
            $DeployScriptPath = "$Database-$DeployScriptPath";
            $DeployScriptPath = Join-Path $data.DacPacFolder "$DeployScriptPath.sql"            
            { Publish-DacPac -DacPacPath $data.DacPacPath -DacPublishProfile $data.DacProfile -Server $data.Server -Database $Database -PreferredVersion latest -DeployScriptPath $DeployScriptPath -AuthenticationMethod sqlauth -AuthenticationUser $data.AuthenticationUser -AuthenticationPassword $data.AuthenticationPassword } | Should -Not -Throw;
            ( Test-Path $DeployScriptPath ) | Should -BeTrue;
        }

    }
}

AfterAll {
    Remove-Module -Name PublishDacPac;
}