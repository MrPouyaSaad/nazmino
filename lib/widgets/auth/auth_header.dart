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
        // Animated switching between phone and verification icons
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: authProvider.codeSent
              ? _buildVerificationIcon(theme)
              : _buildPhoneIcon(theme),
        ),

        const SizedBox(height: 24),

        // Dynamic title based on auth state
        Text(
          authProvider.codeSent
              ? AppMessages.verifyYourNumber.tr
              : AppMessages.loginToYourAccount.tr,

          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        // Dynamic subtitle based on auth state
        Text(
          authProvider.codeSent
              ? 'We sent a code to ${authProvider.phoneController.text}'.tr
              : 'Enter your mobile number to sign in'.tr,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPhoneIcon(ThemeData theme) {
    return Container(
      key: const ValueKey('phone-icon'),
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.phone_iphone_rounded,
        size: 50,
        color: theme.colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildVerificationIcon(ThemeData theme) {
    return Container(
      key: const ValueKey('otp-icon'),
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.secondary,
            theme.colorScheme.secondaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.verified_rounded,
        size: 50,
        color: theme.colorScheme.onSecondary,
      ),
    );
  }
}
