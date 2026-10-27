<#
Installs or updates the desktop app in this project's isolated runtime from a GitHub Release of
akshatksingh18/voice-workspace-desktop. Picks the zip for this laptop's processor (ARM64 or x64),
checks its SHA-256, moves the current exe, DLLs and resources/ into a dated rollback-* folder,
then copies the new ones in. Settings, models, history and recordings in Data/ are not touched.

  .\install-desktop.ps1                  # latest release
  .\install-desktop.ps1 -Version 0.10.0  # a specific release
  .\install-desktop.ps1 -WhatIf          # show what would happen

Needs an existing runtime (portable marker plus Data/settings_store.json); a fresh runtime is
prepared with setup.md first. A runtime still named runtime\handy is renamed to runtime\desktop.
Quit the app from its tray first; this script never stops it. Rollback: quit the app, move the
files from the newest rollback-* folder back over the installed ones.
#>
[CmdletBinding(SupportsShouldProcess)]
param([string]$Version = 'latest')

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$voiceRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$voiceRuntime = Join-Path $voiceRoot 'runtime\desktop'
$voiceLegacy = Join-Path $voiceRoot 'runtime\handy'
$voiceRepo = 'akshatksingh18/voice-workspace-desktop'

$voiceCpu = if ($env:PROCESSOR_ARCHITEW6432) { $env:PROCESSOR_ARCHITEW6432 } else { $env:PROCESSOR_ARCHITECTURE }
$voiceArch = switch ($voiceCpu) {
    'ARM64' { 'arm64' }
    'AMD64' { 'x64' }
    default { throw "Unsupported processor architecture: $voiceCpu" }
}
$voiceAsset = "voice-workspace-windows-$voiceArch.zip"
$voiceBase = if ($Version -eq 'latest') {
    "https://github.com/$voiceRepo/releases/latest/download"
} else {
    "https://github.com/$voiceRepo/releases/download/v$($Version.TrimStart('v'))"
}

# Never replace files under a running app.
$voiceRunning = @(Get-Process -Name voice-workspace, handy -ErrorAction SilentlyContinue | Where-Object {
    $_.Path -and ($_.Path.StartsWith("$voiceRuntime\", [StringComparison]::OrdinalIgnoreCase) -or
                  $_.Path.StartsWith("$voiceLegacy\", [StringComparison]::OrdinalIgnoreCase))
})
if ($voiceRunning.Count) { throw 'Quit Voice Workspace from its tray first. No process was stopped.' }

if (-not (Test-Path -LiteralPath $voiceRuntime)) {
    if (Test-Path -LiteralPath $voiceLegacy) {
        if ($PSCmdlet.ShouldProcess($voiceLegacy, 'Rename runtime\handy to runtime\desktop')) {
            Rename-Item -LiteralPath $voiceLegacy -NewName 'desktop'
        } else {
            $voiceRuntime = $voiceLegacy
        }
    } else {
        throw "No runtime at $voiceRuntime. Prepare a fresh runtime with setup.md (portable marker, baseline settings, model), then rerun."
    }
}
foreach ($voiceRequired in @('portable', 'Data\settings_store.json')) {
    if (-not (Test-Path -LiteralPath (Join-Path $voiceRuntime $voiceRequired) -PathType Leaf)) {
        throw "Runtime is missing $voiceRequired; refusing to install into it. See setup.md."
    }
}

$voiceTemp = Join-Path ([IO.Path]::GetTempPath()) ("voice-workspace-install-" + [Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $voiceTemp | Out-Null
try {
    $voiceZip = Join-Path $voiceTemp $voiceAsset
    $voiceSums = Join-Path $voiceTemp 'SHA256SUMS.txt'
    Write-Output "Downloading $voiceAsset ($Version) from GitHub."
    Invoke-WebRequest -UseBasicParsing -Uri "$voiceBase/$voiceAsset" -OutFile $voiceZip
    Invoke-WebRequest -UseBasicParsing -Uri "$voiceBase/SHA256SUMS.txt" -OutFile $voiceSums

    $voiceExpected = (Get-Content -LiteralPath $voiceSums | Where-Object { $_ -match "\s\*?$([regex]::Escape($voiceAsset))$" } |
        ForEach-Object { ($_ -split '\s+')[0] }) | Select-Object -First 1
    if (-not $voiceExpected) { throw "The release lists no checksum for $voiceAsset." }
    if ((Get-FileHash -LiteralPath $voiceZip -Algorithm SHA256).Hash -ne $voiceExpected) {
        throw "$voiceAsset does not match the release checksum; nothing was installed."
    }

    $voiceApp = Join-Path $voiceTemp 'app'
    Expand-Archive -LiteralPath $voiceZip -DestinationPath $voiceApp
    foreach ($voiceLine in Get-Content -LiteralPath (Join-Path $voiceApp 'SHA256SUMS.txt')) {
        if (-not $voiceLine.Trim()) { continue }
        $voiceHash, $voiceRel = $voiceLine -split '\s+', 2
        $voiceFile = Join-Path $voiceApp ($voiceRel.TrimStart('*').Replace('/', '\'))
        if ((Get-FileHash -LiteralPath $voiceFile -Algorithm SHA256).Hash -ne $voiceHash) {
            throw "Packaged file $voiceRel does not match its checksum; nothing was installed."
        }
    }
    if (-not (Test-Path -LiteralPath (Join-Path $voiceApp 'voice-workspace.exe'))) { throw 'The release zip has no voice-workspace.exe.' }
    $voiceNew = (Get-Content -LiteralPath (Join-Path $voiceApp 'VERSION.txt') -Raw).Trim()

    $voiceOld = Join-Path $voiceRuntime 'VERSION.txt'
    $voiceOldVersion = if (Test-Path -LiteralPath $voiceOld) { (Get-Content -LiteralPath $voiceOld -Raw).Trim() } else { 'unversioned' }
    $voiceRollback = Join-Path $voiceRuntime ("rollback-{0}-{1}" -f $voiceOldVersion, (Get-Date -Format 'yyyyMMdd-HHmmss'))

    if ($PSCmdlet.ShouldProcess($voiceRuntime, "Install Voice Workspace $voiceNew ($voiceArch); current files go to $(Split-Path $voiceRollback -Leaf)")) {
        New-Item -ItemType Directory -Path $voiceRollback | Out-Null
        $voiceMove = @(Get-ChildItem -LiteralPath $voiceRuntime -File | Where-Object {
            $_.Name -in @('voice-workspace.exe', 'handy.exe', 'VERSION.txt', 'SHA256SUMS.txt') -or $_.Extension -eq '.dll'
        })
        foreach ($voiceItem in $voiceMove) { Move-Item -LiteralPath $voiceItem.FullName -Destination $voiceRollback }
        $voiceResources = Join-Path $voiceRuntime 'resources'
        if (Test-Path -LiteralPath $voiceResources) { Move-Item -LiteralPath $voiceResources -Destination $voiceRollback }
        Copy-Item -LiteralPath (Join-Path $voiceRuntime 'Data\settings_store.json') -Destination $voiceRollback

        Copy-Item -Path (Join-Path $voiceApp '*') -Destination $voiceRuntime -Recurse -Force
        Write-Output "Installed Voice Workspace $voiceNew ($voiceArch) in $voiceRuntime."
        Write-Output "Previous files and a settings copy: $voiceRollback"
        Write-Output 'Start it with scripts\start-test.ps1.'
    }
} finally {
    Remove-Item -LiteralPath $voiceTemp -Recurse -Force -ErrorAction SilentlyContinue
}
