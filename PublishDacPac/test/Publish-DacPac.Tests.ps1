$CurrentFolder = Split-Path -Parent $MyInvocation.MyCommand.Path;
$ModulePath = Resolve-Path "$CurrentFolder\..\PublishDacPac.psd1";
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
        It "Should have TargetServerName as a mandatory parameter" {
            (Get-Command Publish-DacPac).Parameters['TargetServerName'].Attributes.mandatory | Should -Be $true;
        }
        It "Should have TargetDatabaseName as an optional parameter" {
            (Get-Command Publish-DacPac).Parameters['TargetDatabaseName'].Attributes.mandatory | Should -Be $false;
        }
        It "Should have PreferredVersion as an optional parameter" {
            (Get-Command Publish-DacPac).Parameters['PreferredVersion'].Attributes.mandatory | Should -Be $false;
        }
    }

    Context "Invalid SqlPackagePath" {
        It "Invalid SqlPackagePath path" {
            Mock -ModuleName PublishDacPac Get-SqlPackagePath { return "NoSqlPackage" };
            Mock -ModuleName PublishDacPac Select-SqlPackageVersion { return 150 };
            { Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile $DacProfile -TargetServerName "Build02" -TargetDatabaseName "MyTestDB" -PreferredVersion latest -TestMode $true } | Should Throw "Could not find SqlPackage.exe in order to deploy the database DacPac!";;
        }

        #Mock -CommandName Write-Error -MockWith {}
        #Assert-MockCalled -CommandName Write-Error -Scope It -Times 1
    }

    Context "Invalid Parameters" {

        It "Invalid DacPacPath path" {
            { Publish-DacPac -DacPacPath "NoDacPac" -DacPublishProfile "NoDacPublishProfile" -TargetServerName "MyServer" -TargetDatabaseName "MyTestDB" -PreferredVersion latest -TestMode $true  } | Should Throw;
        }

        It "Invalid DacPublishProfile path" {
            { Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile "NoDacPublishProfile" -TargetServerName "MyServer" -TargetDatabaseName "MyTestDB" -PreferredVersion latest -TestMode $true } | Should Throw "DAC Publish Profile does not exist";
        }

        It "Invalid PreferredVersion Should Throw" {
            { Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile $DacProfile -TargetServerName "Build02" -TargetDatabaseName "MyTestDB" -PreferredVersion 312312 -TestMode $true } | Should Throw;
        }

        It "Invalid TargetServerName" {
            { Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile $DacProfile -TargetServerName "MyServer" -TargetDatabaseName "MyTestDB" -PreferredVersion latest -TestMode $true } | Should Throw;
        }

    }

    Context "Valid Parameters In Debug Mode" {

        It "Valid Parameters In Debug Mode" {
            { Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile $DacProfile -TargetServerName "Build02" -TargetDatabaseName "MyTestDB" -PreferredVersion latest -TestMode $true } | Should Not Throw;;
        }

        It "Full path to DAC Profile" {
            { Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile $DacProfilePath -TargetServerName "Build02" -TargetDatabaseName "MyTestDB" -PreferredVersion latest -TestMode $true } | Should Not Throw;;
        }

        It "Alt Full path to DAC Profile" {
            { Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile $AltDacProfilePath -TargetServerName "Build02" -TargetDatabaseName "MyTestDB" -PreferredVersion latest -TestMode $true } | Should Not Throw;
        }
    }

    Context "Valid Parameters so deploy" {
        It "Valid Parameters In Debug Mode" {
            { Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile $DacProfile -TargetServerName "Build02" -TargetDatabaseName "MyTestDB" -PreferredVersion latest -TestMode $false } | Should Not Throw;;
        }
    }
}

Remove-Module -Name PublishDacPac