$ErrorActionPreference = 'Stop'

$packagePnpmVersion = [version]([regex]'^\d+(\.\d+){2}').Match($Env:chocolateyPackageVersion).Value

$npmCommand = Get-Command -Name npm.cmd -ErrorAction SilentlyContinue
if ($null -eq $npmCommand) 
{
    throw "Required dependency not found: npm. You may use the 'nodejs-lts' or 'nodejs' packages to install Node with NPM."
}

$pnpmCommand = Get-Command -Name pnpm -ErrorAction SilentlyContinue
if ($null -ne $pnpmCommand -and (-not $env:ChocolateyForce))
{
    $currentPnpmVersion = [version](pnpm --version)
    if ($packagePnpmVersion -le $currentPnpmVersion)
    {
        Write-Host "This pnpm package version '$packagePnpmVersion' is lower or equal to currently installed pnpm version '$currentPnpmVersion'. Use the --force switch to install version $packagePnpmVersion anyway."
        return
    }
}

$packagePnpmFullName = "pnpm@$packagePnpmVersion"
$packageInstallArgs = @('install', $packagePnpmFullName, '-g')
if ($env:ChocolateyForce)
{
    $packageInstallArgs += '-f'
}

$packageArgs = @{
    packageName   = $Env:chocolateyPackageName
    file          = $npmCommand.Path
    fileType      = 'exe'
    silentArgs    = $packageInstallArgs
}
Install-ChocolateyInstallPackage @packageArgs
