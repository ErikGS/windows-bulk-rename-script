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

  $string = ((Get-Date).ToString("yyyy/MM/dd-HH:mm:ss") + ": $string")

  if ($i) { 
    Write-Output $string | Out-File -FilePath $log -Append
    Write-Host $string -ForegroundColor Cyan 
  } elseif ($s) { 
    Write-Output $string | Out-File -FilePath $log -Append
    Write-Host $string -ForegroundColor Green
  } elseif ($w) {
    Write-Output $string | Out-File -FilePath $log -Append
    Write-Warning $string
  } elseif ($e) { 
    Write-Output $string | Out-File -FilePath $log -Append
    Write-Error $string
  } elseif ($color -ne "" -and [enum]::GetValues([System.ConsoleColor]) -contains $color) {
    Write-Output $string | Out-File -FilePath $log -Append
    Write-Host $string -ForegroundColor $color
  } else {
    Write-Output $string | Out-File -FilePath $log -Append
    write-Host $string
  }
}

# Utility for getting the User PATH variable
function GetUserPathVar {
  return [Environment]::GetEnvironmentVariable("path", "user");
}

# Checks if bren is already in path to present an uninstall dialog according
if ((GetUserPathVar).Contains($dir)) {

  # Uninstall dialog
  Write-Host "Bren is INSTALLED in $dir" -ForegroundColor Green

  Write-Warning "Do you want to UNINSTALL bren?"

  if ((Read-Host "Choice (Y/YES or N/NO)") -eq 'Y' -or $confirm -eq "YES") {

    Write-Host " "
    Log "--- Begin uninstalling... ---" -i

    # Removes bren from the user PATH variable
    [Environment]::SetEnvironmentVariable("path", (GetUserPathVar).Replace(";$dir", ""), "User");
    
    Remove-Item $bren
    Remove-Item $bren_cmd
    Remove-Item ($dir + $installer)

    Log "--- Bren was uninstalled. ---" -s
    Write-Host " "
    Break
  }

  Write-Host " "
  Log "Uninstall Operation Aborted." -color Red
  Write-Host " "
  Break
}


# Install dialog
Write-Warning "May the installer procceed?"

if ((Read-Host "Choice (Y/YES or N/NO)") -eq 'Y' -or $confirm -eq "YES") {

  Write-Host " "
  Log "--- Begin installation... ---" -w

  # Makes the directory and place a copy of bren
  mkdir $dir -Force > $null

  Log "Copying '$bren_src' to '$bren'..." -i

  Copy-Item -Path $bren_src -Destination $bren

  Log "Done (1/3)." -s


  # Saves a backup of the PATH variable before adding bren.
  Log "Saving a backup of current user PATH variable here and in '$usr_path_var_bkp'..." -i

  GetUserPathVar | Out-File -FilePath $usr_path_var_bkp 

  Copy-Item -Path $usr_path_var_bkp -Destination ".\"

  Log "Done (2/3)." -s


  # Adds bren to the user PATH variable
  Log "Adding bren to user PATH variable..." -i

  "powershell.exe -NoProfile -File $bren" > $bren_cmd

  if ((GetUserPathVar).EndsWith(';')) {
    [Environment]::SetEnvironmentVariable('path', ((GetUserPathVar) + ("$dir")), 'User');
  } else {
    [Environment]::SetEnvironmentVariable('path', ((GetUserPathVar) + (";$dir")), 'User');
  }

  Log "Done (3/3)." -s


  # Makes a copy the installer too, so there's a backup if needed, likely to uninstall
  Log " "
  Log "--- Installation Done. ---" -s
  Write-Host " "

  Copy-Item -Path $installer -Destination $dir
  Copy-Item -Path $log -Destination ".\"
  Break
}

Write-Host " "
Log "Install Operation Aborted." -color Red
Write-Host " "
Break
