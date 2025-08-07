import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nazmino/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:nazmino/core/translate/messages.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Column(
      children: [
        // Animated icon with smooth transition
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: authProvider.codeSent
              ? _buildVerificationBadge(theme)
              : _buildPhoneBadge(theme),
        ),

        const SizedBox(height: 32),

        // Title with smooth fade transition
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            key: ValueKey(authProvider.codeSent ? 'verify' : 'login'),
            authProvider.codeSent
                ? AppMessages.verifyYourNumber.tr
                : AppMessages.loginToYourAccount.tr,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 12),

        // Subtitle with smooth fade transition
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            key: ValueKey(
              authProvider.codeSent
                  ? 'code-sent-${authProvider.phoneController.text}'
                  : 'enter-number',
            ),
            authProvider.codeSent
                ? 'کد تأیید به ${authProvider.phoneController.text} ارسال شد'
                : 'شماره موبایل خود را وارد کنید',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneBadge(ThemeData theme) {
    return Container(
      key: const ValueKey('phone-badge'),
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: theme.colorScheme.onPrimary, width: 2),
      ),
      child: Icon(
        Icons.phone_iphone_rounded,
        size: 60,
        color: theme.colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildVerificationBadge(ThemeData theme) {
    return Container(
      key: const ValueKey('otp-badge'),
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: theme.colorScheme.secondary, width: 2),
      ),
      child: Icon(
        Icons.verified_rounded,
        size: 60,
        color: theme.colorScheme.secondary,
      ),
    );
  }
}
