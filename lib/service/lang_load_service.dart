import 'dart:ui';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService extends GetxService {
  final Rx<Locale> currentLocale = const Locale('en', 'US').obs;

  Future<LocaleService> init() async {
    await loadLocale();
    return this;
  }

  Future<void> loadLocale() async {
    final shared = await SharedPreferences.getInstance();
    final langCode = shared.getString('language') ?? 'en';
    currentLocale.value = localeFromCode(langCode);
  }

  Future<void> changeLocale(String code) async {
    final shared = await SharedPreferences.getInstance();
    await shared.setString('language', code);

    final locale = localeFromCode(code);
    currentLocale.value = locale;
    Get.updateLocale(locale); // برای GetX ترجمه‌ها
  }

  Locale localeFromCode(String code) {
    switch (code) {
      case 'fa':
        return const Locale('fa', 'IR');
      case 'en':
        return const Locale('en', 'US');
      default:
        return const Locale('en', 'US');
    }
  }
}
