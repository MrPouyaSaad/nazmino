import 'package:nazmino/bloc/source/token_datasource.dart';
import 'package:nazmino/core/api/options.dart';

final ITokenRepository tokenRposistory = TokenRepository(
  TokenDataSource(ApiBaseData.httpClient),
);

abstract class ITokenRepository {
  Future<String?> getToken();
  Future<void> clearToken();
  Future<bool> isTokenValid();
}

class TokenRepository implements ITokenRepository {
  final ITokenDataSource dataSource;

  TokenRepository(this.dataSource);
  @override
  Future<void> clearToken() => dataSource.clearToken();

  @override
  Future<String?> getToken() => dataSource.getToken();

  @override
  Future<bool> isTokenValid() => dataSource.isTokenValid();
}
