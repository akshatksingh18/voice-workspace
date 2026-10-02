[CmdletBinding(SupportsShouldProcess)]
param()

$ErrorActionPreference = 'Stop'
$voiceRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$voiceExe = Join-Path $voiceRoot 'runtime\handy\handy.exe'
$voiceMarker = Join-Path $voiceRoot 'runtime\handy\portable'
$voiceModel = Join-Path $voiceRoot 'runtime\handy\Data\models\ggml-small.bin'
$voiceStore = Join-Path $voiceRoot 'runtime\handy\Data\settings_store.json'
foreach ($voiceRequired in @($voiceExe, $voiceMarker, $voiceModel, $voiceStore)) {
    if (-not (Test-Path -LiteralPath $voiceRequired -PathType Leaf)) {
        throw "Missing prepared input: $voiceRequired. Read setup.md; this launcher does not download files."
    }
}
if (-not (Get-Content -LiteralPath $voiceMarker -Raw).StartsWith('Handy Portable Mode')) {
    throw 'Portable marker is invalid; refusing to launch against the normal user profile.'
}
if ((Get-Item -LiteralPath $voiceModel).Length -ne 487601967) {
    throw 'Whisper Small model size mismatch. Run verify-workspace.ps1 -CheckRuntime -HashModel.'
}
$voiceSettings = (Get-Content -LiteralPath $voiceStore -Raw | ConvertFrom-Json).settings
if ($voiceSettings.selected_model -ne 'small' -or $voiceSettings.post_process_enabled -or
    $voiceSettings.auto_submit -or $voiceSettings.always_on_microphone) {
    throw 'Test profile differs from the safe baseline. Review testing-guide.md before launching.'
}
$voiceConflicts = @(Get-Process | Where-Object {
    $_.ProcessName -match '^(handy|OpenWhispr.*|open-whispr)$'
})
if ($voiceConflicts.Count -gt 0) {
    throw 'Close running Handy/OpenWhispr instances from their tray first. No process was killed.'
}
if ($PSCmdlet.ShouldProcess($voiceExe, 'Open isolated Handy test GUI (does not record)')) {
    $voiceProcess = Start-Process -FilePath $voiceExe -WorkingDirectory (Split-Path $voiceExe) -PassThru
    Write-Output "Opened Handy, process $($voiceProcess.Id). Select microphone, focus Notepad, then use the configured Transcribe shortcut."
    Write-Warning 'This is raw ASR only; the required Roman-Hinglish output conversion is not implemented yet.'
}
