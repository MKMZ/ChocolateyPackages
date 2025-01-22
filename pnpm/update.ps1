$VerbosePreference = 'Continue'
$DebugPreference = 'Continue'

Install-Module chocolatey-au -Force

$latestRelease = "https://api.github.com/repos/pnpm/pnpm/releases/latest"

function global:au_BeforeUpdate {
    $Latest.Checksum = Get-RemoteChecksum $Latest.URL -Algorithm sha256
}

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(?i)(^\s*checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum)'"
        }
    }
}

function global:au_GetLatest {
    $packageJson = Invoke-WebRequest -UseBasicParsing -Uri $latestRelease | ConvertFrom-Json
    $packageVersion = $packageJson.tag_name -Replace "^v"
    $packageAsset = $packageJson.assets | Where-Object { $_.name -eq "pnpm-win-x64.exe" }

    @{
        Version       = $packageVersion
        RemoteVersion = $packageVersion
        URL           = $packageAsset.browser_download_url
    }
}

update -ChecksumFor none
