import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:nazmino/bloc/source/token_datasource.dart';
import 'package:nazmino/core/api/options.dart';
import 'package:nazmino/view/transaction_list/transactions_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  // final messages = AppMessages.of(Get.context!);

  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController phoneController = TextEditingController(text: '');
  final TextEditingController codeController = TextEditingController(text: '');

  bool _isLoading = false;
  bool _codeSent = false;

  bool get isLoading => _isLoading;
  bool get codeSent => _codeSent;

  Future<void> sendCode() async {
    if (phoneController.text.trim().isEmpty) {
      Get.snackbar(
        'خطا',
        'لطفا شماره موبایل را وارد کنید',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final dio = Dio();
      final response = await dio.post(
        '${ApiBaseData.baseUrl}/auth/send-code',
        data: {"phone": phoneController.text.trim()},
      );

      if (response.statusCode == 200) {
        _codeSent = true;
        Get.snackbar(
          'موفقیت',
          'کد تایید ارسال شد',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'خطا',
          'خطا در ارسال کد',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطا',
        'خطا در ارسال درخواست: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyCode() async {
    if (codeController.text.trim().length != 5) {
      Get.snackbar(
        'خطا',
        'کد تایید باید ۵ رقمی باشد',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final dio = Dio();
      final response = await dio.post(
        '${ApiBaseData.baseUrl}/auth/verify-code',
        data: {
          "phone": phoneController.text.trim(),
          "code": codeController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(TokenDataSource.tokenKey, token);

          Get.offAll(TransactionsListScreen());
          Get.snackbar(
            'موفقیت',
            'ورود موفقیت‌آمیز بود',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'خطا',
            'توکن دریافت نشد',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'خطا',
          'کد تایید اشتباه است',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطا',
        'خطا در ارسال درخواست: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'لطفا شماره موبایل را وارد کنید';
    }
    // بررسی ساختار شماره موبایل (ایرانی)
    final phoneRegExp = RegExp(r'^(09|9)\d{9}$');
    if (!phoneRegExp.hasMatch(value.trim())) {
      return 'شماره موبایل معتبر نیست';
    }
    return null;
  }

  String? validateCode(String? value) {
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

  void reset() {
    _codeSent = false;
    phoneController.clear();
    codeController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    phoneController.dispose();
    codeController.dispose();
    super.dispose();
  }
}
