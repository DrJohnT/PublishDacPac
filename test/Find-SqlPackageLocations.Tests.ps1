$ModulePath = Split-Path -Parent $MyInvocation.MyCommand.Path;
$ModulePath = Resolve-Path "$ModulePath\..\PublishDacPac\PublishDacPac.psd1";
import-Module -Name $ModulePath;

Describe "Find-SqlPackageLocations" {

    It "Finds some version" {
        ( Find-SqlPackageLocations ) | Should -Not -Be $null
    }

}

Remove-Module -Name PublishDacPac