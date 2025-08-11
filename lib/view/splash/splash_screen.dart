import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:nazmino/bloc/repository/token_repo.dart';
import 'package:nazmino/bloc/repository/version_repo.dart';
import 'package:nazmino/view/auth_screen.dart';
import 'package:nazmino/view/transaction_list/transactions_list_screen.dart';

import 'bloc/splash_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final SplashBloc _bloc;
  late final AnimationController _logoController;

  @override
  void initState() {
    super.initState();
    _bloc = SplashBloc(tokenRposistory, versionRepository);
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.add(SplashStarted());
    });
  }

  @override
  void dispose() {
    _bloc.close();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state.status == SplashStatus.success) {
            if (state.updateRequired) {
              _showUpdateDialog(state.serverVersion, state.localVersion);
            } else if (state.hasValidToken) {
              Get.off(() => const TransactionsListScreen());
            } else {
              Get.off(() => const AuthScreen());
            }
          } else if (state.status == SplashStatus.failure) {
            _showErrorDialog(state.error ?? 'خطای ناشناخته');
          }
        },
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: CurvedAnimation(
                      parent: _logoController,
                      curve: Curves.easeOutBack,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Lottie.asset(
                    'assets/images/loading.json',
                    width: 150,
                    height: 150,
                    repeat: true,
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<SplashBloc, SplashState>(
                    builder: (context, state) {
                      if (state.status == SplashStatus.loading ||
                          state.status == SplashStatus.initial) {
                        return const Text(
                          'در حال آماده‌سازی...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      } else if (state.status == SplashStatus.failure) {
                        return Text(
                          'خطا: ${state.error}',
                          style: const TextStyle(color: Colors.redAccent),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showUpdateDialog(String? serverVersion, String? localVersion) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.system_update, size: 64, color: Colors.blue),
                const SizedBox(height: 16),
                const Text(
                  'به‌روزرسانی جدید موجود است!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'نسخه سرور: $serverVersion\nنسخه شما: $localVersion',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(45),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    const url =
                        'bazaar://details?id=com.example.yourapp'; // جایگزین کن
                    // if (await canLaunchUrl(Uri.parse(url))) {
                    //   launchUrl(Uri.parse(url));
                    // }
                  },
                  child: const Text(
                    'دانلود از کافه‌بازار',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('خطا'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('باشه'),
          ),
        ],
      ),
    );
  }
}
