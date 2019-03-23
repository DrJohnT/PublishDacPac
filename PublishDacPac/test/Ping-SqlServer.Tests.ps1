$ModulePath = Split-Path -Parent $MyInvocation.MyCommand.Path;
$ModulePath = Resolve-Path "$ModulePath\..\PublishDacPac.psd1";
import-Module -Name $ModulePath;

Describe "Ping-SqlServer" {

    It "Invalid server" {
        ( Ping-SqlServer -ServerName "Invalid" ) | Should -Be $false;
    }

    It "Valid server Build02" {
        ( Ping-SqlServer -ServerName "Build02" ) | Should -Be $true;
    }

    #It "Valid server" {
    #    ( Ping-SqlServer -ServerName "localhost" ) | Should -Be $true;
    #}

}

Remove-Module -Name PublishDacPac