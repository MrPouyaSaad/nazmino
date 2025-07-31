import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLogin = true;
  bool _obscurePassword = true;
  bool _isLoading = false;

  bool get isLogin => _isLogin;
  bool get obscurePassword => _obscurePassword;
  bool get isLoading => _isLoading;

  void toggleAuthMode() {
    _isLogin = !_isLogin;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  String? validateEmail(String? value) {
    if (!isLogin && (value == null || value.isEmpty)) {
      return 'لطفا ایمیل را وارد کنید';
    }
    if (!isLogin && !value!.contains('@')) {
      return 'ایمیل معتبر نیست';
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'لطفا نام کاربری را وارد کنید';
    }
    if (value.length < 4) {
      return 'نام کاربری باید حداقل ۴ کاراکتر باشد';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'لطفا رمز عبور را وارد کنید';
    }
    if (value.length < 6) {
      return 'رمز عبور باید حداقل ۶ کاراکتر باشد';
    }
    return null;
  }

  Future<void> submitForm(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      if (isLogin) {
        // Login logic
        await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      } else {
        // Register logic
        await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isLogin ? 'ورود موفقیت‌آمیز بود' : 'ثبت نام موفقیت‌آمیز بود',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطا: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
