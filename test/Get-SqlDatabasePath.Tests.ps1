$ModulePath = Split-Path -Parent $MyInvocation.MyCommand.Path;
$ModulePath = Resolve-Path "$ModulePath\..\PublishDacPac\PublishDacPac.psd1";
import-Module -Name $ModulePath;

Describe "Get-SqlDatabasePath" {
    Context "Testing Inputs" {
        It "Should have Server as a mandatory parameter" {
            (Get-Command Get-SqlDatabasePath).Parameters['Server'].Attributes.mandatory | Should -Be $true
        }
        It "Should have Database as a mandatory parameter" {
            (Get-Command Get-SqlDatabasePath).Parameters['Database'].Attributes.mandatory | Should -Be $true
        }
        It "Empty server" {
            { Get-SqlDatabasePath -Server "" -Database MyCube } | Should Throw;
        }
        It "Null server" {
            { Get-SqlDatabasePath -Server $null -Database MyCube } | Should Throw;
        }
        It "Empty Database" {
            { Get-SqlDatabasePath -Server localhost -Database "" } | Should Throw;
        }
        It "Null Database" {
            { Get-SqlDatabasePath -Server localhost -Database $null } | Should Throw;
        }
    }

    Context "Check Get-SqlDatabasePath Results" {
        It "Test 1" {
            ( Get-SqlDatabasePath -Server localhost -Database MyDB ) | Should -Be 'SQLSERVER:\SQL\localhost\DEFAULT\Databases\MyDB';
          }

        It "Test 2" {
            ( Get-SqlDatabasePath -Server YourServer -Database YourDatabase ) | Should -Be 'SQLSERVER:\SQL\YourServer\DEFAULT\Databases\YourDatabase';
        }

        It "Test 3" {
            ( Get-SqlDatabasePath -Server 'YourServer\YourInstance' -Database YourDatabase  ) | Should -Be 'SQLSERVER:\SQL\YourServer\YourInstance\Databases\YourDatabase';
        }
    }
}

Remove-Module -Name PublishDacPac
