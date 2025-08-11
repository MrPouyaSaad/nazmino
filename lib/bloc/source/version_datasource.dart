import 'package:dio/dio.dart';
import 'package:nazmino/bloc/repository/version_repo.dart';
import 'package:nazmino/core/api/validator.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract class IVersionDataSource extends IVersionRepository {}

class VersionDataSource implements IVersionDataSource {
  final Dio httpClient;

  VersionDataSource(this.httpClient);

  /// get local app version
  @override
  Future<String> getLocalVersion() async {
    final info = await PackageInfo.fromPlatform();
    // use version + buildNumber if you want more precision
    return info.version;
  }

  /// fetch latest version info from server
  @override
  Future<String?> getServerVersion() async {
    final res = await httpClient.get('/version');
    validateResponse(res);
    try {
      final data = res.data;

      return data['latest'] as String?;
    } catch (e) {
      return null;
    }
  }

  /// simple semver compare function (major.minor.patch)
  @override
  bool isServerVersionGreater(String local, String server) {
    List<int> parse(String v) =>
        v.split('.').map((s) => int.tryParse(s) ?? 0).toList();
    final l = parse(local);
    final s = parse(server);
    for (int i = 0; i < 3; i++) {
      final li = i < l.length ? l[i] : 0;
      final si = i < s.length ? s[i] : 0;
      if (si > li) return true;
      if (si < li) return false;
    }
    return false;
  }
}
