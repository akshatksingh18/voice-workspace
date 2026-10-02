[CmdletBinding()]
param([switch]$CheckRuntime, [switch]$HashModel)

$ErrorActionPreference = 'Stop'
$voiceRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$voiceManifest = Get-Content -LiteralPath (Join-Path $voiceRoot 'repositories.json') -Raw | ConvertFrom-Json
$voiceAllowed = @('handy','granola-alt','openwhispr','anarlog','minutes','open-granola','omascribe','meetily','steno')
$voiceGitSafety = @('-c', "safe.directory=$($voiceRoot.Replace('\','/'))", '-c', 'core.hooksPath=NUL', '-c', 'submodule.recurse=false')
foreach ($voiceName in $voiceAllowed) {
    $voiceGitSafety += @('-c', "safe.directory=$($voiceRoot.Replace('\','/'))/references/$voiceName")
}
if ($voiceManifest.repositories.Count -ne $voiceAllowed.Count) { throw 'Unexpected reference count.' }
$voiceSeen = @{}
foreach ($voiceRef in $voiceManifest.repositories) {
    if ($voiceRef.name -notin $voiceAllowed -or $voiceSeen.ContainsKey($voiceRef.name) -or
        $voiceRef.path -cne "references/$($voiceRef.name)" -or $voiceRef.revision -notmatch '^[0-9a-f]{40}$') {
        throw 'Invalid or duplicate reference manifest entry.'
    }
    $voiceSeen[$voiceRef.name] = $true
    $voicePath = Join-Path $voiceRoot $voiceRef.path
    if (-not (Test-Path -LiteralPath (Join-Path $voicePath '.git'))) { throw "Missing checkout: $($voiceRef.name)" }
    $voiceHead = & git @voiceGitSafety -C $voicePath rev-parse HEAD
    if ($LASTEXITCODE -ne 0 -or $voiceHead -cne $voiceRef.revision) { throw "Wrong source revision: $($voiceRef.name)" }
    $voiceLink = & git @voiceGitSafety -C $voiceRoot ls-files --stage -- $voiceRef.path
    if ($LASTEXITCODE -ne 0 -or $voiceLink -notmatch "^160000 $($voiceRef.revision) 0") {
        throw "Gitlink does not match manifest: $($voiceRef.name)"
    }
    $voiceRemote = & git @voiceGitSafety -C $voicePath remote get-url origin
    if ($LASTEXITCODE -ne 0) { throw 'Could not read reference remote.' }
    $voicePush = & git @voiceGitSafety -C $voicePath remote get-url --push origin
    if ($LASTEXITCODE -ne 0) { throw 'Could not read reference push remote.' }
    if ($voiceRemote -cne $voiceRef.url -or $voicePush -cne 'DISABLED') { throw "Unsafe/mismatched remote: $($voiceRef.name)" }
    $voiceStatus = @(& git @voiceGitSafety -C $voicePath status --porcelain)
    if ($LASTEXITCODE -ne 0) { throw 'Could not inspect reference state.' }
    if ($voiceStatus.Count -gt 0) { throw "Dirty evidence checkout: $($voiceRef.name)" }
    if (-not (Test-Path -LiteralPath (Join-Path $voicePath $voiceRef.licenseFile) -PathType Leaf)) {
        throw "Missing license source: $($voiceRef.name)"
    }
    Write-Output "Source OK: $($voiceRef.name) $($voiceHead.Substring(0,12))"
}
$voiceTracked = @(& git @voiceGitSafety -C $voiceRoot ls-files)
if ($LASTEXITCODE -ne 0) { throw 'Could not inspect tracked root files.' }
$voiceUnsafe = @($voiceTracked | Where-Object {
    $_ -match '^(runtime|private-tests|downloads)/' -or
    $_ -match '(^|/)\.env($|\.)|\.(wav|mp3|m4a|mp4|webm|onnx|gguf|bin|sqlite3?|db|pem|key|pfx|p12|exe|dll|zip|log)$'
})
if ($voiceUnsafe.Count) { throw "Unsafe tracked root files: $($voiceUnsafe -join ', ')" }
if ($HashModel -and -not $CheckRuntime) { throw '-HashModel requires -CheckRuntime.' }
if ($CheckRuntime) {
    $voiceExe = Join-Path $voiceRoot 'runtime\handy\handy.exe'
    $voiceMarker = Join-Path $voiceRoot 'runtime\handy\portable'
    $voiceStore = Join-Path $voiceRoot 'runtime\handy\Data\settings_store.json'
    foreach ($voiceRequired in @($voiceExe,$voiceMarker,$voiceStore,
        (Join-Path $voiceRoot 'runtime\handy\transcribe.dll'),
        (Join-Path $voiceRoot 'runtime\handy\onnxruntime.dll'))) {
        if (-not (Test-Path -LiteralPath $voiceRequired -PathType Leaf)) { throw "Missing runtime input: $voiceRequired" }
    }
    if (-not (Get-Content -LiteralPath $voiceMarker -Raw).StartsWith('Handy Portable Mode')) { throw 'Invalid portable marker.' }
    $voiceSettings = (Get-Content -LiteralPath $voiceStore -Raw | ConvertFrom-Json).settings
    $voiceModels = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'local-models.json') -Raw | ConvertFrom-Json
    $voiceModelInfo = $voiceModels.PSObject.Properties[$voiceSettings.selected_model].Value
    if (-not $voiceModelInfo) { throw 'Unsupported model in test profile.' }
    $voiceModel = Join-Path $voiceRoot "runtime\handy\Data\models\$($voiceModelInfo.filename)"
    if (-not (Test-Path -LiteralPath $voiceModel) -or (Get-Item -LiteralPath $voiceModel).Length -ne $voiceModelInfo.bytes) { throw 'Model missing or size mismatch.' }
    if ($HashModel -and (Get-FileHash -LiteralPath $voiceModel -Algorithm SHA256).Hash.ToLowerInvariant() -ne
        $voiceModelInfo.sha256) { throw 'Model checksum mismatch.' }
    if ($voiceSettings.selected_language -notin @('auto','hi') -or
        $voiceSettings.translate_to_english -or $voiceSettings.post_process_enabled -or
        -not $voiceSettings.roman_hinglish_enabled -or -not $voiceSettings.preload_model -or
        $voiceSettings.always_on_microphone -or $voiceSettings.auto_submit -or
        $voiceSettings.update_checks_enabled -or $voiceSettings.autostart_enabled -or
        $voiceSettings.transcribe_accelerator -notin @('auto','gpu') -or
        $voiceSettings.model_unload_timeout -ne 'never' -or $voiceSettings.ort_accelerator -ne 'cpu') {
        throw 'Baseline settings mismatch; inspect local profile and testing-guide.md.'
    }
    Write-Output 'Handy experimental profile/model inputs OK. This is not a physical ASR, hotkey or paste test.'
    Write-Output 'Roman-Hinglish and startup warm-up enabled; speech accuracy and instant insertion remain unverified.'
}
Write-Output 'Workspace verification passed; no network requests or recordings were made.'
