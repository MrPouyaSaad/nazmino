import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:nazmino/core/translate/messages.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<AuthProvider>();

    return ElevatedButton(
      onPressed: provider.isLoading
          ? null
          : provider.codeSent
          ? () => provider.verifyCode()
          : () => provider.sendCode(),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: provider.isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(
              provider.codeSent ? AppMessages.confirm.tr : AppMessages.login.tr,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
