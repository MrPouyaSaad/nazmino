import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nazmino/provider/auth_provider.dart';
import 'package:nazmino/widgets/auth/auth_form.dart';
import 'package:nazmino/widgets/auth/auth_header.dart';
import 'package:nazmino/widgets/auth/auth_toggle_button.dart';
import 'package:provider/provider.dart';
import '../widgets/auth/auth_button.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: Scaffold(body: const _AuthScreenContent()),
    );
  }
}

class _AuthScreenContent extends StatelessWidget {
  const _AuthScreenContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDarkMode
            ? Brightness.light
            : Brightness.dark,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: const [
              SizedBox(height: 60),
              AuthHeader(),
              SizedBox(height: 40),
              AuthForm(),
              SizedBox(height: 24),
              AuthToggleButton(),
              SizedBox(height: 40),
              AuthButton(),
            ],
          ),
        ),
      ),
    );
  }
}
