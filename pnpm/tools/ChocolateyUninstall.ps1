$ErrorActionPreference = 'Stop'

$npmCommand = Get-Command -Name npm.cmd -ErrorAction SilentlyContinue
if ($null -eq $npmCommand) 
{
    throw "Required dependency not found: npm. You may use the 'nodejs-lts' or 'nodejs' packages to install Node with NPM."
}

$pnpmCommand = Get-Command -Name pnpm -ErrorAction SilentlyContinue
if ($null -eq $pnpmCommand) 
{
    Write-Warning "pnpm package is already uninstalled"
    return
}

$packageArgs = @{
    packageName   = $Env:chocolateyPackageName
    file          = $npmCommand.Path
    fileType      = 'exe'
    silentArgs    = @('uninstall', '-g', 'pnpm')
}
Uninstall-ChocolateyPackage @packageArgs
