# Token System Refactor - Implementation Tasks

## Overview
Implement a minimal, backwards-compatible token system that consolidates duplicate token classes into a single generic `Token<T>` class.

## Tasks

### Phase 1: Core Token Implementation

1. **Create the Token<T> class** ✅
   - Location: `lib/src/theme/tokens/token.dart`
   - Generic type parameter
   - Const constructor
   - Proper equals/hashCode
   - resolve() and call() methods

2. **Update mix.dart exports** ✅
   - Export new Token class
   - Keep existing token exports (deprecated)

### Phase 2: DTO Updates

3. **Update ColorDto** ✅
   - Add `Token<Color>? token` field
   - Add `ColorDto.token()` factory
   - Update resolve() to check token first
   - Update merge() to include token
   - Update props getter

4. **Update SpaceDto** ✅
   - Add `Token<double>? token` field
   - Add `SpaceDto.token()` factory
   - Update resolve() to check token first
   - Handle negative hashcode compatibility

5. **Update TextStyleDto** ✅
   - Add `Token<TextStyle>? token` field
   - Add `TextStyleDto.token()` factory
   - Update resolve() to check token first

### Phase 3: Utility Extensions

6. **ColorUtility extension** ✅
   - Add `token(Token<Color>)` method
   - Use existing builder pattern

7. **SpacingUtility extensions** ✅
   - Add token methods to spacing utilities
   - Handle SpaceToken compatibility

8. **TextStyleUtility extension** ✅
   - Add `token(Token<TextStyle>)` method

### Phase 4: Testing

9. **Token<T> unit tests** ✅
   - Test equality
   - Test hashCode
   - Test resolve for each type
   - Test call() for each type

10. **DTO token tests** ✅
    - Test token field
    - Test factory constructors
    - Test resolution
    - Test merge behavior

11. **Integration tests** ✅
    - Test with MixTheme
    - Test backwards compatibility
    - Test migration scenarios

### Phase 5: Documentation

12. **Migration guide** ✅
    - How to migrate from old tokens
    - Examples of new usage
    - Deprecation timeline

13. **Update examples** ✅
    - Show new Token<T> usage
    - Keep old examples with deprecation notes

### Phase 6: Cleanup

14. **Add deprecation annotations** ✅
    - Mark old token classes deprecated
    - Add migration messages
    - Set removal version

15. **Fix analyzer warnings** ✅
    - Remove unnecessary casts
    - Clean up imports
    - Address test issues

## Status: COMPLETE ✅

All tasks have been successfully implemented. The new token system is ready for use while maintaining full backwards compatibility.
