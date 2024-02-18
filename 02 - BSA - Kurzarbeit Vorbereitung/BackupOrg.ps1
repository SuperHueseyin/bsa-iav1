# This will be a powershell script to backup files.

# ---------------
# Parameter
# ---------------
param (
	#[Parameter(Mandatory)]
	[string[]]$srcDir = ($(Join-Path $env:USERPROFILE "Desktop/Test"), $(Join-Path $env:USERPROFILE "Desktop/Beta")),
	[string]$dstDir = $(Join-Path $env:USERPROFILE "Desktop/MyBackupLocation")
)


# ---------------
# Functions
# ---------------

# Create BackupDir
Function Create-BackupDir {
	param (
		[Parameter(Mandatory)]
		[string]$path
	)
	Write-Host "Create BackupDir at $path"
    New-Item -Path $path -ItemType Directory 
}

# Delete BackupDir
Function Delete-OldBackups {

}
# Check file Paths
Function Check-Dirs {
    # Wir wollen überprüfen ob es die Ordner überhaupt gibt.
    foreach ($dir in $srcDir){
        if(!(Test-Path -Path $dir)){
            # Directory not found
            Write-Host "Source Directory ($dir) does not exits"
            return $false
        }
    }

    if(-not (Test-Path $dstDir)){
        Write-Host "Destination Directory ($dstDir) does not exits."
        $userInput = Read-Host "Do you want to create it? [y] Yes [n] No."
        if ($userInput -eq 'y') {
            Create-BackupDir -path $dstDir
            return $true
        }
        return $false 
    }
}

# Make Backup
Function Make-Backup {
    # Soll alle übergebenen Verzeichnisse in ein Zip packen und mit Backup_DATUM_ZEIT.zip benennen.
    param (
        [string[]]$dirPaths
    )

    # Wie bekomme ich die aktuelle Zeit?  2024-02-06_14-14-14  (Jahr Monat Tag _ Stunde Minute Sekunde)
    $currentDateTime = Get-Date -Format ("yyyy-MM-dd_HH-mm-ss")

    # Wie erstelle ich ein ZIP?
    $zipPath = (Join-Path $dstDir "Backup_$currentDateTime.zip")
    Compress-Archive -Path $dirPaths -DestinationPath $zipPath

    Write-Host "Backup ($zipPath) erfolreich erstellt. "
}

# ---------------
# Script
# ---------------
if ($(Check-Dirs) -eq $false) {
	Write-Host "Abort due to not existing directories."
} else {
	Write-Host "Both folders do exist. Make-Backup ..."
	# Make new Backup
	$success = Make-Backup $srcDir

	if ($success -eq $true) {
		# Delete old Backups
		Delete-OldBackups $dstDir -Keep 3
	}

}

#Read-Host "Press enter to continue ..."