$ErrorActionPreference = 'Stop'

$npmCommand = Get-Command -Name npm.cmd -ErrorAction SilentlyContinue
if ($null -eq $npmCommand) 
{
    throw "Required dependency not found: npm. You may use the 'nodejs-lts' or 'nodejs' packages to install Node with NPM."
}

$pnpmCommand = Get-Command -Name pnpm -ErrorAction SilentlyContinue
if ($null -eq $pnpmCommand -and (-not $env:ChocolateyForce))
{
    Write-Warning "This pnpm package is already uninstalled. Use the --force switch to try to uninstall anyway."
    return
}

$packageUninstallArgs = @('uninstall', 'pnpm', '-g')
if ($env:ChocolateyForce)
{
    $packageUninstallArgs += '-f'
}

$packageArgs = @{
    packageName   = $Env:chocolateyPackageName
    file          = $npmCommand.Path
    fileType      = 'exe'
    silentArgs    = $packageUninstallArgs
}
Uninstall-ChocolateyPackage @packageArgs
