feat(mix): implement generic Token<T> system for type-safe theme tokens

## Summary
Introduces a new generic Token<T> class to consolidate duplicate token implementations 
while maintaining full backwards compatibility with the existing token system.

## Changes
- Add generic Token<T> class in lib/src/theme/tokens/token.dart
- Update ColorDto to support Token<Color> with token field and factory
- Update SpaceDto to support Token<double> with token field and factory  
- Update TextStyleDto to support Token<TextStyle> with token field and factory
- Add token() extension methods to color, spacing, and text style utilities
- Add comprehensive unit and integration tests for token functionality
- Create migration guide and documentation

## Breaking Changes
None. The existing token system remains fully functional with deprecation warnings.

## Migration
Users can gradually migrate from old tokens to new tokens:
```dart
// Old way (still works)
$box.color.ref(ColorToken('primary'))

// New way
$box.color.token(Token<Color>('primary'))
```

## Testing
- Added unit tests for Token<T> class
- Added integration tests for token resolution
- Updated existing tests to handle new token system
- All tests passing

## Documentation
- Created comprehensive migration guide
- Added deprecation notices to old token classes
- Updated examples to show new token usage

## Technical Details
The new Token<T> class uses generics to provide type safety while consolidating
the implementation. It maintains compatibility by delegating to the existing
token resolution system internally.

## Related Issues
- Addresses code duplication in token system
- Removes negative hashcode hack from SpaceToken
- Provides foundation for future token system enhancements
