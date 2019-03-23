param (
    [Parameter(Mandatory)]
    [string] $ApiKey
)


$VerbosePreference = 'Continue';
$ErrorActionPreference = 'Stop';
$buildDir = $PSScriptRoot;

try {
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
