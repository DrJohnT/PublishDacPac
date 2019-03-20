#  lists the location of all SQLPackage.exe files on the server

# Get SQL Server locations
$SqlPackageExes = @();
$SqlPackageExes += Get-Childitem -Path "${env:ProgramFiles}\Microsoft SQL Server\*\DAC\bin" -Recurse -Include "SqlPackage.exe" -ErrorAction SilentlyContinue;
$SqlPackageExes += Get-Childitem -Path "${env:ProgramFiles(x86)}\Microsoft SQL Server\*\DAC\bin" -Recurse -Include "SqlPackage.exe" -ErrorAction SilentlyContinue;

# Get Visual Studio 2017+ locations
$VsPaths = Resolve-Path "${env:ProgramFiles(x86)}\Microsoft Visual Studio\*\*\Common7\IDE\Extensions\Microsoft\SQLDB\DAC";
foreach ($VsPath in $VsPaths) {
	$SqlPackageExes += Get-Childitem �Path $VsPath -Recurse -Include "SqlPackage.exe" -ErrorAction SilentlyContinue;
}

# Get Visual Studio 2015 and before locations		
$VsPaths = Resolve-Path "${env:ProgramFiles(x86)}\Microsoft Visual Studio*\Common7\IDE\Extensions\Microsoft\SQLDB\DAC";
foreach ($VsPath in $VsPaths) {
	$SqlPackageExes += Get-Childitem -Path $VsPath -Recurse -Include "SqlPackage.exe" -ErrorAction SilentlyContinue;
}

# list out the locations found	   	   
foreach ($SqlPackageExe in $SqlPackageExes) {
    [string]$ProductVersion = $SqlPackageExe.VersionInfo.ProductVersion;  
    Write-Host "$ProductVersion  $SqlPackageExe";
}