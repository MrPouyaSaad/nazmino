import 'package:dio/dio.dart';
import 'package:nazmino/core/api/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ITokenDataSource {
  Future<String?> getToken();
  Future<void> clearToken();
  Future<bool> isTokenValid();
}

class TokenDataSource implements ITokenDataSource {
  static const tokenKey = 'auth_token';
  final Dio httpClient;

  TokenDataSource(this.httpClient);
  @override
  Future<void> clearToken() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(tokenKey);
  }

  @override
  Future<String?> getToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(tokenKey);
  }

  @override
  Future<bool> isTokenValid() async {
    final token = await getToken();
    if (token == null) return false;

    final res = await httpClient.get('token-check');

    if (res.statusCode == 200) {
      // server says OK
      return true;
    } else {
      validateResponse(res);
      return false;
    }
  }
}
