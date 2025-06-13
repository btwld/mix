# Unified Resolver Architecture Migration Plan

## Overview
This plan implements a unified resolver architecture that eliminates ColorRef/RadiusRef/TextStyleRef while making all token resolution go through a consistent resolver system. 

**Core Principles: KISS, DRY, YAGNI**
- **KISS**: Simple, direct token-to-value resolution
- **DRY**: Single resolution pattern for all types  
- **YAGNI**: Only implement what's needed, avoid over-engineering

## Goals
1. ❌ **Eliminate refs** - Remove ColorRef, RadiusRef, TextStyleRef inheritance tricks
2. ✅ **Resolver-based maps** - Everything goes through consistent resolver interface
3. ✅ **ColorResolver support** - Existing resolvers work seamlessly
4. ✅ **Simple, clean API** - Direct token resolution with type safety

## Architecture Changes

### Before (Complex)
```dart
Token → call() → Ref → DTO checks "is ColorRef" → MixTokenResolver → Value
```

### After (Simple)
```dart
Token → MixTokenResolver → Value
```

## Phase 1: Foundation (High Priority)

### 1A: Create ValueResolver Interface
**Goal**: Unified interface for all value resolution  
**Files**: `lib/src/theme/tokens/value_resolver.dart` (new)

```dart
abstract class ValueResolver<T> {
  T resolve(BuildContext context);
}

class StaticResolver<T> implements ValueResolver<T> {
  final T value;
  const StaticResolver(this.value);
  T resolve(BuildContext context) => value;
}

class LegacyResolver<T> implements ValueResolver<T> {
  final WithTokenResolver<T> legacy;
  const LegacyResolver(this.legacy);
  T resolve(BuildContext context) => legacy.resolve(context);
}
```

**KISS**: Simple interface, no complex inheritance  
**DRY**: Single resolver pattern for all types  
**YAGNI**: Only essential resolver types

---

### 1B: Add Resolver Storage to MixThemeData
**Goal**: Theme stores resolvers instead of mixed values/resolvers  
**Files**: `lib/src/theme/mix/mix_theme.dart`

```dart
@immutable
class MixThemeData {
  // Add resolver maps alongside existing for migration
  final Map<String, ValueResolver<Color>>? _colorResolvers;
  final Map<String, ValueResolver<double>>? _spaceResolvers;
  // ... other resolver maps
  
  // Factory that auto-converts values to resolvers
  factory MixThemeData.unified({
    Map<String, dynamic>? colors,
    Map<String, dynamic>? spaces,
    // ...
  }) {
    return MixThemeData.raw(
      colorResolvers: _convertToResolvers<Color>(colors ?? {}),
      spaceResolvers: _convertToResolvers<double>(spaces ?? {}),
      // Keep existing fields for backwards compatibility
      colors: StyledTokens.empty(),
      spaces: StyledTokens.empty(),
    );
  }
}
```

**KISS**: Optional resolver maps, gradual migration  
**DRY**: Single conversion method for all types  
**YAGNI**: Only add resolver storage, keep existing fields

---

### 1C: Update MixTokenResolver 
**Goal**: Unified resolution method  
**Files**: `lib/src/theme/tokens/token_resolver.dart`

```dart
class MixTokenResolver {
  // Add unified resolution alongside existing methods
  T resolveUnified<T>(String tokenName) {
    final theme = MixTheme.of(_context);
    
    if (T == Color && theme._colorResolvers != null) {
      final resolver = theme._colorResolvers![tokenName];
      return resolver?.resolve(_context) as T;
    }
    // Fallback to existing resolution
    return _fallbackResolve<T>(tokenName);
  }
}
```

**KISS**: Single method handles all types  
**DRY**: No duplicate resolution logic  
**YAGNI**: Only add what's needed for migration

---

### 1D: Add Auto-Conversion Helpers
**Goal**: Convert existing values to resolvers automatically  
**Files**: `lib/src/theme/tokens/value_resolver.dart`

```dart
ValueResolver<T> createResolver<T>(dynamic value) {
  if (value is T) return StaticResolver<T>(value);
  if (value is WithTokenResolver<T>) return LegacyResolver<T>(value);
  throw ArgumentError('Cannot create resolver for ${value.runtimeType}');
}
```

**KISS**: Simple conversion logic  
**DRY**: Single converter for all types  
**YAGNI**: Only handle existing patterns

---

