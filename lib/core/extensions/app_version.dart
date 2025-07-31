import 'package:package_info_plus/package_info_plus.dart';

class AppVersion {
  static String _appVersion = '0.0.0';

  static Future<void> init() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _appVersion = packageInfo.version;
  }

  static String get version => 'v$_appVersion';
  static String get versionNumber => _appVersion;
}
