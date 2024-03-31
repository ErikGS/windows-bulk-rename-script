param(
  [switch]$version
)

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
$dir = "C:\bren\"
$log = $dir + "log.txt"
$bren = $dir + "bren.ps1"
$bren_cmd = $dir + "bren.cmd"
$bren_src = ".\bren.ps1"
$usr_path_var_bkp = $dir + ".\user-PATH-var_backup.txt"

# Utiliy for checking version
if ($version){
  Write-Host "Current version: $ver" -ForegroundColor Green
  Write-Host ""
  Break
}

# Utility for logging a string in the console and into a file
# _format: info, succes, warning, error
# _format can also be a color (Black, White, Red, Blue, etc.) 
function Log {
  param(
    [string]$_string,
    [string]$_format
  )
  switch ($_format) {
    info { Write-Host $_string -ForegroundColor Cyan > $log }
    success { Write-Host $_string -ForegroundColor Green > $log }
    warning { Write-Warning $_string > $log }
    error { Write-Error $_string > $log }
    Default { Write-Host _string -ForegroundColor $_format > $log  }
  }
}

# Utility for getting the User PATH variable
function GetUserPathVar {
  return [Environment]::GetEnvironmentVariable("path", "user");
}

# Checks if bren is already in path to present an uninstall dialog according
if (GetUserPathVar.Contains($bren_cmd)) {

  # Uninstall dialog
  Write-Host "Bren is INSTALLED in $dir" -ForegroundColor Green

  Write-Warning "Do you want to UNINSTALL bren?"

  if (Read-Host "Choice (Y/YES or N/NO)" -eq 'Y' -or $confirm -eq "YES") {

    Log("Begin uninstalling...", "info")

    # Removes bren from the user PATH variable
    [Environment]::SetEnvironmentVariable("path", (GetUserPathVar.Remove(';' + $bren_cmd)), "User");
    
    Remove-Item $bren

    Log("Bren was uninstalled.", "success")

    Break
  }

  Log("Operation Aborted.", "error")
  Break
}


# Install dialog
Write-Warning "May the installer procceed?"

if (Read-Host "Choice (Y/YES or N/NO)" -eq 'Y' -or $confirm -eq "YES") {

  Log("Begin installation...", "warning")

  # Makes the directory and place a copy of bren
  New-Item $dir

  Log("Copying '$bren_sr'c to '$bren'...", "info")

  Copy-Item -Path $bren_src -Destination $bren

  Log("'$bren_src' was copied to '$bren'.", "success")


  # Saves a backup of the PATH variable before adding bren.
  Log("Saving a backup of current user PATH variable here and in '$usr_path_var_bkp'...", "info")

  GetUserPathVar | Out-File -FilePath $usr_path_var_bkp 

  Copy-Item -Path $usr_path_var_bkp -Destination ".\"

  Log("A backup of current user PATH variable was saved here and in '$usr_path_var_bkp'.", "success")


  # Adds bren to the user PATH variable
  Log("Adding bren to user PATH variable...", "info")

  "powershell.exe -NoProfile -File $bren" > $bren_cmd

  [Environment]::SetEnvironmentVariable('path', (GetUserPathVar + ';' + $bren_cmd), 'User');

  Log("Bren was added to the user PATH variable.", "success")


  # Makes a copy the installer too, so there's a backup if needed, likely to uninstall
  Log(" ")
  Log("Finishing...", "info")
  Log(" ")

  Copy-Item -Path $installer -Destination $dir
  Copy-Item -Path $log -Destination ".\"

  Log("Installation Done.", "success")
  Log(" ")
  Break
}

Log("Operation Aborted.", "error")
Break