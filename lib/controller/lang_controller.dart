import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageController extends GetxController {
  final Rx<Locale> currentLocale =
      Get.locale?.obs ?? const Locale('en', 'US').obs;

  void changeLanguage(Locale locale) {
    currentLocale.value = locale;
    Get.updateLocale(locale);
  }
}
