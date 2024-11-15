# comment-types.ps1
# Configuration file defining file types and their comment syntax

return @{
    $fileTypes = @{
        # C-style single-line comments (//)
        "cstyle" = @{
            extensions = @(
                # C and C++ family
                ".c", ".h", ".cpp", ".hpp", ".cc", ".cxx", ".hxx", ".inl", ".ixx", ".cppm", ".tpp", 
                # C# and .NET
                ".cs", ".cake", ".csx",
                # Java family
                ".java", ".scala", ".kt", ".kts", ".groovy",
                # JavaScript/TypeScript family
                ".js", ".jsx", ".ts", ".tsx", ".mjs", ".cjs", ".vue", ".svelte",
                # Other C-style languages
                ".go", ".php", ".php3", ".php4", ".php5", ".phtml",
                ".swift", ".rs", ".d", ".di",
                ".as", ".as3", ".zig", ".v", ".vsh", ".vv",
                ".nx", ".nim", ".odin", ".pony",
                # Shader languages
                ".glsl", ".vert", ".frag", ".comp", ".geom", ".tesc", ".tese",
                ".hlsl", ".fx", ".compute", ".rgen", ".rmiss", ".rchit",
                # Game engines
                ".gd", ".cs", ".usl", ".ush", ".usf", ".uc",
                # Modern systems programming
                ".jai", ".oak", ".carbon"
            )
            prefix = "//"
            suffix = ""
        }
        
        # Hash-style comments (#)
        "hash" = @{
            extensions = @(
                # Scripting languages
                ".py", ".pyi", ".pyw", ".rpy", ".pyc", ".pyd", ".pyx", ".pxd",
                ".rb", ".rbw", ".rake", ".gemspec",
                ".pl", ".pm", ".t", ".pod",
                ".tcl", ".tk", ".nim",
                # Shell scripts
                ".sh", ".bash", ".zsh", ".fish", ".ksh", ".csh", ".tcsh",
                ".command", ".profile", ".zshrc", ".bashrc",
                # Configuration and data
                ".yaml", ".yml", ".toml", ".ini", ".cfg", ".conf",
                ".docker", ".dockerfile", ".containerfile",
                ".gitignore", ".env", ".npmrc", ".properties",
                # Scientific computing
                ".r", ".rmd", ".jl", ".sage", ".ipynb",
                # Build systems
                ".cmake", ".make", ".makefile", ".mak", ".mk",
                ".cabal", ".nix", ".bzl", ".bazel",
                # Modern scripting
                ".rkt", ".scm", ".cr", ".hcl", ".tf", ".workflow"
            )
            prefix = "#"
            suffix = ""
        }
        
        # HTML-style comments (<!-- -->)
        "html" = @{
            extensions = @(
                # Web markup
                ".html", ".htm", ".xhtml", ".dhtml", ".jhtml",
                ".xml", ".xaml", ".svg", ".mjml", ".wxs",
                ".xsd", ".xsl", ".xslt", ".dtd", ".rss",
                ".wsdl", ".cshtml", ".vbhtml", ".jsp", ".asp",
                ".aspx", ".ascx", ".master", ".razor",
                # Documentation
                ".md", ".markdown", ".mdown", ".mdwn",
                # Templates
                ".hbs", ".handlebars", ".mustache", ".ejs",
                ".erb", ".erb.html", ".html.erb"
            )
            prefix = "<!--"
            suffix = "-->"
        }
        
        # Multi-line C-style comments (/* */)
        "cblock" = @{
            extensions = @(
                # Stylesheets
                ".css", ".scss", ".sass", ".less", ".pcss",
                ".styl", ".stylus", ".postcss",
                # Special cases where block comments are preferred
                ".sty", ".cls", ".dtx", ".ins"
            )
            prefix = "/*"
            suffix = "*/"
        }
        
        # Lisp-style comments (;;)
        "lisp" = @{
            extensions = @(
                ".lisp", ".cl", ".el", ".clj", ".cljc", ".cljs",
                ".edn", ".scm", ".ss", ".rkt", ".hy", ".fnl",
                ".lsp", ".fasl", ".ccl", ".sbcl"
            )
            prefix = ";;"
            suffix = ""
        }
        
        # Lua comments (--)
        "lua" = @{
            extensions = @(
                ".lua", ".luau", ".p8", ".moon", ".rockspec",
                ".wlua", ".nvim"
            )
            prefix = "--"
            suffix = ""
        }
        
        # MATLAB/Octave comments (%)
        "matlab" = @{
            extensions = @(
                ".m", ".matlab", ".oct", ".mlx", ".mlapp",
                ".mex", ".fig", ".mat", ".simulink"
            )
            prefix = "%"
            suffix = ""
        }
        
        # Assembly comments (;)
        "asm" = @{
            extensions = @(
                ".asm", ".s", ".nasm", ".masm", ".tasm",
                ".asmx", ".inc", ".yasm", ".fasm", ".nas",
                ".mac", ".lst", ".s43", ".sx"
            )
            prefix = ";"
            suffix = ""
        }
        
        # Fortran comments (!)
        "fortran" = @{
            extensions = @(
                ".f", ".for", ".f90", ".f95", ".f03",
                ".f08", ".f15", ".f18", ".fpp", ".ftn",
                ".fixedform", ".freeform", ".cmn"
            )
            prefix = "!"
            suffix = ""
        }
        
        # Ada style comments (--)
        "ada" = @{
            extensions = @(
                ".ada", ".adb", ".ads", ".ali", ".a",
                ".gpr", ".ada_m", ".ada_s"
            )
            prefix = "--"
            suffix = ""
        }
        
        # Batch file comments (REM or ::)
        "batch" = @{
            extensions = @(
                ".bat", ".cmd", ".btm", ".batch"
            )
            prefix = "REM"
            suffix = ""
        }
        
        # VB-style comments (')
        "basic" = @{
            extensions = @(
                ".vb", ".vbs", ".bas", ".vba", ".vbnet",
                ".vbscript", ".wsf", ".dsr", ".cls",
                ".frm", ".dcr", ".vbhtml"
            )
            prefix = "'"
            suffix = ""
        }
        
        # Haskell comments (--)
        "haskell" = @{
            extensions = @(
                ".hs", ".lhs", ".hsc", ".chs", ".hs-boot",
                ".hsig", ".hcr", ".ghci"
            )
            prefix = "--"
            suffix = ""
        }
        
        # Erlang/Elixir comments (%)
        "erlang" = @{
            extensions = @(
                ".erl", ".hrl", ".ex", ".exs", ".eex",
                ".leex", ".heex", ".sface", ".app.src"
            )
            prefix = "%"
            suffix = ""
        }
        
        # Prolog comments (%)
        "prolog" = @{
            extensions = @(
                ".pl", ".pro", ".prolog", ".yap", ".P",
                ".prg", ".qlf", ".eclp"
            )
            prefix = "%"
            suffix = ""
        }
        
        # SQL comments (--)
        "sql" = @{
            extensions = @(
                ".sql", ".ddl", ".dml", ".prc", ".fnc",
                ".trg", ".vw", ".psql", ".tsql", ".pgsql",
                ".plsql", ".mysql"
            )
            prefix = "--"
            suffix = ""
        }
    
        # APL/J/K family (⍝)
        "apl" = @{
            extensions = @(
                ".apl", ".aplf", ".aplo", ".apln",
                ".dyalog", ".mipage"
            )
            prefix = "⍝"
            suffix = ""
        }
    }
}