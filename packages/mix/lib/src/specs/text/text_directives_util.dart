import '../../core/directive.dart';
import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';

final class TextDirectiveUtility<T extends SpecStyle<Object?>>
    extends PropUtility<T, MixDirective<String>> {
  const TextDirectiveUtility(super.builder);

  T capitalize() => call(CapitalizeStringDirective());
  T uppercase() => call(UppercaseStringDirective());
  T lowercase() => call(LowercaseStringDirective());
  T titleCase() => call(TitleCaseStringDirective());
  T sentenceCase() => call(SentenceCaseStringDirective());

  @override
  T call(MixDirective<String> value) => builder(Prop(value));
}
