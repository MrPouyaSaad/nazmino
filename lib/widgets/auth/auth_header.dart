import 'package:flutter/material.dart';
import 'package:nazmino/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLogin = context.watch<AuthProvider>().isLogin;

    return Column(
      children: [
        Icon(Icons.account_circle, size: 80, color: theme.colorScheme.primary),
        const SizedBox(height: 16),
        Text(
          isLogin ? 'ورود به حساب کاربری' : 'ایجاد حساب جدید',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isLogin
              ? 'لطفا اطلاعات حساب خود را وارد کنید'
              : 'فرم زیر را برای ثبت نام تکمیل کنید',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
