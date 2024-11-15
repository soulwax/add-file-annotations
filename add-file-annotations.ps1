# Add-Path-Comments.ps1
# Script to add relative path comments to C++ source files

# This script for now works for C++ projects but I will quickly expand it into the rust and web world as soon as I can.

$ErrorActionPreference = "Stop"

Write-Host "Starting to process C++ files..."

# Get the current directory where the script is running
$rootPath = Get-Location

# Function to check if a path contains 'vendor' directory
function Test-IsVendorPath {
    param (
        [string]$Path
    )
    return $Path -match "\\vendor\\"
}

# Function to get relative path from root
function Get-RelativePath {
    param (
        [string]$FullPath,
        [string]$RootPath
    )
    return $FullPath.Substring($RootPath.ToString().Length + 1).Replace("\", "/")
}

# Function to add or update path comment
function Update-FileComment {
    param (
        [string]$FilePath,
        [string]$RelativePath
    )
    
    $content = Get-Content $FilePath -Raw
    $pathComment = "// File: $RelativePath"
    
    # Check if file already starts with a path comment
    if ($content -match "^//\s*File:") {
        $content = $content -replace "^//\s*File:[^\r\n]*[\r\n]*", "$pathComment`n"
    } else {
        $content = "$pathComment`n$content"
    }
    
    # Use UTF8 encoding without BOM
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($FilePath, $content, $utf8NoBom)
}

# Get all C++ source files recursively
$files = Get-ChildItem -Path $rootPath -Recurse -Include *.cpp, *.hpp, *.h, *.c |
    Where-Object { -not (Test-IsVendorPath $_.FullName) }

$totalFiles = $files.Count
$processedFiles = 0
$skippedFiles = 0

foreach ($file in $files) {
    try {
        $relativePath = Get-RelativePath $file.FullName $rootPath
        Write-Host "Processing: $relativePath"
        
        Update-FileComment -FilePath $file.FullName -RelativePath $relativePath
        $processedFiles++
    }
    catch {
        Write-Host "Error processing $($file.FullName): $_" -ForegroundColor Red
        $skippedFiles++
    }
}

Write-Host "`nSummary:"
Write-Host "Total files found: $totalFiles"
Write-Host "Successfully processed: $processedFiles"
Write-Host "Skipped/Failed: $skippedFiles"
Write-Host "Done!"
