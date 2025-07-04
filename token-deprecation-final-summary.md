# Token Deprecation - Final Summary

## What's Changing

The old token system with separate classes (ColorToken, SpaceToken, etc.) is being replaced with a unified generic Token<T> system.

## Deprecation Status

| Old Token | New Token | Status | Removal |
|-----------|-----------|---------|----------|
| ColorToken | Token<Color> | ⚠️ Deprecated | v3.0.0 |
| SpaceToken | Token<double> | ⚠️ Deprecated | v3.0.0 |
| TextStyleToken | Token<TextStyle> | ⚠️ Deprecated | v3.0.0 |
| RadiusToken | Token<Radius> | ⚠️ Deprecated | v3.0.0 |
| BreakpointToken | Token<Breakpoint> | ⏸️ Under Review | TBD |

## Quick Migration Guide

### Simple Replacements
```dart
// Old → New
ColorToken('primary') → Token<Color>('primary')
SpaceToken('large') → Token<double>('large')
TextStyleToken('h1') → Token<TextStyle>('h1')
RadiusToken('md') → Token<Radius>('md')
```

### Utility Methods
```dart
// Old → New
$box.color.ref(ColorToken('primary')) → $box.color.token(Token<Color>('primary'))
$box.padding.ref(SpaceToken('large')) → $box.padding.token(Token<double>('large'))
```

## Why This Change?

✅ **Reduces code duplication** - One implementation instead of five  
✅ **Improves type safety** - Generic constraints prevent errors  
✅ **Simplifies API** - Consistent pattern for all tokens  
✅ **Enables future features** - Foundation for enhanced token system  

## Timeline

📅 **Now - v2.x**: Both systems work side-by-side  
📅 **6 months**: Increased deprecation warnings  
📅 **v3.0.0**: Old tokens removed completely  

## What You Need to Do

### If you're starting a new project
Use Token<T> from the beginning - don't use old tokens.

### If you have existing code
1. **No rush** - Your code will continue working
2. **Migrate gradually** - Update as you touch code
3. **Use find/replace** - Most migrations are simple
4. **Test thoroughly** - Ensure behavior unchanged

## Getting Help

- 📖 See full migration guide: `docs/token-migration-guide.md`
- 💬 Ask questions in GitHub issues
- 🔍 Check examples in the repository

## Key Takeaway

**Your code won't break**, but you should plan to migrate before v3.0.0 for a smooth transition.
