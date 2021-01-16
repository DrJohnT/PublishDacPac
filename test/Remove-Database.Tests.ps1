BeforeAll { 
    $CurrentFolder = Split-Path -Parent $PSScriptRoot;
    $ModulePath = Resolve-Path "$CurrentFolder\PublishDacPac\PublishDacPac.psd1";
    Import-Module -Name $ModulePath;

    function Get-ConfigData {  
        # copied from Publish-DacPac.Tests.ps1 but not everything needed
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
        $data.AuthenticationUser = "ea";
        $data.AuthenticationPassword = "open";
        $data.Server = 'localhost';

        return $data;
    }
}

Describe "Remove-Database" -Tag "Round1" {
    
    Context "Testing Inputs" {
         It "Should have Server as a mandatory parameter" {
            (Get-Command Remove-Database).Parameters['Server'].Attributes.mandatory | Should -BeTrue;
        }
        It "Should have Database as an mandatory parameter" {
            (Get-Command Remove-Database).Parameters['Database'].Attributes.mandatory | Should -BeTrue;
        }
        It "Should have AuthenticationUser as an optional parameter" {
            (Get-Command Remove-Database).Parameters['AuthenticationUser'].Attributes.mandatory | Should -BeFalse;
        }
        It "Should have AuthenticationPassword as an optional parameter" {
            (Get-Command Remove-Database).Parameters['AuthenticationPassword'].Attributes.mandatory | Should -BeFalse;
        }
        It "Should have AuthenticationCredential as an optional parameter" {
            (Get-Command Remove-Database).Parameters['AuthenticationCredential'].Attributes.mandatory | Should -BeFalse;
        }
    }

    Context "Invalid Parameters" {
        <#
        These have been removed as the error message bubbles up to Azure DevOps so that it says Partially Complete
        It "Invalid Server" {
            { Remove-Database -Server "MyServer" -Database "MyTestDBDacPublishProfile" } | Should -Throw;
        }
        #>
        It "Invalid Database" {
            { Remove-Database -Server "localhost" -Database "MyTestDB312" } | Should -Throw;
        }
    }

    Context "Testing drop" {
        It "Deploy and remove database" {
            $data = Get-ConfigData;
            $database = New-GUID;           
            $database = "RemoveDB-Test-$database";
            { Publish-DacPac -DacPacPath $data.DacPacPath -DacPublishProfile $data.AltDacProfilePath -Server $data.Server -Database $database -PreferredVersion latest } | Should -Not -Throw;
            ( Ping-SqlDatabase -Server $data.Server -Database $Database ) | Should -BeTrue;
            { Remove-Database -Server $data.Server -Database $database } | Should -Not -Throw;
            ( Ping-SqlDatabase -Server $data.Server -Database $Database ) | Should -BeFalse;
        }

        It "Deploy and remove database using SQL Authentication" {
            $data = Get-ConfigData;
            $database = New-GUID;           
            $database = "RemoveDB-Test-$database";
            { Publish-DacPac -DacPacPath $data.DacPacPath -DacPublishProfile $data.AltDacProfilePath -Server $data.Server -Database $database -PreferredVersion latest } | Should -Not -Throw;
            ( Ping-SqlDatabase -Server $data.Server -Database $Database ) | Should -BeTrue;
            { Remove-Database -Server $data.Server -Database $Database -AuthenticationMethod sqlauth -AuthenticationUser $data.AuthenticationUser -AuthenticationPassword $data.AuthenticationPassword } | Should -Not -Throw;
            ( Ping-SqlDatabase -Server $data.Server -Database $Database ) | Should -BeFalse;
        }
    }   
    
}

AfterAll {
    Remove-Module -Name PublishDacPac;
}