Install-Module AU -Force

$Options = [ordered]@{
    WhatIf        = $au_WhatIf
    Force         = $false
    Timeout       = 100
    UpdateTimeout = 1200
    Threads       = 10
    Push          = $true
    PushAll       = $true
}

updateall -Options $Options
