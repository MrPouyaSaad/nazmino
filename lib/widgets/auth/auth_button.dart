import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:nazmino/core/translate/messages.dart';
import 'package:nazmino/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';

class AuthButton extends StatefulWidget {
  const AuthButton({super.key});

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<AuthProvider>();

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // Perspective
          ..rotateX(_isPressed ? 0.03 : 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: provider.isLoading
              ? null
              : provider.codeSent
              ? () => provider.verifyCode()
              : () => provider.sendCode(),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0, // مهم برای حذف سایه پیش‌فرض
          ),
          child: provider.isLoading
              ? AppLoading()
              : Text(
                  provider.codeSent
                      ? AppMessages.confirm.tr
                      : AppMessages.login.tr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
