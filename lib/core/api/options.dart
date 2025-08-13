import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:nazmino/bloc/source/token_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiBaseData {
  static const String baseUrl = 'https://nazmino.liara.run/api';

  static late final SharedPreferences _prefs;

  // Initialize SharedPreferences once
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    log('🏁 SharedPreferences initialized');
  }

  static final httpClient =
      Dio(
          BaseOptions(
            baseUrl: baseUrl,
            headers: {
              'Content-Type': 'application/json', // Set default headers here
            },
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              try {
                final token = _prefs.getString(TokenDataSource.tokenKey);
                log('🔑 Retrieved token: ${token ?? "NULL"}');

                if (token != null) {
                  options.headers['Authorization'] = 'Bearer $token';
                  log(
                    '✅ Added Auth header: ${options.headers['Authorization']}',
                  );
                } else {
                  log('⚠️ No token available');
                }
              } catch (e) {
                log('❌ Error in interceptor: $e');
              }
              handler.next(options);
            },
            onError: (error, handler) async {
              // Handle token expiration or other errors
              if (error.response?.statusCode == 401) {
                // Example: Refresh token logic
              }
              handler.next(error);
            },
          ),
        );
}
