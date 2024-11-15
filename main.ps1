# add-file-annotations.ps1
$ErrorActionPreference = "Stop"

Write-Host "Starting to process source files..."

# Get the current directory where the script is running
$rootPath = Get-Location

# Load configurations
$fileTypes = & "$PSScriptRoot\comment-types.ps1"
$pathFilters = & "$PSScriptRoot\path-filters.ps1"
. "$PSScriptRoot\filter-utils.ps1"  # Dot-source the utility functions

if (-not $fileTypes) {
    Write-Error "Failed to load comment-types.ps1 configuration file"
    exit 1
}

if (-not $pathFilters) {
    Write-Error "Failed to load path-filters.ps1 configuration file"
    exit 1
}

# Function to get relative path from root
function Get-RelativePath {
    param (
        [string]$FullPath,
        [string]$RootPath
    )
    return $FullPath.Substring($RootPath.ToString().Length + 1).Replace("\", "/")
}

# Function to check if a path contains 'vendor' directory
function Test-IsVendorPath {
    param (
        [string]$Path
    )
    return $Path -match "\\vendor\\"
}

# Function to get comment syntax for file extension
function Get-CommentSyntax {
    param (
        [string]$Extension
    )
    
    foreach ($type in $fileTypes.Keys) {
        if ($fileTypes[$type].extensions -contains $Extension.ToLower()) {
            return @{
                prefix = $fileTypes[$type].prefix
                suffix = $fileTypes[$type].suffix
            }
        }
    }
    
    # Default to C-style comments if no match found
    return @{
        prefix = "//"
        suffix = ""
    }
}

# Function to add or update path comment
function Update-FileComment {
    param (
        [string]$FilePath,
        [string]$RelativePath
    )
    
    $extension = [System.IO.Path]::GetExtension($FilePath)
    $commentSyntax = Get-CommentSyntax -Extension $extension
    $content = Get-Content $FilePath -Raw -Encoding UTF8
    
    # Create the path comment with appropriate syntax
    $pathComment = ""
    if ($commentSyntax.suffix -eq "") {
        # Single-line comment style
        $pathComment = "$($commentSyntax.prefix) File: $RelativePath"
    } else {
        # Multi-line comment style
        $pathComment = "$($commentSyntax.prefix) File: $RelativePath $($commentSyntax.suffix)"
    }
    
    # Pattern to match existing path comments based on the file's comment syntax
    $existingCommentPattern = ""
    if ($commentSyntax.suffix -eq "") {
        $escapedPrefix = [regex]::Escape($commentSyntax.prefix)
        $existingCommentPattern = "^${escapedPrefix}\s*File:[^\r\n]*[\r\n]*"
    } else {
        $escapedPrefix = [regex]::Escape($commentSyntax.prefix)
        $escapedSuffix = [regex]::Escape($commentSyntax.suffix)
        $existingCommentPattern = "^${escapedPrefix}\s*File:[^${escapedSuffix}]*${escapedSuffix}[\r\n]*"
    }
    
    # Check if file already starts with a path comment
    if ($content -match $existingCommentPattern) {
        $content = $content -replace $existingCommentPattern, "$pathComment`n"
    } else {
        $content = "$pathComment`n$content"
    }
    
    # Use UTF8 encoding without BOM
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($FilePath, $content, $utf8NoBom)
}

# Get all source files recursively
$extensions = $fileTypes.Values.extensions | ForEach-Object { $_ } | Select-Object -Unique
$files = Get-ChildItem -Path $rootPath -Recurse -Include $extensions |
    Where-Object { Test-ShouldProcessPath -Path $_.FullName -PathFilters $pathFilters }

$totalFiles = $files.Count
$processedFiles = 0
$skippedFiles = 0
$excludedFiles = 0

Write-Host "Found $totalFiles files to process..."

foreach ($file in $files) {
    try {
        $relativePath = Get-RelativePath $file.FullName $rootPath
        
        # Additional logging to show why files are being skipped
        if (-not (Test-ShouldProcessPath -Path $file.FullName -PathFilters $pathFilters)) {
            Write-Host "Skipping (excluded): $relativePath" -ForegroundColor Yellow
            $excludedFiles++
            continue
        }
        
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
Write-Host "Excluded by filters: $excludedFiles"
Write-Host "Skipped/Failed: $skippedFiles"
Write-Host "Done!"