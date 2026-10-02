[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ModelFile,
    [Parameter(Mandatory)][string]$AudioFile,
    [string]$GoldFile,
    [string]$Device = 'NVIDIA GeForce MX450',
    [ValidateRange(1,20)][int]$Runs = 3,
    [ValidateSet('batch','stream')][string]$Mode = 'stream'
)
$ErrorActionPreference = 'Stop'
$voiceRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$voiceRuntime = Join-Path $voiceRoot 'runtime\handy'
$voiceExe = Join-Path $voiceRuntime 'asr_latency.exe'
if (Get-Process -Name handy -ErrorAction SilentlyContinue) { throw 'Quit Handy first; do not benchmark competing models.' }
$voiceArgs = @()
foreach ($voicePath in @($ModelFile, $AudioFile)) {
    $voiceResolved = (Resolve-Path -LiteralPath $voicePath).Path
    if (-not $voiceResolved.StartsWith("$voiceRoot\", [StringComparison]::OrdinalIgnoreCase) -or
        $voiceResolved -match '["\r\n]') { throw 'Inputs must be files inside Voice Workspace.' }
    $voiceArgs += '"' + $voiceResolved + '"'
}
if ($Device -match '["\r\n]') { throw 'Invalid device selector.' }
$voiceArgs += @('"' + $Device + '"', "$Runs", $Mode)
if ($GoldFile) {
    $voiceGold = (Resolve-Path -LiteralPath $GoldFile).Path
    if (-not $voiceGold.StartsWith("$voiceRoot\", [StringComparison]::OrdinalIgnoreCase) -or
        $voiceGold -match '["\r\n]') { throw 'Gold text must stay inside Voice Workspace.' }
    $voiceArgs += '"' + $voiceGold + '"'
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
