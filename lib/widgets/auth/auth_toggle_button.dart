import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:nazmino/core/translate/messages.dart';
import 'package:nazmino/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthResendCodeButton extends StatefulWidget {
  const AuthResendCodeButton({super.key});

  @override
  State<AuthResendCodeButton> createState() => _AuthResendCodeButtonState();
}

class _AuthResendCodeButtonState extends State<AuthResendCodeButton> {
  static const int _resendWaitSeconds = 60;

  Timer? _timer;
  int _secondsLeft = _resendWaitSeconds;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsLeft = _resendWaitSeconds;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
        setState(() {});
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _resendCode(AuthProvider provider) {
    provider.sendCode();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.read<AuthProvider>();

    return Row(
      children: [
        if (_secondsLeft != 0)
          Text(
            _secondsLeft == 0
                ? AppMessages.resendCode.tr
                : AppMessages.resendIn.tr,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        const Spacer(),
        TextButton(
          onPressed: _secondsLeft == 0 ? () => _resendCode(provider) : null,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            backgroundColor: _secondsLeft != 0
                ? Colors.transparent
                : theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          ),
          child: Text(
            _secondsLeft == 0
                ? AppMessages.resendCode.tr
                : '$_secondsLeft ${AppMessages.seconds.tr}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: _secondsLeft == 0
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.primary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
