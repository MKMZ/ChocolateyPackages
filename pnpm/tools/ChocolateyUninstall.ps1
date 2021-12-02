$ErrorActionPreference = 'Stop'

$npmCommand = Get-Command -Name npm -ErrorAction SilentlyContinue
if ($null -eq $npmCommand) 
{
    throw "Required dependency not found: npm"
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
