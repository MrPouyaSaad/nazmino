import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nazmino/provider/auth_provider.dart';

class AuthDynamicHeader extends StatefulWidget {
  const AuthDynamicHeader({super.key});

  @override
  State<AuthDynamicHeader> createState() => _AuthDynamicHeaderState();
}

class _AuthDynamicHeaderState extends State<AuthDynamicHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isVerificationMode = authProvider.codeSent;

    return SizedBox(
      height: 200,
      child: Lottie.asset(
        isVerificationMode
            ? 'assets/images/OTP.json'
            : 'assets/images/Person Using phone.json',
        controller: _animationController,
        onLoaded: (composition) {
          _animationController
            ..duration = composition.duration
            ..repeat();
        },
        frameRate: FrameRate.max,
        options: LottieOptions(enableApplyingOpacityToLayers: true),
      ),
    );
  }
}

class GlowingTextField extends StatelessWidget {
  const GlowingTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ).createShader(bounds);
      },
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
