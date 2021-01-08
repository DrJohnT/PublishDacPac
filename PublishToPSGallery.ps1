param (
    [Parameter(Mandatory)]
    [string] $ApiKey
)

#$VerbosePreference = 'Continue';
$ErrorActionPreference = 'Stop';
$baseDir = $PSScriptRoot;

$PsdPath = Resolve-Path "$PSScriptRoot\PublishDacPac\PublishDacPac.psd1";
$psd = Import-PowershellDataFile $PsdPath;
$ModuleVersion = $psd.ModuleVersion;
Write-Host "Module Version to be published to the Gallery: $ModuleVersion" -ForegroundColor Yellow;

$confirmation = Read-Host "Are you Sure?  Type Y to Proceed."
if ($confirmation -eq 'Y') {        

    try {
        .\UpdateHelp.ps1

        $buildDir = "$baseDir\PublishDacPac";
        Write-Information $buildDir;
        Write-Verbose 'Importing PowerShellGet module'
        $psGet = Import-Module PowerShellGet -PassThru -Verbose:$false
        & $psGet { [CmdletBinding()] param () Install-NuGetClientBinaries -CallerPSCmdlet $PSCmdlet -BootstrapNuGetExe -Force }

        Write-Host 'Publishing module using PowerShellGet'
        $null = Publish-Module -Path $buildDir -NuGetApiKey $ApiKey -Confirm:$false
    }
    catch {
        Write-Error -ErrorRecord $_
        exit 1
    }
}
