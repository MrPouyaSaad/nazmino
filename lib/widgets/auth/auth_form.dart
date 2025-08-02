import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nazmino/core/translate/messages.dart';
import 'package:nazmino/provider/auth_provider.dart';
import 'package:nazmino/widgets/auth/auth_toggle_button.dart';
import 'package:nazmino/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class AuthForm extends StatelessWidget {
  const AuthForm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();

    return Form(
      key: provider.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,

        children: [
          CustomTextField(
            keyboardType: TextInputType.numberWithOptions(),
            controller: provider.codeSent
                ? provider.codeController
                : provider.phoneController,
            labelText: provider.codeSent
                ? AppMessages.code.tr
                : AppMessages.username.tr,
            icon: provider.codeSent ? Icons.password : Icons.phone_android,
            validator: (value) => provider.codeSent
                ? provider.validateCode(value)
                : provider.validatePhone(value),
          ),
          SizedBox(height: 8),
          if (provider.codeSent) AuthResendCodeButton(),
        ],
      ),
    );
  }
}
