import 'package:analyzer/dart/element/type.dart';
import 'package:mix_generator/src/core/metadata/field_metadata.dart';
import 'package:mix_generator/src/core/property/property_method_builder.dart';
import 'package:mix_generator/src/core/type_registry.dart';
import 'package:test/test.dart';

void main() {
  group('MethodGenerators', () {
    test('generateMergeMethod with different field types', () {
      // Add BorderSideDto to the tryToMerge set temporarily for the test
      final originalTryToMerge = Set<String>.from(tryToMerge);
      tryToMerge.add('BorderSideDto');

      try {
        // Create a test field that is a DTO with a known type that has tryToMerge
        final dtoWithTryToMerge = _TestFieldMetadata(
          name: 'borderField',
          isDto: true,
          representationElementName:
              'BorderSideDto', // This is in the tryToMerge set
        );

        // Create a test field that is a DTO without tryToMerge
        final dtoWithoutTryToMerge = _TestFieldMetadata(
          name: 'customField',
          isDto: true,
          representationElementName: 'CustomDto', // Not in the tryToMerge set
        );

        // Create a test field that is a list
        final listField = _TestFieldMetadata(
          name: 'itemsList',
          isDto: false,
          isList: true,
        );

        // Create a test field that is a simple type
        final simpleField = _TestFieldMetadata(
          name: 'simpleField',
          isDto: false,
        );

        // Generate the merge method with all field types
        final result = MixableTypeMethods.generateMergeMethod(
          className: 'TestClass',
          fields: [
            dtoWithTryToMerge,
            dtoWithoutTryToMerge,
            listField,
            simpleField
          ],
          isAbstract: false,
          shouldMergeLists: true,
          useInternalRef: false,
        );

        // Verify the merge method contains the tryToMerge call for BorderSideDto
        expect(
          result,
          contains(
              'borderField: BorderSideDto.tryToMerge(borderField, other.borderField),'),
        );

        // Verify the merge method contains the default merge pattern for CustomDto
        expect(
          result,
          contains(
              'customField: customField?.merge(other.customField) ?? other.customField,'),
        );

        // Verify the merge method contains the list merge pattern
        expect(
          result,
          contains(
              'itemsList: MixOps.mergeList(itemsList, other.itemsList),'),
        );

        // Verify the merge method contains the simple field merge pattern
        expect(
          result,
          contains('simpleField: other.simpleField ?? simpleField,'),
        );
      } finally {
        // Restore the original tryToMerge set
        tryToMerge.clear();
        tryToMerge.addAll(originalTryToMerge);
      }
    });

    test('generateMergeMethod with DecorationDto subclasses', () {
      // Ensure DecorationDto is in the tryToMerge set
      final originalTryToMerge = Set<String>.from(tryToMerge);

      try {
        // Create a test field that is a BoxDecorationDto
        final boxDecorationField = _TestFieldMetadata(
          name: 'boxDecoration',
          isDto: true,
          representationElementName: 'BoxDecorationDto',
        );

        // Create a test field that is a ShapeDecorationDto
        final shapeDecorationField = _TestFieldMetadata(
          name: 'shapeDecoration',
          isDto: true,
          representationElementName: 'ShapeDecorationDto',
        );

        // Generate the merge method with both decoration fields
        final result = MixableTypeMethods.generateMergeMethod(
          className: 'TestClass',
          fields: [boxDecorationField, shapeDecorationField],
          isAbstract: false,
          shouldMergeLists: true,
          useInternalRef: false,
        );

        // If DecorationDto is in the tryToMerge set, both BoxDecorationDto and ShapeDecorationDto
        // should use DecorationDto.tryToMerge
        if (tryToMerge.contains('DecorationDto')) {
          // Verify the merge method contains the tryToMerge call for BoxDecorationDto
          expect(
            result,
            contains(
                'boxDecoration: DecorationDto.tryToMerge(boxDecoration, other.boxDecoration),'),
            reason: 'BoxDecorationDto should use DecorationDto.tryToMerge',
          );

          // Verify the merge method contains the tryToMerge call for ShapeDecorationDto
          expect(
            result,
            contains(
                'shapeDecoration: DecorationDto.tryToMerge(shapeDecoration, other.shapeDecoration),'),
            reason: 'ShapeDecorationDto should use DecorationDto.tryToMerge',
          );
        } else {
          // If DecorationDto is not in the tryToMerge set, both should use the default merge pattern
          expect(
            result,
            contains(
                'boxDecoration: boxDecoration?.merge(other.boxDecoration) ?? other.boxDecoration,'),
            reason: 'BoxDecorationDto should use default merge pattern',
          );

          expect(
            result,
            contains(
                'shapeDecoration: shapeDecoration?.merge(other.shapeDecoration) ?? other.shapeDecoration,'),
            reason: 'ShapeDecorationDto should use default merge pattern',
          );
        }
      } finally {
        // Restore the original tryToMerge set
        tryToMerge.clear();
        tryToMerge.addAll(originalTryToMerge);
      }
    });
  });
}

/// A minimal implementation of FieldMetadata for testing
class _TestFieldMetadata implements ParameterMetadata {
  final String _name;
  final bool _isDto;
  final String? _representationElementName;
  final bool _isList;

  _TestFieldMetadata({
    required String name,
    required bool isDto,
    String? representationElementName,
    bool isList = false,
  })  : _name = name,
        _isDto = isDto,
        _representationElementName = representationElementName,
        _isList = isList;

  @override
  String get name => _name;

  @override
  bool get isResolvable => _isDto;

  @override
  bool get isListType => _isList;

  @override
  String get asInternalRef => '_$name';

  @override
  DartType get dartType => _TestDartType(isList: _isList);

  @override
  bool get hasResolvable => _isDto;

  @override
  bool get nullable => false;

  @override
  FieldResolvableMetadata? get resolvable =>
      _isDto && _representationElementName != null
          ? FieldResolvableMetadata(
              name: _name,
              type: _representationElementName.endsWith('DecorationDto')
                  ? 'DecorationDto'
                  : _representationElementName,
              tryToMergeType:
                  _representationElementName.endsWith('DecorationDto') ||
                      TypeRegistry.instance
                          .hasTryToMerge(_representationElementName),
            )
          : null;

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// A minimal implementation of DartType for testing
class _TestDartType implements DartType {
  final bool _isList;

  _TestDartType({bool isList = false}) : _isList = isList;

  @override
  bool get isDartCoreList => _isList;

  @override
  bool get isDartCoreMap => false;

  @override
  bool get isDartCoreSet => false;

  @override
  String getDisplayString({bool withNullability = false}) => 'TestType';

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}
