#cls 

# Parameter Eingabe von aussen innherhalb Skript
# MUSS AM START EINES Programms dran komment!
param(  
    [Parameter(Mandatory=$true)]
    [string]$test
)


Write-Host "Hello";
Write-Host "Bye"
Write-Host $test
#Write-Host $server
    
#Read-Host "Press enter to continue."