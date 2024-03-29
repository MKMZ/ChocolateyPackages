﻿$ErrorActionPreference = 'Stop'

$packageName = $Env:chocolateyPackageName
$packagePnpmVersion = [version]([regex]'^\d+(\.\d+){2}').Match($Env:chocolateyPackageVersion).Value
$scriptRoot = Split-Path -parent $MyInvocation.MyCommand.Definition

$architecture = 'x64'
$platform = 'win'
$pnpmExecutableFileName = "$packageName.exe"

$pnpmCommand = Get-Command -Name $packageName -ErrorAction SilentlyContinue
if ($null -ne $pnpmCommand -and (-not $env:ChocolateyForce))
{
    $currentPnpmVersionString = pnpm --version
    $currentPnpmVersion = [version]::new()
    $isValidCurrentVersion = [version]::TryParse($currentPnpmVersionString, [ref]$currentPnpmVersion)
    if (-not $isValidCurrentVersion)
    {
        Write-Error "Invalid current version of pnpm detected: ""$currentPnpmVersionString""."
        return
    }
    if ($packagePnpmVersion -le $currentPnpmVersion)
    {
        Write-Host "This pnpm package version '$packagePnpmVersion' is lower or equal to currently installed pnpm version '$currentPnpmVersion'. Use the --force switch to install version $packagePnpmVersion anyway."
        return
    }
}

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
    checksumType    = 'sha1'
    checksum        = '88F54A7DF7A01719E06CFA299A1700966574EE51'
}
Get-ChocolateyWebFile @packageWebFileArgs
