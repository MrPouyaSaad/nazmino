import 'dart:ui';

class LangList {
  static const List<Map<String, dynamic>> languages = [
    {
      'code': 'en',
      'name': 'English',
      'locale': Locale('en', 'US'),
      'flag': 'US.png',
    },
    {
      'code': 'fa',
      'name': 'فارسی',
      'locale': Locale('fa', 'IR'),
      'flag': 'IR.png',
    },
    // add more languages here
    // {
    //   'code': 'fr',
    //   'name': 'Français',
    //   'locale': const Locale('fr', 'FR'),
    //   'flag': 'assets/flags/fr.png',
    // },
  ];
}
