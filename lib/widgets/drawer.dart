import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:nazmino/controller/theme_controller.dart';
import 'package:nazmino/core/extensions/app_version.dart';
import 'package:nazmino/core/translate/messages.dart';
import 'package:nazmino/service/lang_load_service.dart';
import 'package:nazmino/view/about_app_screen.dart';
import 'package:nazmino/view/auth_screen.dart';
import 'package:nazmino/view/history/transaction_history_screen.dart';

import '../provider/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppMessages.appName.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Text(
                      //   AppMessages.appSlogan.tr,
                      //   style: TextStyle(
                      //     color: Colors.white70,
                      //     fontSize: 14,
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 8),
                children: [
                  _buildDrawerItem(
                    icon: Icons.history,
                    text: AppMessages.history.tr,
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const TransactionsHistoryListScreen());
                    },
                  ),
                  Obx(
                    () => SwitchListTile(
                      secondary: Icon(
                        themeController.isDarkMode.value
                            ? Icons.dark_mode
                            : Icons.light_mode,
                      ),
                      title: Text(AppMessages.darkMode.tr),
                      value: themeController.isDarkMode.value,
                      onChanged: (_) => themeController.toggleTheme(),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(AppMessages.language.tr),
                    trailing: DropdownButton<String>(
                      value: Get.locale?.languageCode ?? 'en',
                      items: const [
                        DropdownMenuItem(value: 'en', child: Text('English')),
                        DropdownMenuItem(value: 'fa', child: Text('فارسی')),
                      ],
                      onChanged: (String? languageCode) {
                        if (languageCode == null) return;
                        final localeService = Get.find<LocaleService>();
                        if (languageCode == 'fa') {
                          localeService.changeLocale('fa');
                        } else {
                          localeService.changeLocale('en');
                        }
                      },
                      underline: const SizedBox(),
                    ),
                  ),
                  _buildDrawerItem(
                    icon: Icons.info_outline,
                    text: AppMessages.aboutApp.tr,
                    onTap: () {
                      Get.to(() => const AboutAppScreen());
                    },
                  ),

                  _buildDrawerItem(
                    icon: Icons.logout,
                    text: AppMessages.logOut.tr,
                    onTap: () async {
                      final authProvider = context.read<AuthProvider>();

                      final success = await authProvider.logout();
                      if (success) {
                        Get.offAll(() => const AuthScreen());
                      } else {
                        Get.snackbar(
                          'خطا',
                          'خروج از حساب انجام نشد',
                          backgroundColor: errorColor,
                          colorText: Colors.white,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Nazmino ${AppVersion.versionNumber}',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
      horizontalTitleGap: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
