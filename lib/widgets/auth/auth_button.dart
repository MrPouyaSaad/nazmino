import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<AuthProvider>();
    final isLogin = provider.isLogin;

    return ElevatedButton(
      onPressed: provider.isLoading ? null : () => provider.submitForm(context),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: provider.isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(
              isLogin ? 'ورود' : 'ثبت نام',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
