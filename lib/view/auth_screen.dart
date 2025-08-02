import 'package:flutter/material.dart';
import 'package:nazmino/widgets/auth/auth_button.dart';
import 'package:nazmino/widgets/auth/auth_form.dart';
import 'package:nazmino/widgets/auth/auth_header.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AuthHeader(),
                const SizedBox(height: 32),
                const AuthForm(),
                const SizedBox(height: 32),
                const AuthButton(),
                const SizedBox(height: 16),
                // const AuthToggleButton(),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: theme.colorScheme.background,
    );
  }
}
