import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nazmino/core/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  final Rx<Locale> locale = Get.locale?.obs ?? const Locale('fa', 'IR').obs;

  ThemeData get lightTheme => AppThemes.lightTheme(locale.value);
  ThemeData get darkTheme => AppThemes.darkTheme(locale.value);

  void changeLocale(Locale newLocale) {
    locale.value = newLocale;
    Get.updateLocale(newLocale);
    update(); // برای GetBuilder
  }

  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode.value);
  }
}
