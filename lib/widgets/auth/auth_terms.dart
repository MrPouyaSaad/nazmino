import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthTerms extends StatelessWidget {
  const AuthTerms({super.key});

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
          const TextSpan(text: 'با ادامه، شما '),
          TextSpan(
            text: 'شرایط استفاده',
            style: TextStyle(
              color: theme.colorScheme.primary,
              decoration: TextDecoration.underline,
            ),
          ),
          const TextSpan(text: ' و '),
          TextSpan(
            text: 'سیاست حفظ حریم خصوصی',
            style: TextStyle(
              color: theme.colorScheme.primary,
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.solid,
            ),
          ),
          const TextSpan(text: ' ما را می‌پذیرید.'),
        ],
      ),
    );
  }
}
