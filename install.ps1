param(
  [switch]$version
)

$ver = "v1.0"
$dir = "C:\bren\"
$log = $dir + "log.txt"
$bren = $dir + "bren.ps1"
$bren_cmd = $dir + "bren.cmd"
$bren_src = ".\bren.ps1"
$installer = ".\install.ps1"
$usr_path_var_bkp = $dir + ".\user-PATH-var_backup.txt"

# Presentation
Write-Host ""
Write-Host "----------------BRen-Installer----------------" -ForegroundColor Green
Write-Host "       Bulk-Rename operation by Erik GS       " -ForegroundColor Yellow
Write-Host "         [https://github.com/ErikGS]          " -ForegroundColor Cyan
Write-Host "--------------------v1.0----------------------" -ForegroundColor Green
Write-Host ""
Write-Host "To have a script file available as a command in a console or terminal" -ForegroundColor Yellow
Write-Host "its path has to be added to the user PATH variable. This installer" -ForegroundColor Yellow
Write-Host "will place the script file in '$dir' and then add it to the PATH." -ForegroundColor Yellow
Write-Host "NOTE: a backup of the current PATH will be saved in '$usr_path_var_bkp'."
Write-Host ""

# Utiliy for checking version
if ($version){
  Write-Host "Current version: $ver" -ForegroundColor Green
  Write-Host ""
  Break
}

# Utility for logging a string in the console and into a file
# _format: i, s, w, e
# _format can also be a color (Black, White, Red, Blue, etc.) 
function Log {
  param(
    [string]$string,
    [string]$color,
    [switch]$i,
    [switch]$s,
    [switch]$w,
    [switch]$e
  )

  if ($i) { Write-Host $string -ForegroundColor Cyan >> $log } return
  if ($s) { Write-Host $string -ForegroundColor Green >> $log } return
  if ($w) { Write-Warning $string >> $log } return
  if ($e) { Write-Error $string >> $log } return
  if ($color -is [System.ConsoleColor]) {
    Write-Host $string -ForegroundColor $color >> $LogCommandLifecycleEvent
    return
  }

  write-Host $string >> $log 
}

# Utility for getting the User PATH variable
function GetUserPathVar {
  return [Environment]::GetEnvironmentVariable("path", "user");
}

# Checks if bren is already in path to present an uninstall dialog according
if ((GetUserPathVar).Contains($bren_cmd)) {

  # Uninstall dialog
  Write-Host "Bren is INSTALLED in $dir" -ForegroundColor Green

  Write-Warning "Do you want to UNINSTALL bren?"

  if ((Read-Host "Choice (Y/YES or N/NO)") -eq 'Y' -or $confirm -eq "YES") {

    Log " "
    Log "Begin uninstalling..." -i

    # Removes bren from the user PATH variable
    [Environment]::SetEnvironmentVariable("path", (GetUserPathVar.Remove(';' + $bren_cmd)), "User");
    
    Remove-Item $bren

    Log "Bren was uninstalled." -s

    Break
  }

  Log "Operation Aborted." -e
  Break
}


# Install dialog
Write-Warning "May the installer procceed?"

if ((Read-Host "Choice (Y/YES or N/NO)") -eq 'Y' -or $confirm -eq "YES") {

  Log "Begin installation..." -w

  # Makes the directory and place a copy of bren
  mkdir $dir -Force > $null

  Log "Copying '$bren_src' to '$bren'..." -i

  Copy-Item -Path $bren_src -Destination $bren

  Log "'$bren_src' was copied to '$bren'." -s


  # Saves a backup of the PATH variable before adding bren.
  Log "Saving a backup of current user PATH variable here and in '$usr_path_var_bkp'..." -i

  GetUserPathVar | Out-File -FilePath $usr_path_var_bkp 

  Copy-Item -Path $usr_path_var_bkp -Destination ".\"

  Log "A backup of current user PATH variable was saved here and in '$usr_path_var_bkp'." -s


  # Adds bren to the user PATH variable
  Log "Adding bren to user PATH variable..." -i

  "powershell.exe -NoProfile -File $bren" > $bren_cmd

  [Environment]::SetEnvironmentVariable('path', (GetUserPathVar + ';' + $bren_cmd), 'User');

  Log "Bren was added to the user PATH variable." -s


  # Makes a copy the installer too, so there's a backup if needed, likely to uninstall
  Log " "
  Log "Finishing..." -i
  Log " "

  Copy-Item -Path $installer -Destination $dir
  Copy-Item -Path $log -Destination ".\"

  Log "Installation Done." -s
  Log " "
  Break
}

Log "Operation Aborted." -e
Break