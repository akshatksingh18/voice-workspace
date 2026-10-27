[CmdletBinding(SupportsShouldProcess)]
param()

$ErrorActionPreference = 'Stop'
$voiceRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$voiceManifest = Get-Content -LiteralPath (Join-Path $voiceRoot 'repositories.json') -Raw | ConvertFrom-Json
$voiceExpected = @{
    'handy' = 'https://github.com/akshatksingh18/voice-workspace-desktop.git'
    'granola-alt' = 'https://github.com/akshatksingh18/granola-alt.git'
    'openwhispr' = 'https://github.com/OpenWhispr/openwhispr.git'
    'anarlog' = 'https://github.com/fastrepl/anarlog.git'
    'minutes' = 'https://github.com/silverstein/minutes.git'
    'open-granola' = 'https://github.com/anshuman-pandey/open-granola.git'
    'omascribe' = 'https://github.com/jamespember/omascribe.git'
    'meetily' = 'https://github.com/Zackriya-Solutions/meetily.git'
    'steno' = 'https://github.com/ruzin/stenoai.git'
}
$voiceGitSafety = @('-c', "safe.directory=$($voiceRoot.Replace('\','/'))", '-c', 'core.hooksPath=NUL', '-c', 'submodule.recurse=false')
foreach ($voiceName in $voiceExpected.Keys) {
    $voiceGitSafety += @('-c', "safe.directory=$($voiceRoot.Replace('\','/'))/references/$voiceName")
}
if ($voiceManifest.repositories.Count -ne $voiceExpected.Count) { throw 'Unexpected reference count.' }
$voiceSeen = @{}
foreach ($voiceRef in $voiceManifest.repositories) {
    if (-not $voiceExpected.ContainsKey($voiceRef.name) -or $voiceSeen.ContainsKey($voiceRef.name) -or
        $voiceRef.url -cne $voiceExpected[$voiceRef.name] -or
        $voiceRef.path -cne "references/$($voiceRef.name)" -or $voiceRef.revision -notmatch '^[0-9a-f]{40}$') {
        throw 'Refusing unknown reference/path/remote.'
    }
    $voiceSeen[$voiceRef.name] = $true
    $voicePath = Join-Path $voiceRoot $voiceRef.path
    $voiceModuleUrl = & git @voiceGitSafety -C $voiceRoot config --file .gitmodules --get "submodule.$($voiceRef.name).url"
    if ($LASTEXITCODE -ne 0 -or $voiceModuleUrl -cne $voiceRef.url) { throw 'Gitmodules and manifest URL differ.' }
    $voiceCachedUrl = & git @voiceGitSafety -C $voiceRoot config --local --get "submodule.$($voiceRef.name).url"
    if ($LASTEXITCODE -gt 1 -or ($voiceCachedUrl -and $voiceCachedUrl -cne $voiceRef.url)) {
        throw 'Cached submodule destination differs; refusing an unexpected network target.'
    }
    $voiceModulePath = & git @voiceGitSafety -C $voiceRoot config --file .gitmodules --get "submodule.$($voiceRef.name).path"
    if ($LASTEXITCODE -ne 0 -or $voiceModulePath -cne $voiceRef.path) { throw 'Gitmodules path mismatch.' }
    $voiceLink = & git @voiceGitSafety -C $voiceRoot ls-files --stage -- $voiceRef.path
    if ($LASTEXITCODE -ne 0 -or $voiceLink -notmatch "^160000 $($voiceRef.revision) 0") { throw 'Gitlink and manifest revision differ.' }
    if (Test-Path -LiteralPath (Join-Path $voicePath '.git')) {
        $voiceOrigin = & git @voiceGitSafety -C $voicePath remote get-url origin
        if ($LASTEXITCODE -ne 0 -or $voiceOrigin -cne $voiceRef.url) { throw 'Existing reference origin differs.' }
        $voiceStatus = @(& git @voiceGitSafety -C $voicePath status --porcelain)
        if ($LASTEXITCODE -ne 0) { throw 'Could not inspect reference state.' }
        if ($voiceStatus.Count) { throw "Preserving dirty checkout: $($voiceRef.name)" }
        $voiceHead = & git @voiceGitSafety -C $voicePath rev-parse HEAD
        if ($LASTEXITCODE -ne 0 -or $voiceHead -cne $voiceRef.revision) { throw "Existing checkout has a different HEAD; review manually: $($voiceRef.name)" }
    } elseif ((Test-Path -LiteralPath $voicePath) -and @(Get-ChildItem -LiteralPath $voicePath -Force).Count) {
        throw "Preserving nonempty unrecognized folder: $voicePath"
    }
}
foreach ($voiceRef in $voiceManifest.repositories) {
    if ($PSCmdlet.ShouldProcess($voiceRef.url, "Restore pinned top-level checkout $($voiceRef.path), no recursion")) {
        & git @voiceGitSafety -C $voiceRoot submodule update --init --depth 1 -- $voiceRef.path
        if ($LASTEXITCODE -ne 0) { throw "Reference restore failed: $($voiceRef.name). Authenticate for private repositories if needed." }
        $voicePath = Join-Path $voiceRoot $voiceRef.path
        & git @voiceGitSafety -C $voicePath config --local core.hooksPath NUL
        if ($LASTEXITCODE -ne 0) { throw 'Failed to disable reference hooks.' }
        & git @voiceGitSafety -C $voicePath remote set-url --push origin DISABLED
        if ($LASTEXITCODE -ne 0) { throw 'Failed to disable reference push.' }
    }
}
Write-Output 'Reference restore completed or previewed. No nested submodules, dependencies or runtime data were installed.'
