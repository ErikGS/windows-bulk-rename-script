# Presentation
Write-Host "----------------BRen-Installer----------------" -ForegroundColor Green
Write-Host "       Bulk-Rename operation by Erik GS       " -ForegroundColor Yellow
Write-Host "         [https://github.com/ErikGS]          " -ForegroundColor Cyan
Write-Host "--------------------v1.0----------------------" -ForegroundColor Green
Write-Host ""
Write-Host "To have a script file available as command in a console or terminal" -ForegroundColor Yellow
Write-Host "its path has to be added to the user PATH variable. This installer" -ForegroundColor Yellow
Write-Host "will place the script file in (C:\bren\) and then add it to PATH." -ForegroundColor Yellow
Write-Host "NOTE: a backup of the current PATH will be saved in 'C:\bren\user-path-bkp.txt'."
Write-Host ""

$ver = "v1.0"
$bren = 'C:\bren\bren.ps1'
$old_path = [Environment]::GetEnvironmentVariable('path', 'user');

# Checks if bren is already in path to present an uninstall dialog according
if ($old_path.Contains($bren)) {
  # Uninstall dialog
  Write-Host "Bren is INSTALLED in $bren" -ForegroundColor Red
  Write-Host "Do you want to UNINSTALL bren?" -ForegroundColor Red
  $uninstall = Read-Host "Choice (Y/YES or N/NO)"
  if ($uninstall -eq 'Y' -or $confirm -eq 'YES') {
    Write-Host "[$((Get-Date).ToString("yyyy:MM:dd HH:MM"))]: Begin uninstall" > Out-File -FilePath ".\log.txt"
    # Removes bren from the user PATH variable
    $old_path = $old_path.Remove(';' + $bren)
    [Environment]::SetEnvironmentVariable('path', $old_path,'User');
    Write-Host "[$((Get-Date).ToString("yyyy:MM:dd HH:MM"))]: Bren was uninstalled. You can delete the files." -ForegroundColor Cyan > Out-File -FilePath ".\log.txt"
    Break
  }
  Write-Error "Operation Aborted." | Out-File -FilePath ".\log.txt"
  Break
}

# Install dialog
$new_path = $old_path + ';' + $bren
Write-Warning "May the installer procceed?"
$install = Read-Host "Choice (Y/YES or N/NO)"
if ($install -eq 'Y' -or $confirm -eq 'YES') {
  # Begin installation (moving to C:\bren\ and adding to PATH)
  mkdir "C:\bren\" > $null
  Write-Warning "[$((Get-Date).ToString("yyyy:MM:dd HH:MM"))]: Begin installation" > Out-File -FilePath ".\log.txt"
  Write-Host "Copying bren.ps1 to 'C:\bren\bren.ps1'..." -ForegroundColor Cyan
  Copy-Item -Path ".\bren.ps1" -Destination "C:\bren\bren.ps1"
  Write-Host "bren.ps1 was copied to 'C:\bren\bren.ps1'." -ForegroundColor Green > Out-File -FilePath ".\log.txt"

  # Saves a backup of the PATH variable before adding bren.
  Write-Host "Saving a backup of current user PATH variable here and in C:\bren\ as 'user-PATH-var_backup.txt'..." -ForegroundColor Cyan
  $old_path | Out-File -FilePath ".\user-PATH-var_backup.txt"
  Copy-Item -Path ".\user-PATH-var_backup.txt" -Destination "C:\bren\user-PATH-var_backup.txt"
  Write-Host "A backup of current user PATH variable was saved here and in 'C:\bren\user-PATH-var_backup.txt'." -ForegroundColor Green > Out-File -FilePath ".\log.txt"

  # Adds bren to the user PATH variable
  Write-Host "Adding bren to user PATH variable..." -ForegroundColor Cyan
  [Environment]::SetEnvironmentVariable('path', $new_path,'User');
  Write-Host "Bren was added to the user PATH variable." -ForegroundColor Green  > Out-File -FilePath ".\log.txt"

  # Moves the installer too, so there's a backup if needed
  Write-Host " " > Out-File -FilePath ".\log.txt"
  Write-Host "The installer and this log will be placed in 'C:\bren\' too." > Out-File -FilePath ".\log.txt"
  Write-Host " " > Out-File -FilePath ".\log.txt"
  Copy-Item -Path ".\install.ps1" -Destination "C:\bren\install.ps1"
  Copy-Item -Path ".\log.txt" -Destination "C:\bren\log.txt"

  Write-Host "[$((Get-Date).ToString("yyyy:MM:dd HH:MM"))]: Installation Done." -ForegroundColor Green > Out-File -FilePath ".\log.txt"
  #Write-Host " " > Out-File -FilePath ".\log.txt"
  Break
}

Write-Error "Operation Aborted."
Break

if ($version){
  Write-Host "Current version: $ver" -ForegroundColor Green
  Write-Host ""
  Break
}

Break