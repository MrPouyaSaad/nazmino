import 'package:flutter/material.dart';
import 'package:nazmino/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthToggleButton extends StatelessWidget {
  const AuthToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.read<AuthProvider>();
    final isLogin = context.watch<AuthProvider>().isLogin;

    return TextButton(
      onPressed: provider.toggleAuthMode,
      child: RichText(
        text: TextSpan(
          text: isLogin ? 'حساب کاربری ندارید؟ ' : 'قبلا ثبت نام کرده‌اید؟ ',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          children: [
            TextSpan(
              text: isLogin ? 'ثبت نام' : 'ورود',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
