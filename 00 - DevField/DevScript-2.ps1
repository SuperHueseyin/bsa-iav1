# Hüseyin Bagriacik
# 23.01.2024
# BSA: Parameter über Powershell übergeben an das Skript - Skript Übergabe Parameter


# Mandatory -> erzwingt die Überprüfung von dem Eingabeparameter
#           -> true: Skript fortsetzen
#           -> false: Skript wird beendet und Console geschlossen

param(
    [Parameter(Mandatory = $true)]
    [string]$CSV
)

# Überprüfung ist CSV Paramter null 
if ($null -eq $CSV) {
    Write-Host "String fuer -CSV Variable erwartet, erneut skript starten"
    Write-Host "Versuche: ./<Skipt_Name> -CSV <Dateiname>"
    exit 1
}

# Überprüfung Datei Pfad exestiert / oder nicht
if (-not ([System.IO.File]::Exists($CSV))) {
    Write-Host "CSV Datei $CSV exestiert nicht!"
    exit 1
}

Write-Host $CSV

