[CmdletBinding(SupportsShouldProcess)]
param()

$ErrorActionPreference = 'Stop'
$voiceRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$voiceExe = Join-Path $voiceRoot 'runtime\desktop\voice-workspace.exe'
$voiceMarker = Join-Path $voiceRoot 'runtime\desktop\portable'
$voiceStore = Join-Path $voiceRoot 'runtime\desktop\Data\settings_store.json'
foreach ($voiceRequired in @($voiceExe, $voiceMarker, $voiceStore)) {
    if (-not (Test-Path -LiteralPath $voiceRequired -PathType Leaf)) {
        throw "Missing prepared input: $voiceRequired. Read setup.md; this launcher does not download files."
    }
}
if (-not (Get-Content -LiteralPath $voiceMarker -Raw).StartsWith('Handy Portable Mode')) {
    throw 'Portable marker is invalid; refusing to launch against the normal user profile.'
}
$voiceSettings = (Get-Content -LiteralPath $voiceStore -Raw | ConvertFrom-Json).settings
. (Join-Path $PSScriptRoot 'model-input.ps1')
$null = Get-VoiceModelInput -Root $voiceRoot -ModelId $voiceSettings.selected_model
if ($voiceSettings.post_process_enabled -or $voiceSettings.translate_to_english -or
    $voiceSettings.roman_hinglish_enabled -or $voiceSettings.selected_language -ne 'en' -or -not $voiceSettings.preload_model -or
    $voiceSettings.auto_submit -or $voiceSettings.always_on_microphone -or
    $voiceSettings.autostart_enabled) {
    throw 'Test profile differs from the safe baseline. Review testing-guide.md before launching.'
}
$voiceConflicts = @(Get-Process | Where-Object {
    $_.ProcessName -match '^(voice-workspace|handy|OpenWhispr.*|open-whispr)$'
})
if ($voiceConflicts.Count -gt 0) {
    throw 'Close running Voice Workspace, Handy or OpenWhispr instances from their tray first. No process was killed.'
}
if ($PSCmdlet.ShouldProcess($voiceExe, 'Open isolated Voice Workspace test GUI (does not record)')) {
    $voiceProbe = Start-Process -FilePath $voiceExe -ArgumentList @('--stats-only', '--help') -WindowStyle Hidden -PassThru -Wait
    if ($voiceProbe.ExitCode -ne 0) {
        throw 'This executable lacks the required features; rebuild it from voice-workspace-desktop main, not stock Handy.'
    }
    $voiceProcess = Start-Process -FilePath $voiceExe -WorkingDirectory (Split-Path $voiceExe) -PassThru
    Write-Output "Opened Voice Workspace, process $($voiceProcess.Id). Select microphone, focus Notepad, then use the configured Transcribe shortcut."
    Write-Output 'Wait for model preparation to finish. English only; translation, Hinglish and AI cleanup are off. Live accuracy and release-to-paste need acceptance testing.'
    $voiceModeLabel = if ($voiceSettings.prefer_batch_transcription) { 'full recording (no live partial preview)' } else { 'streaming when supported' }
    Write-Output "Recognition mode: $voiceModeLabel; manual vocabulary count: $($voiceSettings.custom_words.Count)."
}
