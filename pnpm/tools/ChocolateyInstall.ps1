$ErrorActionPreference = 'Stop'

$packageName = $Env:chocolateyPackageName
$packagePnpmVersion = [version]([regex]'^\d+(\.\d+){2}').Match($Env:chocolateyPackageVersion).Value
$scriptRoot = Split-Path -parent $MyInvocation.MyCommand.Definition

$architecture = 'x64'
$platform = 'win32'
$pnpmExecutableFileName = "$packageName.exe"

if ([System.Environment]::Is64BitOperatingSystem -eq $false) {
	Write-Error "pnpm currently only provides binaries for x64 architectures on Windows are available. Try to install pnpm using npm."
	return
}

$pnpmZipUrl = "https://github.com/pnpm/pnpm/releases/download/v$packagePnpmVersion/pnpm-$platform-$architecture.zip"
$packageArgs = @{
    packageName   = $packageName
    url           = $pnpmZipUrl
    unzipLocation = $scriptRoot
    checksumType  = 'sha256'
    checksum      = '82C130717A59F237C49E8EAA8A7ED75C1D8D351A5B6DEDEEE3196B8E1B597C6E'
}
Install-ChocolateyZipPackage @packageArgs
