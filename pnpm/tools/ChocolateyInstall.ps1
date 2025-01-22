$ErrorActionPreference = 'Stop'

$packageName = $Env:chocolateyPackageName
$packagePnpmVersion = [version]([regex]'^\d+(\.\d+){2}').Match($Env:chocolateyPackageVersion).Value
$scriptRoot = Split-Path -parent $MyInvocation.MyCommand.Definition

$architecture = 'x64'
$platform = 'win'
$pnpmExecutableFileName = "$packageName.exe"

if ([System.Environment]::Is64BitOperatingSystem -eq $false) {
	Write-Error "pnpm currently only provides binaries for x64 architectures on Windows are available. Try to install pnpm using npm."
	return
}

$pnpmExecutablePath = "$scriptRoot\$pnpmExecutableFileName"
$pnpmExecutableUrl = "https://github.com/pnpm/pnpm/releases/download/v$packagePnpmVersion/pnpm-$platform-$architecture.exe"
$packageWebFileArgs = @{
    packageName     = $packageName
    fileFullPath    = $pnpmExecutablePath
    url             = $pnpmExecutableUrl
    checksumType    = 'sha256'
    checksum        = '88F54A7DF7A01719E06CFA299A1700966574EE51'
}
Get-ChocolateyWebFile @packageWebFileArgs
