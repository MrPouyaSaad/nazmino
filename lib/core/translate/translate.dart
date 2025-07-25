import 'package:get/get_navigation/get_navigation.dart';
import 'package:nazmino/core/translate/lang/en.dart';
import 'package:nazmino/core/translate/lang/fa.dart';

class AppTranslate extends Translations {
  // This class is used to provide translations for the application
  @override
  Map<String, Map<String, String>> get keys => {
    'en': EnKeys().keys,
    'fa': FaKeys().keys,
  };
}

abstract class AppTranslationKeys {
  Map<String, String> get keys;
}
