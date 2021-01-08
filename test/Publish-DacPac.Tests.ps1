BeforeAll { 
    $CurrentFolder = Split-Path -Parent $PSScriptRoot;
    $ModulePath = Resolve-Path "$CurrentFolder\PublishDacPac\PublishDacPac.psd1";
    Import-Module -Name $ModulePath;

    function Get-ConfigData {
        $data = @{};

        $CurrentFolder = Split-Path -Parent $PSScriptRoot;
        $DacPacFolder = Resolve-Path "$CurrentFolder\examples\DatabaseToPublish\bin\Debug";
        $data.DacPacFolder = $DacPacFolder;

        $DacPac = "DatabaseToPublish.dacpac";
        $data.DacPacPath = Resolve-Path "$DacPacFolder\$DacPac";
        $DacProfile = "DatabaseToPublish.CI.publish.xml";
        $data.DacProfile = $DacProfile;
        $data.DacProfilePath = Resolve-Path "$DacPacFolder\$DacProfile";
        
        $data.AltDacProfilePath = Resolve-Path "$DacPacFolder\DatabaseToPublish.LOCAL.publish.xml";
        $data.NoVarsDacProfilePath = Resolve-Path "$DacPacFolder\DatabaseToPublish.NoVars.publish.xml";

        $data.Server = 'localhost';

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

Describe "Publish-DacPac" {
    Context "Testing Inputs" {
        It "Should have DacPacPath as a mandatory parameter" {
            (Get-Command Publish-DacPac).Parameters['DacPacPath'].Attributes.mandatory | Should -BeTrue;
        }
        It "Should have DacPublishProfile as a mandatory parameter" {
            (Get-Command Publish-DacPac).Parameters['DacPublishProfile'].Attributes.mandatory | Should -BeTrue;
        }
        It "Should have Server as a mandatory parameter" {
            (Get-Command Publish-DacPac).Parameters['Server'].Attributes.mandatory | Should -BeTrue;
        }
        It "Should have Database as an optional parameter" {
            (Get-Command Publish-DacPac).Parameters['Database'].Attributes.mandatory | Should -BeFalse;
        }
        It "Should have PreferredVersion as an optional parameter" {
            (Get-Command Publish-DacPac).Parameters['PreferredVersion'].Attributes.mandatory | Should -BeFalse;
        }
        It "Should have SqlCmdVariables as an optional parameter" {
            (Get-Command Publish-DacPac).Parameters['SqlCmdVariables'].Attributes.mandatory | Should -BeFalse;
        }
    }

    Context "Invalid SqlPackagePath" {
        It "Invalid SqlPackagePath path" {
            $data = Get-ConfigData;
            Mock -ModuleName PublishDacPac Get-SqlPackagePath { return "NoSqlPackage" };
            Mock -ModuleName PublishDacPac Select-SqlPackageVersion { return 15 };
            { Publish-DacPac -DacPacPath $data.DacPacPath -DacPublishProfile $data.DacProfile -Server $data.Server -Database "MyTestDB" -PreferredVersion latest } | Should -Throw;
        }
    }

    Context "Invalid Parameters" {
        <#
        These have been removed as the error message bubbles up to Azure DevOps so that it says Partially Complete
        It "Invalid DacPacPath path" {
            { Publish-DacPac -DacPacPath "NoDacPac" -DacPublishProfile "NoDacPublishProfile" -Server "MyServer" -Database "MyTestDBDacPacPath" -PreferredVersion latest } | Should -Throw;
        }

        It "Invalid DacPublishProfile path" {
            $data = Get-ConfigData;
            { Publish-DacPac -DacPacPath $data.DacPacPath -DacPublishProfile "NoDacPublishProfile" -Server "MyServer" -Database "MyTestDBDacPublishProfile" -PreferredVersion latest } | Should -Throw;
        }
        It "Invalid Server" {
            
            $data = Get-ConfigData;
            { Publish-DacPac -DacPacPath $data.DacPacPath -DacPublishProfile $data.DacProfile -Server "MyServer" -Database "MyTestDB02" -PreferredVersion latest } | Should -Throw;
        }
        #>

        It "Invalid PreferredVersion Should -Throw;" {
            $data = Get-ConfigData;
            { Publish-DacPac -DacPacPath $data.DacPacPath -DacPublishProfile $data.DacProfile -Server $data.Server -Database "MyTestDB01" -PreferredVersion 312312 } | Should -Throw;
        }

    }

    Context "Valid Parameters with mocked Invoke-ExternalCommand" {        
        
        It "Valid Parameters" {
            $data = Get-ConfigData;
            Mock -ModuleName PublishDacPac Invoke-ExternalCommand;
            { Publish-DacPac -DacPacPath $data.DacPacPath -DacPublishProfile $data.DacProfile -Server $data.Server -Database "MyTestDB03" -PreferredVersion latest } | Should -Not -Throw;
        }

        It "Valid Parameters with full path to DAC Profile" {
            $data = Get-ConfigData;            
            Mock -ModuleName PublishDacPac Invoke-ExternalCommand;
            { Publish-DacPac -DacPacPath $data.DacPacPath -DacPublishProfile $data.DacProfilePath -Server $data.Server -Database "MyTestDB04" -PreferredVersion latest } | Should -Not -Throw;
        }

        It "Valid Parameters with alternative full path to DAC Profile" {
            $data = Get-ConfigData;
            Mock -ModuleName PublishDacPac Invoke-ExternalCommand;
            { Publish-DacPac -DacPacPath $data.DacPacPath -DacPublishProfile $data.AltDacProfilePath -Server $data.Server -Database "MyTestDB05" -PreferredVersion latest } | Should -Not -Throw;
        }

    }

    Context "Valid parameters" {
        <#
        These have been removed as the error message bubbles up to Azure DevOps so that it says Partially Complete
        It "SqlCmdVariables missing from DAC Profile so fails" {
            $data = Get-ConfigData;
            Write-Host "The following error is expected: 'An error occurred during deployment plan generation'" -ForegroundColor Yellow;
            { Publish-DacPac -DacPacPath $data.DacPacPath -DacPublishProfile $data.NoVarsDacProfilePath -Server $data.Server -Database 'MyTestDB06' } | Should -Throw;
        }
        #>
        It "Valid parameters so deploy MyTestDB07 database" {
            $data = Get-ConfigData;
            { Publish-DacPac -DacPacPath $data.DacPacPath -DacPublishProfile $data.AltDacProfilePath -Server $data.Server -Database "MyTestDB07" -PreferredVersion latest } | Should -Not -Throw;
            { Remove-Database -Server $data.Server -Database "MyTestDB07" } | Should -Not -Throw;
        }
    }

    Context "Test SqlCmdVariables" {
        
        It "Add ItemGroup and multiple values" {
            Mock -ModuleName PublishDacPac Invoke-ExternalCommand;
            $data = Get-ConfigData;
            $Database = 'MyTestDB08';
            [string[]]$sqlCmdValues = @();
            $sqlCmdValues += "StagingDBName=StagingDB08"
            $sqlCmdValues += "StagingDBServer=localhost08"
            $sqlCmdValues += "MyExtraAttr=MyExtraValue08"
            Publish-DacPac -DacPacPath $data.DacPacPath -DacPublishProfile $data.DacProfilePath -Server $data.Server -Database $Database -SqlCmdVariables $sqlCmdValues;
            $DacPacFolder = $data.DacPacFolder;
            $filePath = "$DacPacFolder\$Database.deploy.publish.xml";
            (Test-Path -Path $filePath) | Should -BeTrue;

        }

        It "Update one value" {
            Mock -ModuleName PublishDacPac Invoke-ExternalCommand;
            $data = Get-ConfigData;
            $Database = 'MyTestDB09';
            [string[]]$sqlCmdValues = @();
            $sqlCmdValues += "StagingDBName=StagingDB09"
            Publish-DacPac -DacPacPath $data.DacPacPath -DacPublishProfile $data.AltDacProfilePath -Server $data.Server -Database $Database -SqlCmdVariables $sqlCmdValues;
            $DacPacFolder = $data.DacPacFolder;
            $filePath = "$DacPacFolder\$Database.deploy.publish.xml";
            (Test-Path -Path $filePath) | Should -BeTrue;
        }

        It "Update two values" {
            Mock -ModuleName PublishDacPac Invoke-ExternalCommand;
            $data = Get-ConfigData;
            $Database = 'MyTestDB10';
            [string[]]$sqlCmdValues = @();
            $sqlCmdValues += "StagingDBName=StagingDB10";
            $sqlCmdValues += "StagingDBServer=localhost10";
            Publish-DacPac -DacPacPath $data.DacPacPath -DacPublishProfile $data.AltDacProfilePath -Server $data.Server -Database $Database -SqlCmdVariables $sqlCmdValues;
            $DacPacFolder = $data.DacPacFolder;
            $filePath = "$DacPacFolder\$Database.deploy.publish.xml";
            (Test-Path -Path $filePath) | Should -BeTrue;
        }

        It "Add new SqlCmdVariable" {
            Mock -ModuleName PublishDacPac Invoke-ExternalCommand;
            $data = Get-ConfigData;
            $Database = 'MyTestDB11';
            [string[]]$sqlCmdValues = @();
            $sqlCmdValues += "StagingDBName=StagingDB11";
            $sqlCmdValues += "StagingDBServer=localhost11";
            $sqlCmdValues += "MyExtraAttr=MyExtraValue11";
            Publish-DacPac -DacPacPath $data.DacPacPath -DacPublishProfile $data.AltDacProfilePath -Server $data.Server -Database $Database -SqlCmdVariables $sqlCmdValues;
            $DacPacFolder = $data.DacPacFolder;
            $filePath = "$DacPacFolder\$Database.deploy.publish.xml";
            (Test-Path -Path $filePath) | Should -BeTrue;
        }

    }
 
}

AfterAll {
    Remove-Module -Name PublishDacPac;
}