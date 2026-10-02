# Shared read-only resolver. Dot-source from launch/verification scripts.
function Get-VoiceModelInput {
    param([Parameter(Mandatory)][string]$Root, [Parameter(Mandatory)][string]$ModelId, [switch]$HashModel)
    $voiceModels = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'local-models.json') -Raw | ConvertFrom-Json
    $voiceProperty = $voiceModels.PSObject.Properties[$ModelId]
    if (-not $voiceProperty) { throw 'Unsupported model in test profile; review setup.md.' }
    $voiceInfo = $voiceProperty.Value
    $voiceData = [IO.Path]::GetFullPath((Join-Path $Root 'runtime\handy\Data'))
    if ([IO.Path]::IsPathRooted($voiceInfo.relativePath)) { throw 'Model path must be relative.' }
    $voiceModel = [IO.Path]::GetFullPath((Join-Path $voiceData $voiceInfo.relativePath))
    if (-not $voiceModel.StartsWith("$voiceData\", [StringComparison]::OrdinalIgnoreCase) -or
        -not (Test-Path -LiteralPath $voiceModel -PathType Leaf) -or
        (Get-Item -LiteralPath $voiceModel).Length -ne $voiceInfo.bytes) {
        throw 'Selected model is missing, outside isolated Data, or has a size mismatch.'
    }
    if ($HashModel -and (Get-FileHash -LiteralPath $voiceModel -Algorithm SHA256).Hash.ToLowerInvariant() -cne $voiceInfo.sha256) {
        throw 'Model checksum mismatch.'
    }
    return $voiceModel
}
