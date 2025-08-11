import 'package:nazmino/bloc/source/version_datasource.dart';
import 'package:nazmino/core/api/options.dart';

final IVersionRepository versionRepository = VersionRepoostory(
  VersionDataSource(ApiBaseData.httpClient),
);

abstract class IVersionRepository {
  Future<String> getLocalVersion();
  Future<String?> getServerVersion();
  bool isServerVersionGreater(String local, String server);
}

class VersionRepoostory implements IVersionRepository {
  final IVersionDataSource dataSource;

  VersionRepoostory(this.dataSource);
  @override
  Future<String> getLocalVersion() => dataSource.getLocalVersion();

  @override
  Future<String?> getServerVersion() => dataSource.getServerVersion();

  @override
  bool isServerVersionGreater(String local, String server) =>
      dataSource.isServerVersionGreater(local, server);
}
