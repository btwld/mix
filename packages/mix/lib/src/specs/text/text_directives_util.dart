import '../../core/directive.dart';
import '../../core/style.dart';
import '../../core/utility.dart';

final class TextDirectiveUtility<T extends Style<Object?>>
    extends MixUtility<T, MixDirective<String>> {
  const TextDirectiveUtility(super.builder);

  T capitalize() => call(CapitalizeStringDirective());
  T uppercase() => call(UppercaseStringDirective());
  T lowercase() => call(LowercaseStringDirective());
  T titleCase() => call(TitleCaseStringDirective());
  T sentenceCase() => call(SentenceCaseStringDirective());

  T call(MixDirective<String> value) => builder(value);
}
