# AddUsers.ps1
# Powershell Script to add AD Users from a CSV file.
# Version 0.1 
# last edit: 2024-07-01

# TODO: Fügen Sie dem Skript eine Möglichkeit hinzu die CSV Datei über einen Übergabeparameter anzugeben. 
# Parameter help description
param(
    [Parameter(Mandatory = $true)]
    [string]$csvPath,

    [string]$server
)

if (-not ([System.IO.File]::Exists($csvPath))) {
    Write-Host "CSV Datei $csvPath existiert nicht!"
	Read-Host "Datei ($csvPath) exitstiert nicht."
    exit 1 # 1 indiziert Fehler.
}

#$csvPath = "$PSScriptRoot\Students.csv"  # PsScriptRoot zeigt auf Order in der das Script liegt.

$userData = Import-Csv -Path $csvPath

$basePath = "OU=BSAP,DC=bsap,DC=exam"  # Muss angepasst werden auf den Server. Evtl auch als Übergabeparameter setzten oder abfragen?

# TODO:
# STrukturieren Sie den Code in 3 Funktionen. 
# Add-Users
# Add-Ou -Path "" -Name ""
# Add-Groups


foreach ($entry in $userData) 
{
    if ($entry.Klasse -eq "IAV2325")
    {
        Write-Host "$($entry.Vorname) ist in der Klasse $($entry.Klasse)"
        # Create vars for the new user.
        $username =  ($entry.Vorname + "." + $entry.Nachname).ToLower()
        $mail = $username + "@schule.de"
        $password = $entry.Geburtstag
        # convert passwort from string to SecureString
        $accountPW = ConvertTo-SecureString -AsPlainText $password -Force
        
        $ouName = $entry.Klasse
        $ouPath = "OU=Benutzer,$basePath"
        # Check if the OU already exists
        if (-not (Get-ADOrganizationalUnit -Filter { Name -eq $ouName })) {
            # Create the OU
            New-ADOrganizationalUnit -Name $ouName -Path $ouPath -ProtectedFromAccidentalDeletion $false
        } else {
            Write-Host "OU '$ouName' already exists."
        }
     
        # set ou path where the user should be added.
        $ouUserPath = "OU=$ouName,$ouPath" # "OU=$ouName,OU=Benutzer,OU=BSAP,DC=bsap,DC=exam" 

        # TODO: Erweitern Sie den Befehl New-ADUser sodass alle Felder unter Allgemein ausgefüllt sind.
        New-AdUser -SamAccountName $username -UserPrincipalName $username -Name $username -AccountPassword $accountPW  -Enabled $true -ChangePasswordAtLogon $true -Path $ouUserPath -EmailAddress $mail -GivenName $entry.Vorname -Surname $entry.Nachname -Description "Ein Schüler Account" -Office "A120" -DisplayName " $($entry.Vorname) $($entry.Nachname)" 


        # TODO: Erstellen Sie eine Gruppe mit den Namen der Klasse unter der OU Gruppen und fügen Sie alle Schüler*innen hinzu.
        #Check if ou already exists
        $groupName = $entry.Klasse
        $groupPath = "OU=Gruppen,$basePath"
        if (-not (Get-ADGroup -Filter { Name -eq $groupName })) {
            New-ADGroup -Name $groupName -GroupScope DomainLocal -GroupCategory Security -Path $groupPath 
        } else {
            Write-Host "Group $groupName already exists." 
        }
        # Add user to group
        Add-ADGroupMember -Identity $groupName -Members $username

            
    }
}

Write-Host "Alles fertig."


# Script offen halten am Ende
Read-Host "Press enter to continue."  