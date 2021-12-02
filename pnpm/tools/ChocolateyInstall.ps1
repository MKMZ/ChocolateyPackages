$ErrorActionPreference = 'Stop'

$packagePnpmVersion = [version]([regex]'^\d+(\.\d+){2}').Match($Env:chocolateyPackageVersion).Value

$npmCommand = Get-Command -Name npm.cmd -ErrorAction SilentlyContinue
if ($null -eq $npmCommand) 
{
    throw "Required dependency not found: npm. You may use the 'nodejs-lts' or 'nodejs' packages to install Node with NPM."
}

$pnpmCommand = Get-Command -Name pnpm -ErrorAction SilentlyContinue
if ($null -ne $pnpmCommand) 
{
    $currentPnpmVersion = [version](pnpm --version)
    if ($packagePnpmVersion -le $currentPnpmVersion)
    {
        Write-Host "pnpm package version '$packagePnpmVersion' is lower or equal current version '$currentPnpmVersion'"
        return
    }
}

$packagePnpmFullName = "pnpm@$packagePnpmVersion"
$packageArgs = @{
    packageName   = $Env:chocolateyPackageName
    file          = $npmCommand.Path
    fileType      = 'exe'
    silentArgs    = @('install', '-g', $packagePnpmFullName)
}
Install-ChocolateyInstallPackage @packageArgs
