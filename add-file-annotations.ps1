# Add-Path-Comments.ps1
# Script to add relative path comments to source files

$ErrorActionPreference = "Stop"

Write-Host "Starting to process source files..."

# Get the current directory where the script is running
$rootPath = Get-Location

# Define file types and their comment syntax
$fileTypes = @{
    # C-style comments
    ".c"    = @{
        extensions = @(".c", ".h", ".cpp", ".hpp", ".cc", ".cxx", ".hxx", ".inl", ".cs", ".java", ".js", ".jsx", ".ts", ".tsx", ".php", ".go", ".scala", ".swift", ".kt", ".rs")
        prefix = "//"
        suffix = ""
    }
    # Shell-style comments
    ".sh"   = @{
        extensions = @(".sh", ".bash", ".zsh", ".py", ".rb", ".pl", ".pm", ".tcl", ".yaml", ".yml", ".conf", ".gitignore", ".env", ".r", ".jl")
        prefix = "#"
        suffix = ""
    }
    # HTML-style comments
    ".html" = @{
        extensions = @(".html", ".htm", ".xml", ".svg", ".xaml")
        prefix = "<!--"
        suffix = "-->"
    }
    # Batch file comments
    ".bat"  = @{
        extensions = @(".bat", ".cmd")
        prefix = "REM"
        suffix = ""
    }
    # Lisp-style comments
    ".lisp" = @{
        extensions = @(".lisp", ".cl", ".el")
        prefix = ";;"
        suffix = ""
    }
    # Lua comments
    ".lua"  = @{
        extensions = @(".lua")
        prefix = "--"
        suffix = ""
    }
    # VB-style comments
    ".vb"   = @{
        extensions = @(".vb", ".vbs", ".bas")
        prefix = "'"
        suffix = ""
    }
    # Matlab/Octave comments
    ".m"    = @{
        extensions = @(".m", ".matlab")
        prefix = "%"
        suffix = ""
    }
    # Assembly comments
    ".asm"  = @{
        extensions = @(".asm", ".s", ".nasm")
        prefix = ";"
        suffix = ""
    }
    # Fortran comments
    ".f90"  = @{
        extensions = @(".f90", ".f95", ".f03", ".f08", ".for", ".f")
        prefix = "!"
        suffix = ""
    }
    # CSS comments
    ".css"  = @{
        extensions = @(".css", ".scss", ".sass", ".less")
        prefix = "/*"
        suffix = "*/"
    }
}

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
    Where-Object { -not (Test-IsVendorPath $_.FullName) }

$totalFiles = $files.Count
$processedFiles = 0
$skippedFiles = 0

Write-Host "Found $totalFiles files to process..."

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