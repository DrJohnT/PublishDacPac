
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


[string[]]$sqlCmdValues = @();
$sqlCmdValues += "StagingDBName=StagingDB1";
$sqlCmdValues += "StagingDBServer=server1";
$sqlCmdValues += "myvar=myvalue";

Publish-DacPac -DacPacPath $DacPacPath -DacPublishProfile $DacProfilePath -Server "localhost" -Database "MyTestDB1" -SqlCmdVariables $sqlCmdValues

Remove-Module -Name PublishDacPac;