$ModulePath = Split-Path -Parent $MyInvocation.MyCommand.Path;
$ModulePath = Resolve-Path "$ModulePath\..\PublishDacPac.psd1";
import-Module -Name $ModulePath;

Describe "Ping-SqlDatabase" {

    It "Invalid server" {
        ( Ping-SqlDatabase -ServerName "InvalidServer" -DatabaseName "master" ) | Should -Be $false;
    }

    It "Valid server and invalid database" {
        ( Ping-SqlDatabase -ServerName "Build02" -DatabaseName "InvalidDatabase" ) | Should -Be $false;
    }

    It "Valid server and database" {
        ( Ping-SqlDatabase -ServerName "Build02" -DatabaseName "master" ) | Should -Be $true;
    }

}

Remove-Module -Name PublishDacPac
