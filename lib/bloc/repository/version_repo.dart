import 'package:nazmino/bloc/model/version.dart';
import 'package:nazmino/bloc/source/version_datasource.dart';
import 'package:nazmino/core/api/options.dart';

final IVersionRepository versionRepository = VersionRepository(
  VersionDataSource(ApiBaseData.httpClient),
);

abstract class IVersionRepository {
  Future<String> getLocalVersion();
  Future<VersionInfo?> getServerVersionInfo();
  bool isServerVersionGreater(String local, String server);
}

class VersionRepository implements IVersionRepository {
  final IVersionDataSource dataSource;

  VersionRepository(this.dataSource);

  @override
  Future<String> getLocalVersion() => dataSource.getLocalVersion();

  @override
  Future<VersionInfo?> getServerVersionInfo() =>
      dataSource.getServerVersionInfo();

  @override
  bool isServerVersionGreater(String local, String server) =>
      dataSource.isServerVersionGreater(local, server);
}
