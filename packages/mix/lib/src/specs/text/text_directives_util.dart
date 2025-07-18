import '../../core/attribute.dart';
import '../../core/directive.dart';
import '../../core/utility.dart';
import '../../internal/string_ext.dart';

final class TextDirectiveUtility<T extends Attribute>
    extends MixUtility<T, TextDirectiveDto> {
  const TextDirectiveUtility(super.builder);
  T _wrap(Modifier<String> modifier) => builder(TextDirectiveDto([modifier]));

  T capitalize() => _wrap(_capitalize);
  T uppercase() => _wrap(_uppercase);
  T lowercase() => _wrap(_lowercase);
  T titleCase() => _wrap(_titleCase);
  T sentenceCase() => _wrap(_sentenceCase);

  T call(Modifier<String> modifier) => builder(TextDirectiveDto([modifier]));
}

String _capitalize(String value) => value.capitalize;
String _uppercase(String value) => value.toUpperCase();
String _lowercase(String value) => value.toLowerCase();
String _titleCase(String value) => value.titleCase;
String _sentenceCase(String value) => value.sentenceCase;
