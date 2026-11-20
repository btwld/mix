import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/src/dart/element/element.dart';
import 'package:analyzer/src/dart/element/type.dart';
import 'package:build_test/build_test.dart';
import 'package:mix_generator/src/core/helpers/widget_call_planner.dart';
import 'package:mix_generator/src/core/models/mix_widget_model.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

void main() {
  late LibraryElement library;

  setUpAll(() async {
    library = await resolveSource(
      '''
      library tear_off_validation;

      typedef Callback = void Function<A>(A);
      typedef EquivalentCallback = void Function<B>(B);

      class Generic<T> {}
      class Other<T> {}
      class Bounded<T extends num> {}
      class Recursive<T extends Comparable<T>> {}
      class Dependent<T, U extends List<T>> {}
      class CallbackBound<T extends Callback> {}
    ''',
      (resolver) async =>
          (await resolver.findLibraryByName('tear_off_validation'))!,
    );
  });

  test('renderWidgetCall passes child and children last, keeps the rest', () {
    WidgetCallParam named(String name) => WidgetCallParam(
      name: name,
      typeCode: 'Object?',
      isPositional: false,
      isRequired: false,
    );

    final code = renderWidgetCall(
      widgetName: 'RemixDialog',
      params: [named('child'), named('a'), named('children'), named('b')],
      forwardsKey: true,
    );

    expect(
      code,
      contains(
        'return RemixDialog(key: key, style: this, a: a, b: b, '
        'child: child, children: children);',
      ),
    );
  });

  void validate(ClassElement owner, FunctionType type) {
    validateGenericTargetTearOff(
      target: ConstantReader(_TypedConstant(type)),
      constructor: owner.unnamedConstructor!,
      anchor: owner,
      annotationLabel: '@MixableSpec(target:)',
    );
  }

  Matcher getInvalidTarget() => throwsA(
    isA<InvalidGenerationSource>().having(
      (error) => error.message,
      'message',
      contains('only supports direct, uninstantiated constructor tear-offs'),
    ),
  );

  test('accepts fresh ownerless type parameters from constant evaluation', () {
    final owner = library.getClass('Generic')!;
    final parameter = TypeParameterElementImpl.synthetic(name: 'T');
    expect(parameter.enclosingElement, isNull);
    expect(
      parameter.baseElement,
      isNot(same(owner.typeParameters.single.baseElement)),
    );

    validate(owner, _tearOff(owner, [parameter]));
  });

  test('preserves recursive and dependent bounds on ownerless parameters', () {
    for (final name in ['Recursive', 'Dependent']) {
      final owner = library.getClass(name)!;
      final parameters = [
        for (final parameter in owner.typeParameters)
          TypeParameterElementImpl.synthetic(name: parameter.name!),
      ];
      if (name == 'Recursive') {
        final bound = owner.typeParameters.single.bound! as InterfaceType;
        parameters.single.bound =
            bound.element.instantiate(
                  typeArguments: [
                    parameters.single.instantiate(nullabilitySuffix: .none),
                  ],
                  nullabilitySuffix: .none,
                )
                as TypeImpl;
      } else {
        final bound = owner.typeParameters.last.bound! as InterfaceType;
        parameters.last.bound =
            bound.element.instantiate(
                  typeArguments: [
                    parameters.first.instantiate(nullabilitySuffix: .none),
                  ],
                  nullabilitySuffix: .none,
                )
                as TypeImpl;
      }

      validate(owner, _tearOff(owner, parameters));
    }
  });

  test('accepts semantically equivalent generic function bounds', () {
    final owner = library.getClass('CallbackBound')!;
    final parameter = TypeParameterElementImpl.synthetic(name: 'T')
      ..bound =
          library.getTypeAlias('EquivalentCallback')!.aliasedType as TypeImpl;

    expect(
      parameter.bound!.getDisplayString(),
      isNot(owner.typeParameters.single.bound!.getDisplayString()),
    );
    validate(owner, _tearOff(owner, [parameter]));
  });

  test('rejects distinct bounds with the same display name', () async {
    final foreign = await resolveSource(
      'library foreign_bound; class num {}',
      (resolver) async => (await resolver.findLibraryByName('foreign_bound'))!,
    );
    final owner = library.getClass('Bounded')!;
    final parameter = TypeParameterElementImpl.synthetic(name: 'T')
      ..bound = foreign.getClass('num')!.thisType as TypeImpl;

    expect(
      parameter.bound!.getDisplayString(),
      owner.typeParameters.single.bound!.getDisplayString(),
    );
    expect(
      () => validate(owner, _tearOff(owner, [parameter])),
      getInvalidTarget(),
    );
  });

  test('rejects nullable return type arguments on ownerless parameters', () {
    final owner = library.getClass('Generic')!;
    final parameter = TypeParameterElementImpl.synthetic(name: 'T');
    final type = _tearOff(
      owner,
      [parameter],
      arguments: [parameter.instantiate(nullabilitySuffix: .question)],
    );

    expect(() => validate(owner, type), getInvalidTarget());
  });

  test('rejects a different same-named return type parameter', () {
    final owner = library.getClass('Generic')!;
    final parameter = TypeParameterElementImpl.synthetic(name: 'T');
    final other = TypeParameterElementImpl.synthetic(name: 'T');
    final type = _tearOff(
      owner,
      [parameter],
      arguments: [other.instantiate(nullabilitySuffix: .none)],
    );

    expect(() => validate(owner, type), getInvalidTarget());
  });

  test('rejects a return type belonging to a different class', () {
    final owner = library.getClass('Generic')!;
    final other = library.getClass('Other')!;
    final parameter = TypeParameterElementImpl.synthetic(name: 'T');

    expect(
      () => validate(owner, _tearOff(other, [parameter])),
      getInvalidTarget(),
    );
  });

  test('rejects changed bounds on ownerless parameters', () {
    final owner = library.getClass('Bounded')!;
    final parameter = TypeParameterElementImpl.synthetic(name: 'T');

    expect(
      () => validate(owner, _tearOff(owner, [parameter])),
      getInvalidTarget(),
    );
  });
}

// Keep analyzer's real parameter and return types while avoiding changes to
// FunctionTypeImpl's constructor between supported analyzer versions.
FunctionType _tearOff(
  ClassElement owner,
  List<TypeParameterElementImpl> parameters, {
  List<DartType>? arguments,
}) => _TargetFunctionType(
  parameters,
  owner.instantiate(
    typeArguments:
        arguments ??
        [
          for (final parameter in parameters)
            parameter.instantiate(nullabilitySuffix: .none),
        ],
    nullabilitySuffix: .none,
  ),
);

class _TargetFunctionType implements FunctionType {
  @override
  final List<TypeParameterElement> typeParameters;

  @override
  final InterfaceType returnType;

  _TargetFunctionType(this.typeParameters, this.returnType);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TypedConstant implements DartObject {
  @override
  final DartType type;

  _TypedConstant(this.type);

  @override
  bool get isNull => false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
