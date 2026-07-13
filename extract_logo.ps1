$svgPath = 'm:\flutter\tabare3\assets\icons\icon6.svg'
$outPath = 'm:\flutter\tabare3\assets\images\icon6.png'

$svg = [System.IO.File]::ReadAllText($svgPath)
$marker = 'data:image/png;base64,'
$start = $svg.IndexOf($marker) + $marker.Length
$end = $svg.IndexOf('"', $start)
$b64 = $svg.Substring($start, $end - $start)
$bytes = [System.Convert]::FromBase64String($b64)
[System.IO.File]::WriteAllBytes($outPath, $bytes)
Write-Host "Done. PNG size: $($bytes.Length) bytes"
