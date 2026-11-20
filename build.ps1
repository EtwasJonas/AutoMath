# Baut die fertige Einzeldatei AutoMath.html aus dem Template + vendor-Bibliothek.
# Aufruf:  powershell -File build.ps1   (oder im Ordner ausführen)
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

$html = Get-Content -Raw -Encoding UTF8 src\AutoMath.template.html
$lib  = Get-Content -Raw -Encoding UTF8 vendor\temml.min.js
$css  = Get-Content -Raw -Encoding UTF8 vendor\Temml-Local.css
$b64  = [Convert]::ToBase64String([IO.File]::ReadAllBytes("$PWD\vendor\Temml.woff2"))

# Schrift direkt einbetten, damit die Datei offline ohne Zusatzdateien funktioniert
$css = $css.Replace("url('Temml.woff2') format('woff2')", "url(data:font/woff2;base64,$b64) format('woff2')")
$html = $html.Replace('/*__TEMML_CSS__*/', $css).Replace('/*__TEMML_JS__*/', $lib)

[IO.File]::WriteAllText("$PWD\AutoMath.html", $html, (New-Object System.Text.UTF8Encoding($false)))
# Kopie als index.html, damit GitHub Pages die App direkt unter der Root-URL ausliefert
[IO.File]::WriteAllText("$PWD\index.html", $html, (New-Object System.Text.UTF8Encoding($false)))
Write-Host ("AutoMath.html erstellt: " + (Get-Item AutoMath.html).Length + " Bytes (inkl. index.html für GitHub Pages)")
