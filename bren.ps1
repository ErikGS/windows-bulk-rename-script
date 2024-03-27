<#
.Synopsis
Renames every file numerically, without parenthesis (e.g. 001, 002, ...).
#>

param(
  [string]$target,
  [Int16]$zeros,
  [switch]$force,
  [switch]$version
)

Write-Host "---------------------BRen---------------------" -ForegroundColor Red
Write-Host "       Bulk-Rename operation by Erik GS       " -ForegroundColor Yellow
Write-Host "         [https://github.com/ErikGS]          " -ForegroundColor Cyan
Write-Host "---------------------v1.0---------------------" -ForegroundColor Red
Write-Host ""

$ver = "v1.0"
$i = 0

function BulkRename {
  Write-Host "Renaming..." -ForegroundColor Cyan
  Get-ChildItem "*.$target" | foreach-object { Rename-Item $_ "$($i.ToString('D'+$zeros)).$target"; $i++ }
  Write-Host "Done."  -ForegroundColor Green
  Write-Host ""
}

if ($version){
  Write-Host "Current version: $ver" -ForegroundColor Green
  Write-Host ""
  Break
}

if ($target -eq '') {
  $target = Read-Host "Enter the target extensions WITHOUT the dot"
  Write-Host ""
}

if ($target.Contains('.')) {
  $target.Replace('.','')
}

if ($target.Contains('/')) {
  Write-Error "The target must not be a path nor directory.
  Target must be a file extension (e.g. jpg, jpeg, png, webp, gif, mp4, pdf)."
  Break
}

if ($zeros -eq $null) {
  $zeros = Read-Host "Enter the amount of zeros to start from. Default is 0. (e.g. 0 starts from 1, 1 from 0, 2 from 00, 3 from 000, etc.)"
  Write-Host ""
}

if ($i -eq 0 -and $zeros -eq 0) { $i = 1 }

if ($force) {
  BulkRename
} else { 
  $ic = $i
  Write-Warning "Rename all '.$target' files to '$($ic.ToString('D'+$zeros)).$target', '$($ic++;$ic.ToString('D'+$zeros)).$target', etc.?"
  $confirm = Read-Host "(y/yes to confirm)"
  Write-Host ""
  if ($confirm -eq 'y' -or $confirm -eq 'yes') {
    BulkRename
  } else {
    Write-Host "Aborted." -ForegroundColor Red
    Write-Host ""
    Break
  }
}
