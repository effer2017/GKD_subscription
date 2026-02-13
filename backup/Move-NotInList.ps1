<#
.SYNOPSIS
  读取 adb_packages_list.txt（每行一个文件名/包名，不含扩展名），
  找出目标文件夹中不在列表里的文件，并移动到 backup 文件夹。

.PARAMETER ScanDir
  要扫描的文件夹。默认：当前目录

.PARAMETER ListFile
  列表文件路径。默认：当前目录下 adb_packages_list.txt

.PARAMETER BackupDir
  备份目录。默认：ScanDir\backup

.PARAMETER Recurse
  是否递归扫描子目录（默认不递归）

.PARAMETER DryRun
  只打印将要移动的文件，不实际移动
#>

param(
  [string]$ScanDir  = (Get-Location).Path,
  [string]$ListFile = (Join-Path (Get-Location).Path "adb_packages_list.txt"),
  [string]$BackupDir = "",
  [switch]$Recurse,
  [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Ensure-UniqueDestination([string]$destPath) {
  if (-not (Test-Path -LiteralPath $destPath)) { return $destPath }

  $dir  = Split-Path -Parent $destPath
  $name = [System.IO.Path]::GetFileNameWithoutExtension($destPath)
  $ext  = [System.IO.Path]::GetExtension($destPath)

  $stamp = Get-Date -Format "yyyyMMdd_HHmmssfff"
  $candidate = Join-Path $dir ("{0}_{1}{2}" -f $name, $stamp, $ext)
  if (-not (Test-Path -LiteralPath $candidate)) { return $candidate }

  for ($i=1; $i -le 9999; $i++) {
    $candidate = Join-Path $dir ("{0}_{1}{2}" -f $name, $i, $ext)
    if (-not (Test-Path -LiteralPath $candidate)) { return $candidate }
  }

  throw "无法生成不冲突的目标文件名：$destPath"
}

# 1) 参数/路径准备
if (-not (Test-Path -LiteralPath $ScanDir -PathType Container)) {
  throw "扫描目录不存在：$ScanDir"
}
if (-not (Test-Path -LiteralPath $ListFile -PathType Leaf)) {
  throw "列表文件不存在：$ListFile"
}

if ([string]::IsNullOrWhiteSpace($BackupDir)) {
  $BackupDir = Join-Path $ScanDir "backup"
}
if (-not (Test-Path -LiteralPath $BackupDir)) {
  New-Item -ItemType Directory -Path $BackupDir | Out-Null
}

# 2) 读取名单（忽略空行、#注释；自动去掉扩展名；大小写不敏感）
$allowed = New-Object System.Collections.Generic.HashSet[string]([System.StringComparer]::OrdinalIgnoreCase)

Get-Content -LiteralPath $ListFile -Encoding UTF8 | ForEach-Object {
  $line = $_.Trim()
  if ([string]::IsNullOrWhiteSpace($line)) { return }
  if ($line.StartsWith("#")) { return }

  #$name = [System.IO.Path]::GetFileNameWithoutExtension($line)
  if (-not [string]::IsNullOrWhiteSpace($line)) {
    [void]$allowed.Add($line)
  }
}

# 3) 枚举文件（默认不递归；并跳过 backup 目录里的文件）
$gciParams = @{
  LiteralPath = $ScanDir
  File        = $true
  Force       = $true
}
if ($Recurse) { $gciParams.Recurse = $true }

$files = Get-ChildItem @gciParams | Where-Object {
  # 跳过 backup 目录内文件
  $full = $_.FullName
  $backupFull = (Resolve-Path -LiteralPath $BackupDir).Path.TrimEnd('\') + '\'
  -not ($full.StartsWith($backupFull, [System.StringComparison]::OrdinalIgnoreCase))
}

# 4) 过滤并移动
$moved = 0
$kept  = 0

foreach ($f in $files) {
  $baseName = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)

  if (-not $allowed.Contains($baseName)) {
    $dest = Join-Path $BackupDir $f.Name
    $dest = Ensure-UniqueDestination $dest

    if ($DryRun) {
      Write-Host "[DRY] MOVE  $($f.FullName)  ->  $dest"
    } else {
      Write-Host "[MOVE]      $($f.FullName)  ->  $dest"
      Move-Item -LiteralPath $f.FullName -Destination $dest
    }
    $moved++
  } else {
    $kept++
  }
}

#Write-Host ""
#Write-Host ("完成：移动 {0} 个文件到备份，保留 {1} 个文件不动。" -f $moved, $kept)
#Write-Host "ScanDir:  $ScanDir"
#Write-Host "ListFile:  $ListFile"
#Write-Host "BackupDir:  $BackupDir"
#if ($DryRun) { Write-Host "DryRun" }