import 'package:dio/dio.dart';
import 'package:nazmino/bloc/repository/version_repo.dart';
import 'package:nazmino/core/api/validator.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../model/version.dart';

abstract class IVersionDataSource extends IVersionRepository {}

class VersionDataSource implements IVersionDataSource {
  final Dio httpClient;

  VersionDataSource(this.httpClient);

  @override
  Future<String> getLocalVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  @override
  Future<VersionInfo?> getServerVersionInfo() async {
    try {
      final res = await httpClient.get('/version');
      validateResponse(res);
      return VersionInfo.fromJson(res.data);
    } catch (e) {
      return null;
    }
  }

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
