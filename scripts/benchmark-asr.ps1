[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ModelFile,
    [Parameter(Mandatory)][string]$AudioFile,
    [string]$GoldFile,
    [string]$VocabularyFile,
    [string]$Device = 'NVIDIA GeForce MX450',
    [ValidateRange(1,20)][int]$Runs = 3,
    [ValidateSet('batch','stream')][string]$Mode = 'stream'
)
$ErrorActionPreference = 'Stop'
$voiceRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$voiceRuntime = Join-Path $voiceRoot 'runtime\desktop'
$voiceExe = Join-Path $voiceRuntime 'asr_latency.exe'
if (Get-Process -Name voice-workspace,handy -ErrorAction SilentlyContinue) { throw 'Quit Voice Workspace first; do not benchmark competing models.' }
$voiceArgs = @()
foreach ($voicePath in @($ModelFile, $AudioFile)) {
    $voiceResolved = (Resolve-Path -LiteralPath $voicePath).Path
    if (-not $voiceResolved.StartsWith("$voiceRoot\", [StringComparison]::OrdinalIgnoreCase) -or
        $voiceResolved -match '["\r\n]') { throw 'Inputs must be files inside Voice Workspace.' }
    $voiceArgs += '"' + $voiceResolved + '"'
}
if ($Device -match '["\r\n]') { throw 'Invalid device selector.' }
$voiceArgs += @('"' + $Device + '"', "$Runs", $Mode)
if ($VocabularyFile -and -not $GoldFile) { throw 'Vocabulary scoring also requires GoldFile.' }
foreach ($voiceTextInput in @($GoldFile, $VocabularyFile)) {
    if (-not $voiceTextInput) { continue }
    $voiceTextPath = (Resolve-Path -LiteralPath $voiceTextInput).Path
    if (-not $voiceTextPath.StartsWith("$voiceRoot\", [StringComparison]::OrdinalIgnoreCase) -or
        $voiceTextPath -match '["\r\n]') { throw 'Scoring text must stay inside Voice Workspace.' }
    $voiceArgs += '"' + $voiceTextPath + '"'
}
$voiceRunId = [guid]::NewGuid().ToString('N')
$voiceOutput = Join-Path $voiceRuntime "Data\bench-$voiceRunId.json"
$voiceError = Join-Path $voiceRuntime "Data\bench-$voiceRunId.stderr"
$voiceProcess = Start-Process -FilePath $voiceExe -ArgumentList $voiceArgs -WorkingDirectory $voiceRuntime -WindowStyle Hidden -PassThru -Wait -RedirectStandardOutput $voiceOutput -RedirectStandardError $voiceError
if ($voiceProcess.ExitCode -ne 0) { throw "Benchmark failed ($($voiceProcess.ExitCode)); inspect the local diagnostic file, not a public upload." }
$voiceReport = Get-Content -LiteralPath $voiceOutput | Where-Object { $_.StartsWith('{') } | Select-Object -Last 1
if (-not $voiceReport) { throw 'Missing benchmark result.' }
# The diagnostic deliberately emits aggregate timings/errors, never recognized text.
$voiceReport | ConvertFrom-Json
