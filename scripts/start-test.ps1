[CmdletBinding(SupportsShouldProcess)]
param()

$ErrorActionPreference = 'Stop'
$voiceRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$voiceExe = Join-Path $voiceRoot 'runtime\handy\handy.exe'
$voiceMarker = Join-Path $voiceRoot 'runtime\handy\portable'
$voiceStore = Join-Path $voiceRoot 'runtime\handy\Data\settings_store.json'
foreach ($voiceRequired in @($voiceExe, $voiceMarker, $voiceStore)) {
    if (-not (Test-Path -LiteralPath $voiceRequired -PathType Leaf)) {
        throw "Missing prepared input: $voiceRequired. Read setup.md; this launcher does not download files."
    }
}
if (-not (Get-Content -LiteralPath $voiceMarker -Raw).StartsWith('Handy Portable Mode')) {
    throw 'Portable marker is invalid; refusing to launch against the normal user profile.'
}
$voiceSettings = (Get-Content -LiteralPath $voiceStore -Raw | ConvertFrom-Json).settings
$voiceModels = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'local-models.json') -Raw | ConvertFrom-Json
$voiceModelInfo = $voiceModels.PSObject.Properties[$voiceSettings.selected_model].Value
if (-not $voiceModelInfo) { throw 'Unsupported test model; review setup.md.' }
$voiceModel = Join-Path $voiceRoot "runtime\handy\Data\models\$($voiceModelInfo.filename)"
if (-not (Test-Path -LiteralPath $voiceModel) -or (Get-Item -LiteralPath $voiceModel).Length -ne $voiceModelInfo.bytes) {
    throw 'Selected model missing or size mismatch. Run verify-workspace.ps1 -CheckRuntime -HashModel.'
}
if ($voiceSettings.post_process_enabled -or $voiceSettings.translate_to_english -or
    -not $voiceSettings.roman_hinglish_enabled -or -not $voiceSettings.preload_model -or
    $voiceSettings.auto_submit -or $voiceSettings.always_on_microphone -or
    $voiceSettings.update_checks_enabled -or $voiceSettings.autostart_enabled) {
    throw 'Test profile differs from the safe baseline. Review testing-guide.md before launching.'
}
$voiceConflicts = @(Get-Process | Where-Object {
    $_.ProcessName -match '^(handy|OpenWhispr.*|open-whispr)$'
})
if ($voiceConflicts.Count -gt 0) {
    throw 'Close running Handy/OpenWhispr instances from their tray first. No process was killed.'
}
if ($PSCmdlet.ShouldProcess($voiceExe, 'Open isolated Handy test GUI (does not record)')) {
    $voiceProbe = Start-Process -FilePath $voiceExe -ArgumentList @('--stats-only', '--help') -WindowStyle Hidden -PassThru -Wait
    if ($voiceProbe.ExitCode -ne 0) {
        throw 'This executable lacks the required fork features; rebuild/copy the updated Handy fork, not stock Handy.'
    }
    $voiceProcess = Start-Process -FilePath $voiceExe -WorkingDirectory (Split-Path $voiceExe) -PassThru
    Write-Output "Opened Handy, process $($voiceProcess.Id). Select microphone, focus Notepad, then use the configured Transcribe shortcut."
    Write-Output 'Wait for model preparation to finish. Roman-Hinglish conversion is experimental; recognition and live paste need acceptance testing.'
}