### 1E: Remove call() from Token<T>
**Goal**: Stop generating refs  
**Files**: `lib/src/theme/tokens/token.dart`

```dart
class Token<T> extends MixToken<T> {
  const Token(super.name);
  // Remove: T call() => creates refs
  // Keep: Name and equality only
}
```

**KISS**: Token is just data  
**DRY**: No duplicate ref creation  
**YAGNI**: Remove unused ref generation

## Phase 2: DTO Updates (Medium Priority)

### 2A-2D: Update DTOs for Direct Resolution
**Goal**: DTOs resolve tokens directly, no refs  
**Files**: `lib/src/attributes/*/dto.dart` files

```dart
class ColorDto extends Mixable<Color> {
  final Color? directValue;
  final Token<Color>? token;
  
  Color resolve(MixData mix) {
    if (token != null) {
      // Direct resolution - no refs!
      return mix.tokens.resolveUnified<Color>(token.name);
    }
    return directValue ?? Colors.transparent;
  }
}
```

**KISS**: Direct token resolution  
**DRY**: Same pattern for all DTOs  
**YAGNI**: Only handle token or direct value

---

### 2E: Update Utility Methods
**Goal**: Accept tokens directly  
**Files**: `lib/src/attributes/*/util.dart` files

```dart
extension ColorUtilityExt on ColorUtility {
  ColorAttribute call(Object value) {
    return switch (value) {
      Color color => builder(ColorDto.value(color)),
      Token<Color> token => builder(ColorDto.token(token)),
      _ => throw ArgumentError('Invalid color value'),
    };
  }
}
```

**KISS**: Simple switch on type  
**DRY**: Same pattern for all utilities  
**YAGNI**: Only handle needed types

## Phase 3: Cleanup (Low Priority)

### 3A: Deprecate Ref Methods
**Goal**: Mark ref creation as deprecated  
**Files**: Legacy token files

```dart
@deprecated
ColorRef call() => ColorRef(this);  // Add deprecation warning
```

**KISS**: Just add deprecation  
**DRY**: Same deprecation pattern  
**YAGNI**: Don't remove yet, just warn

---

### 3B: Migration Tests
**Goal**: Ensure migration works  
**Files**: `test/src/theme/unified_resolver_test.dart` (new)

**KISS**: Test core functionality only  
**DRY**: Reuse test patterns  
**YAGNI**: Only test migration path

---

### 3C-3D: Remove Refs and Legacy Logic
**Goal**: Clean up after migration is complete  

**KISS**: Simple removal  
**DRY**: Remove all ref patterns  
**YAGNI**: Only when migration is proven

## Implementation Strategy

### Step-by-Step Approach
1. **Add new** (don't modify existing)
2. **Test new alongside old**
3. **Migrate gradually**
4. **Remove old when safe**

### KISS Compliance
- Each phase is independent
- Simple, direct solutions
- No complex abstractions

### DRY Compliance  
- Single resolver interface
- Same patterns across all types
- Unified resolution method

### YAGNI Compliance
- Only implement what's needed for migration
- Don't over-engineer
- Add features when actually needed

## Migration Timeline

### Week 1: Foundation
- Phase 1A-1E: Core resolver architecture

### Week 2: DTO Updates
- Phase 2A-2E: Update DTOs and utilities

### Week 3: Testing & Validation
- Phase 3B: Comprehensive testing

### Week 4: Cleanup (Optional)
- Phase 3A: Deprecations
- Phase 3C-3D: Removal (when ready)

## Risk Mitigation

### Backwards Compatibility
- Keep existing APIs during migration
- Add new alongside old
- Gradual deprecation only after validation

### Testing Strategy
- Test new architecture with existing code
- Ensure performance isn't degraded
- Validate all token types work

### Rollback Plan
- Each phase is reversible
- Old system remains until new is proven
- Feature flags for gradual rollout

## Success Criteria

1. ✅ No more ColorRef/RadiusRef/TextStyleRef usage
2. ✅ All tokens resolve through unified system
3. ✅ Existing resolvers (ColorResolver) work unchanged
4. ✅ API feels simpler and more intuitive
5. ✅ Performance maintained or improved
6. ✅ All tests pass

## Notes

- This is a **simplification** migration, not a feature addition
- Focus on **removing complexity**, not adding capabilities
- **Validate each phase** before proceeding to next
- **KISS principle**: If it feels complex, simplify further