import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:nazmino/bloc/source/token_datasource.dart';
import 'package:nazmino/core/api/options.dart';
import 'package:nazmino/core/api/validator.dart';
import 'package:nazmino/view/transaction_list/transactions_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// رنگ‌های ثابت
const Color errorColor = Color(0xFFC62828);
const Color successColor = Color(0xFF1E6091);

class AuthProvider with ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController phoneController = TextEditingController(text: '');
  final TextEditingController codeController = TextEditingController(text: '');

  bool _isLoading = false;
  bool _codeSent = false;

  bool get isLoading => _isLoading;
  bool get codeSent => _codeSent;

  Future<void> sendCode() async {
    log('[AuthProvider] sendCode() called');
    if (phoneController.text.trim().isEmpty) {
      log('[AuthProvider] Phone number is empty');
      Get.snackbar(
        'خطا',
        'لطفا شماره موبایل را وارد کنید',
        backgroundColor: errorColor,
        colorText: Colors.white,
      );
      return;
    }

    _isLoading = true;
    notifyListeners();
    log('[AuthProvider] Sending code to: ${phoneController.text.trim()}');

    try {
      final dio = Dio();
      final response = await dio.post(
        '${ApiBaseData.baseUrl}/auth/send-code',
        data: {"phone": phoneController.text.trim()},
      );
      log(
        '[AuthProvider] sendCode() response: ${response.statusCode} - ${response.data}',
      );

      if (response.statusCode == 200) {
        _codeSent = true;
        log('[AuthProvider] Code sent successfully');
        Get.snackbar(
          'موفقیت',
          'کد تایید ارسال شد',
          backgroundColor: successColor,
          colorText: Colors.white,
        );
      } else {
        log(
          '[AuthProvider] Error sending code: statusCode=${response.statusCode}',
        );
        Get.snackbar(
          'خطا',
          'خطا در ارسال کد',
          backgroundColor: errorColor,
          colorText: Colors.white,
        );
      }
    } on DioError catch (e, stack) {
      log('[AuthProvider] DioError in sendCode(): $e', stackTrace: stack);
      errorMessage = e.response?.data?["message"] ?? 'Network error';
      Get.snackbar(
        'خطا',
        errorMessage,
        backgroundColor: errorColor,
        colorText: Colors.white,
      );
    } catch (e, stack) {
      log('[AuthProvider] Exception in sendCode(): $e', stackTrace: stack);
      errorMessage = 'Unexpected error occurred';
      Get.snackbar(
        'خطا',
        errorMessage,
        backgroundColor: errorColor,
        colorText: Colors.white,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
      log('[AuthProvider] sendCode() finished');
    }
  }

  Future<void> verifyCode() async {
    log('[AuthProvider] verifyCode() called');
    if (codeController.text.trim().length != 5) {
      log(
        '[AuthProvider] Invalid code length: ${codeController.text.trim().length}',
      );
      Get.snackbar(
        'خطا',
        'کد تایید باید ۵ رقمی باشد',
        backgroundColor: errorColor,
        colorText: Colors.white,
      );
      return;
    }

    _isLoading = true;
    notifyListeners();
    log(
      '[AuthProvider] Verifying code: ${codeController.text.trim()} for phone: ${phoneController.text.trim()}',
    );

    try {
      final dio = Dio();
      final response = await dio.post(
        '${ApiBaseData.baseUrl}/auth/verify-code',
        data: {
          "phone": phoneController.text.trim(),
          "code": codeController.text.trim(),
        },
      );
      log(
        '[AuthProvider] verifyCode() response: ${response.statusCode} - ${response.data}',
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        log('[AuthProvider] Token received: $token');
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(TokenDataSource.tokenKey, token);
          log('[AuthProvider] Token saved to SharedPreferences');

          Get.offAll(TransactionsListScreen());
          Get.snackbar(
            'موفقیت',
            'ورود موفقیت‌آمیز بود',
            backgroundColor: successColor,
            colorText: Colors.white,
          );
        } else {
          log('[AuthProvider] Token is null');
          Get.snackbar(
            'خطا',
            'توکن دریافت نشد',
            backgroundColor: errorColor,
            colorText: Colors.white,
          );
        }
      } else {
        log('[AuthProvider] Invalid verification code');
        Get.snackbar(
          'خطا',
          'کد تایید اشتباه است',
          backgroundColor: errorColor,
          colorText: Colors.white,
        );
      }
    } on DioError catch (e, stack) {
      log('[AuthProvider] DioError in verifyCode(): $e', stackTrace: stack);
      errorMessage = e.response?.data?["message"] ?? 'Network error';
      Get.snackbar(
        'خطا',
        errorMessage,
        backgroundColor: errorColor,
        colorText: Colors.white,
      );
    } catch (e, stack) {
      log('[AuthProvider] Exception in verifyCode(): $e', stackTrace: stack);
      errorMessage = 'Unexpected error occurred';
      Get.snackbar(
        'خطا',
        errorMessage,
        backgroundColor: errorColor,
        colorText: Colors.white,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
      log('[AuthProvider] verifyCode() finished');
    }
  }

  String? validatePhone(String? value) {
    log('[AuthProvider] validatePhone() called with value: $value');
    if (value == null || value.trim().isEmpty) {
      return 'لطفا شماره موبایل را وارد کنید';
    }
    final phoneRegExp = RegExp(r'^(09|9)\d{9}$');
    if (!phoneRegExp.hasMatch(value.trim())) {
      return 'شماره موبایل معتبر نیست';
    }
    return null;
  }

  String? validateCode(String? value) {
    log('[AuthProvider] validateCode() called with value: $value');
    if (value == null || value.trim().isEmpty) {
      return 'کد تایید را وارد کنید';
    }
    if (value.trim().length != 5) {
      return 'کد تایید باید ۵ رقمی باشد';
    }
    if (!RegExp(r'^\d{5}$').hasMatch(value.trim())) {
      return 'کد تایید باید فقط شامل عدد باشد';
    }
    return null;
  }

  Future<bool> logout() async {
    log('[AuthProvider] logout() called');
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(TokenDataSource.tokenKey);
      log('[AuthProvider] Token removed, logout successful');
      return true;
    } catch (e, stack) {
      log('[AuthProvider] Exception in logout(): $e', stackTrace: stack);
      return false;
    }
  }

  void reset() {
    log('[AuthProvider] reset() called');
    _codeSent = false;
    phoneController.clear();
    codeController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    log('[AuthProvider] dispose() called');
    phoneController.dispose();
    codeController.dispose();
    super.dispose();
  }
}
