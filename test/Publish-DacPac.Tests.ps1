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
            { Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile $DacProfile -Server "localhost" -Database "MyTestDBPreferredVersion" -PreferredVersion 312312 } | Should Throw;
        }

        It "Invalid Server" {
            { Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile $DacProfile -Server "MyServer" -Database "MyTestDBMyServer" -PreferredVersion latest } | Should Throw;
        }

    }

    Context "Valid Parameters with mocked Invoke-ExternalCommand" {
        Mock -ModuleName PublishDacPac Invoke-ExternalCommand;
        It "Valid Parameters" {
            { Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile $DacProfile -Server "localhost" -Database "MyTestDB1" -PreferredVersion latest } | Should Not Throw;;
        }

        It "Valid Parameters with full path to DAC Profile" {
            { Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile $DacProfilePath -Server "localhost" -Database "MyTestDB2" -PreferredVersion latest } | Should Not Throw;;
        }

        It "Valid Parameters with alternative full path to DAC Profile" {
            { Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile $AltDacProfilePath -Server "localhost" -Database "MyTestDB3" -PreferredVersion latest } | Should Not Throw;
        }
    }

    Context "Valid parameters so deploy" {
        It "Valid parameters so deploy MyTestDB4 database" {
            { Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile $DacProfile -Server "localhost" -Database "MyTestDB4" -PreferredVersion latest } | Should Not Throw;;
        }
    }
}

Remove-Module -Name PublishDacPac