# README todo

How it works:


# whitelist / blacklist behaviour explained:
The current configuration operates in a combined way:

1. **Blacklist Mode** (when `include` is empty):
- Files matching `exclude` patterns are skipped
- Everything else is processed
- Items matching `override` are always processed, even if they match `exclude`

2. **Whitelist Mode** (when `include` has patterns):
- ONLY files matching `include` patterns are processed
- Files matching `exclude` are still skipped
- Items matching `override` are always processed

Let's see some examples:

```powershell
# Current behavior with empty include[] (Blacklist Mode):
/project
  /src/main.cpp         -> ✅ Processed (not in exclude list)
  /vendor/lib.cpp       -> ❌ Skipped (matches exclude pattern)
  /build/output.cpp     -> ❌ Skipped (matches exclude pattern)
  /vendor/our-lib/x.cpp -> ✅ Processed (if in override list)

# With include[] populated (Whitelist Mode):
include = @('\\src\\')
/project
  /src/main.cpp         -> ✅ Processed (matches include pattern)
  /src/utils/helper.cpp -> ✅ Processed (matches include pattern)
  /include/header.hpp   -> ❌ Skipped (doesn't match include pattern)
  /vendor/lib.cpp       -> ❌ Skipped (doesn't match include + in exclude)
```

If you want it to work as a pure blacklist, you would:
1. Keep the `include` array empty
2. Add more patterns to `exclude`

