$CurrentFolder = Split-Path -Parent $MyInvocation.MyCommand.Path;
$ModulePath = Resolve-Path "$CurrentFolder\..\PublishDacPac\PublishDacPac.psd1";
import-Module -Name $ModulePath;

$mediaFolder =  Resolve-Path "$CurrentFolder\..\media";

$DacPac = "DatabaseToPublish.dacpac";
$DacPacFolder = Resolve-Path "$mediaFolder\DatabaseToPublish\bin\Debug";
$DacPacPath = Resolve-Path "$DacPacFolder\$DacPac";
$DacProfile = "DatabaseToPublish.CI.publish.xml";
$DacProfilePath = Resolve-Path "$DacPacFolder\$DacProfile";
$AltDacProfilePath = Resolve-Path "$mediaFolder\DatabaseToPublish\DatabaseToPublish.LOCAL.publish.xml";
$NoVarsDacProfilePath = Resolve-Path "$mediaFolder\DatabaseToPublish\DatabaseToPublish.NoVars.publish.xml";

Describe "Publish-DacPac" {
    Context "Testing Inputs" {
        It "Should have DacPacPath as a mandatory parameter" {
            (Get-Command Publish-DacPac).Parameters['DacPacPath'].Attributes.mandatory | Should -Be $true;
        }
        It "Should have DacPublishProfile as a mandatory parameter" {
            (Get-Command Publish-DacPac).Parameters['DacPublishProfile'].Attributes.mandatory | Should -Be $true;
        }
        It "Should have Server as a mandatory parameter" {
            (Get-Command Publish-DacPac).Parameters['Server'].Attributes.mandatory | Should -Be $true;
        }
        It "Should have Database as an optional parameter" {
            (Get-Command Publish-DacPac).Parameters['Database'].Attributes.mandatory | Should -Be $false;
        }
        It "Should have PreferredVersion as an optional parameter" {
            (Get-Command Publish-DacPac).Parameters['PreferredVersion'].Attributes.mandatory | Should -Be $false;
        }
        It "Should have SqlCmdVariables as an optional parameter" {
            (Get-Command Publish-DacPac).Parameters['SqlCmdVariables'].Attributes.mandatory | Should -Be $false;
        }
    }

    Context "Invalid SqlPackagePath" {
        It "Invalid SqlPackagePath path" {
            Mock -ModuleName PublishDacPac Get-SqlPackagePath { return "NoSqlPackage" };
            Mock -ModuleName PublishDacPac Select-SqlPackageVersion { return 150 };
            { Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile $DacProfile -Server "localhost" -Database "MyTestDB" -PreferredVersion latest } | Should Throw "Could not find SqlPackage.exe in order to deploy the database DacPac!";;
        }
    }

    Context "Invalid Parameters" {
        It "Invalid DacPacPath path" {
            { Publish-DacPac -DacPacPath "NoDacPac" -DacPublishProfile "NoDacPublishProfile" -Server "MyServer" -Database "MyTestDBDacPacPath" -PreferredVersion latest } | Should Throw;
        }

        It "Invalid DacPublishProfile path" {
            { Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile "NoDacPublishProfile" -Server "MyServer" -Database "MyTestDBDacPublishProfile" -PreferredVersion latest } | Should Throw "DAC Publish Profile does not exist";
        }

        It "Invalid PreferredVersion Should Throw" {
            { Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile $DacProfile -Server "localhost" -Database "MyTestDB01" -PreferredVersion 312312 } | Should Throw;
        }

        It "Invalid Server" {
            { Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile $DacProfile -Server "MyServer" -Database "MyTestDB02" -PreferredVersion latest } | Should Throw;
        }

    }

    Context "Valid Parameters with mocked Invoke-ExternalCommand" {
        $Server = 'localhost';
        Mock -ModuleName PublishDacPac Invoke-ExternalCommand;
        It "Valid Parameters" {
            { Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile $DacProfile -Server $Server -Database "MyTestDB03" -PreferredVersion latest } | Should Not Throw;;
        }

        It "Valid Parameters with full path to DAC Profile" {
            { Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile $DacProfilePath -Server $Server -Database "MyTestDB04" -PreferredVersion latest } | Should Not Throw;
        }

        It "Valid Parameters with alternative full path to DAC Profile" {
            { Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile $AltDacProfilePath -Server $Server -Database "MyTestDB05" -PreferredVersion latest } | Should Not Throw;
        }
    }

    Context "Valid parameters" {
        It "SqlCmdVariables missing from DAC Profile so fails" {
            $Database = 'MyTestDB06';
            { Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile $NoVarsDacProfilePath -Server $Server -Database $Database } | Should Throw;
        }

        It "Valid parameters so deploy MyTestDB4 database" {
            { Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile $AltDacProfilePath -Server "localhost" -Database "MyTestDB07" -PreferredVersion latest } | Should Not Throw;
        }
    }

    Context "Test SqlCmdVariables" {
        Mock -ModuleName PublishDacPac Invoke-ExternalCommand;
        It "Add ItemGroup and multiple values" {
            $Database = 'MyTestDB08';
            [string[]]$sqlCmdValues = @();
            $sqlCmdValues += "StagingDBName=StagingDB08"
            $sqlCmdValues += "StagingDBServer=localhost08"
            $sqlCmdValues += "MyExtraAttr=MyExtraValue08"
            Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile $DacProfilePath -Server "localhost" -Database $Database -SqlCmdVariables $sqlCmdValues;
            $filePath = "$DacPacFolder\$Database.deploy.publish.xml";
            (Test-Path -Path $filePath) | Should -Be $true;

        }

        It "Update one value" {
            $Database = 'MyTestDB09';
            [string[]]$sqlCmdValues = @();
            $sqlCmdValues += "StagingDBName=StagingDB09"
            Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile $AltDacProfilePath -Server "localhost" -Database $Database -SqlCmdVariables $sqlCmdValues;
            $filePath = "$DacPacFolder\$Database.deploy.publish.xml";
            (Test-Path -Path $filePath) | Should -Be $true;
        }

        It "Update two values" {
            $Database = 'MyTestDB10';
            [string[]]$sqlCmdValues = @();
            $sqlCmdValues += "StagingDBName=StagingDB10";
            $sqlCmdValues += "StagingDBServer=localhost10";
            Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile $AltDacProfilePath -Server "localhost" -Database $Database -SqlCmdVariables $sqlCmdValues;
            $filePath = "$DacPacFolder\$Database.deploy.publish.xml";
            (Test-Path -Path $filePath) | Should -Be $true;
        }

        It "Add new SqlCmdVariable" {
            $Database = 'MyTestDB11';
            [string[]]$sqlCmdValues = @();
            $sqlCmdValues += "StagingDBName=StagingDB11";
            $sqlCmdValues += "StagingDBServer=localhost11";
            $sqlCmdValues += "MyExtraAttr=MyExtraValue11";
            Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile $AltDacProfilePath -Server "localhost" -Database $Database -SqlCmdVariables $sqlCmdValues;
            $filePath = "$DacPacFolder\$Database.deploy.publish.xml";
            (Test-Path -Path $filePath) | Should -Be $true;
        }

    }
}

Remove-Module -Name PublishDacPac