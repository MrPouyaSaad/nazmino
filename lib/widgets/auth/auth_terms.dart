import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/translate/messages.dart';

class AuthTerms extends StatelessWidget {
  const AuthTerms({super.key});

  void _showDialog(BuildContext context, String title, String content) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: theme.textTheme.titleMedium),
        content: SingleChildScrollView(
          child: Text(content, style: theme.textTheme.bodyMedium),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(AppMessages.ok.tr),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        children: [
          TextSpan(text: AppMessages.termsPrefix.tr),
          WidgetSpan(
            child: GestureDetector(
              onTap: () => _showDialog(
                context,
                AppMessages.termsOfUse.tr,
                AppMessages.termsOfUseContent.tr,
              ),
              child: Text(
                AppMessages.termsOfUse.tr,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          TextSpan(text: AppMessages.and.tr),
          WidgetSpan(
            child: GestureDetector(
              onTap: () => _showDialog(
                context,
                AppMessages.privacyPolicy.tr,
                AppMessages.privacyPolicyContent.tr,
              ),
              child: Text(
                AppMessages.privacyPolicy.tr,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.solid,
                ),
              ),
            ),
          ),
          TextSpan(text: AppMessages.termsSuffix.tr),
        ],
      ),
    );
  }
}
