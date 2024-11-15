# path-filters.ps1
# Configuration file defining path inclusion and exclusion patterns

return @{
    # Exclude patterns - files/folders matching these patterns will be skipped
    exclude = @(
        # Default exclusions
        '\\vendor\\',           # Traditional vendor folders
        '\\node_modules\\',     # Node.js modules
        '\\build\\',            # Build output directories
        '\\dist\\',             # Distribution directories
        '\\bin\\',              # Binary directories
        '\\obj\\',              # Object file directories
        '\\.git\\',             # Git directory
        '\\.svn\\',             # SVN directory
        '\\.vs\\',              # Visual Studio directory
        '\\.idea\\',            # JetBrains IDEs directory
        '\\packages\\',         # NuGet packages directory
        '\\third-party\\',      # Third-party code
        '\\external\\',         # External dependencies
        '\\deps\\',             # Dependencies
        '\\lib\\',              # Library directories
        
        # File patterns to exclude
        '\.min\.',             # Minified files
        '\.generated\.',       # Generated files
        '\.g\.',              # Generated files (alternative notation)
        '\.designer\.',        # Designer-generated files
        '\.Designer\.',        # Designer-generated files (alternative casing)
        '-min\.',             # Minified files (alternative notation)
        '\.[0-9]+\.',         # Versioned files
        '\.bundle\.'          # Bundled files
    )

    # Include patterns - only files matching these patterns will be processed
    # If empty, all files (except excluded ones) will be processed
    include = @(
        # By default, we don't restrict inclusions
        # Add patterns here to restrict processing to specific paths
        # Example: '\\src\\',             # Only process files in src directory
        # Example: '\\include\\',         # Only process files in include directory
    )

    # Override patterns - these patterns will be processed even if they match exclude patterns
    # Useful for specific files/folders within excluded directories that you want to process
    override = @(
        # Example: '\\vendor\\our-company\\',    # Process our company's code in vendor
        # Example: '\\external\\internal-lib\\',  # Process our internal library in external
    )
}