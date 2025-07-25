import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nazmino/core/translate/lang/lang_list.dart';

import '../controller/lang_controller.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LanguageController());

    return Obx(() {
      final selectedLang = LangList.languages.firstWhere(
        (lang) =>
            lang['locale'].languageCode ==
            controller.currentLocale.value.languageCode,
        orElse: () => LangList.languages.first,
      );

      return PopupMenuButton<String>(
        tooltip: 'Change Language'.tr,
        offset: const Offset(0, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Image.asset(
            'assets/images/flags/${selectedLang['flag']}',
            key: ValueKey(selectedLang['code']),
            width: 28,
            height: 28,
          ),
        ),
        onSelected: (String code) {
          final selected = LangList.languages.firstWhere(
            (lang) => lang['code'] == code,
          );
          controller.changeLanguage(selected['locale']);
        },
        itemBuilder: (BuildContext context) {
          return LangList.languages.map((lang) {
            final isSelected = lang['code'] == selectedLang['code'];

            return PopupMenuItem<String>(
              value: lang['code'],
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/flags/${lang['flag']}',
                    width: 24,
                    height: 24,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.flag),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    lang['name'],
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                  ),
                  if (isSelected)
                    const Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Icon(Icons.check, size: 16, color: Colors.green),
                    ),
                ],
              ),
            );
          }).toList();
        },
      );
    });
  }
}
