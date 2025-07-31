import 'package:flutter/material.dart';
import 'package:nazmino/provider/auth_provider.dart';
import 'package:nazmino/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class AuthForm extends StatelessWidget {
  const AuthForm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    final isLogin = provider.isLogin;

    return Form(
      key: provider.formKey,
      child: Column(
        children: [
          if (!isLogin)
            CustomTextField(
              controller: provider.emailController,
              labelText: 'ایمیل',
              icon: Icons.email,
              validator: (value) => provider.validateEmail(value),
            ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: provider.usernameController,
            labelText: 'نام کاربری',
            icon: Icons.person,
            validator: (value) => provider.validateUsername(value),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: provider.passwordController,
            labelText: 'رمز عبور',
            icon: Icons.lock,
            obscureText: provider.obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                provider.obscurePassword
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: provider.togglePasswordVisibility,
            ),
            validator: (value) => provider.validatePassword(value),
          ),
        ],
      ),
    );
  }
}
