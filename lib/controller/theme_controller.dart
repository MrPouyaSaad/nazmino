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
    update(); //GetBuilder
  }

  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themePref = prefs.getString('themeMode') ?? 'system';
    if (themePref == 'light') {
      isDarkMode.value = false;
      Get.changeThemeMode(ThemeMode.light);
    } else if (themePref == 'dark') {
      isDarkMode.value = true;
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      // حالت سیستم
      isDarkMode.value = Get.isPlatformDarkMode;
      Get.changeThemeMode(ThemeMode.system);
    }
  }

  void toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode.value);
  }
}
