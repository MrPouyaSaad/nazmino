import 'package:appcheck/appcheck.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nazmino/core/api/validator.dart';
import 'package:nazmino/widgets/error_widget.dart';
import 'package:nazmino/widgets/loading_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nazmino/bloc/repository/token_repo.dart';
import 'package:nazmino/bloc/repository/version_repo.dart';
import 'package:nazmino/view/auth_screen.dart';
import 'package:nazmino/view/transaction_list/transactions_list_screen.dart';

import '../../bloc/model/version.dart';
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
    final theme = Theme.of(context);
    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state.status == SplashStatus.success) {
            if (state.isForcedUpdate) {
              // نمایش دیالوگ آپدیت اجباری
              _showUpdateSheet(
                context: context,
                serverVersion: state.serverVersion,
                localVersion: state.localVersion,
                updateUrl: state.updateUrl,
                changelog: state.changelog,
                isForced: true,
              );
              return;
            } else if (state.isOptionalUpdate) {
              // نمایش دیالوگ آپدیت اختیاری
              _showUpdateSheet(
                context: context,
                changelog: state.changelog,
                serverVersion: state.serverVersion,
                localVersion: state.localVersion,
                updateUrl: state.updateUrl,
                isForced: false,
              );
              return;
            } else if (state.hasValidToken) {
              Get.off(() => const TransactionsListScreen());
            } else {
              Get.off(() => const AuthScreen());
            }
          } else if (state.status == SplashStatus.failure) {
            _showErrorDialog(errorMessage);
          }
        },
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                // colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
                colors: [Color(0xFF2193b0), theme.cardColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // const SizedBox(height: 24),
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
                Lottie.asset(
                  'assets/images/loading.json',
                  width: 250,
                  height: 250,
                  repeat: true,
                ),
                const SizedBox(height: 54),

                BlocBuilder<SplashBloc, SplashState>(
                  builder: (context, state) {
                    final bloc = BlocProvider.of<SplashBloc>(context);
                    if (state.status == SplashStatus.loading ||
                        state.status == SplashStatus.success ||
                        state.status == SplashStatus.initial) {
                      return const AppLoading(size: 32);
                    } else if (state.status == SplashStatus.failure) {
                      return AppErrorWidget(
                        onRetry: () => bloc.add(SplashStarted()),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showUpdateSheet({
    required BuildContext context,
    required bool isForced,
    required String? serverVersion,
    required String? localVersion,
    required String? updateUrl,
    required List<ChangeLogItem> changelog,
  }) {
    if (changelog.isEmpty) {
      changelog = [
        ChangeLogItem(
          fa: "بهینه‌سازی عملکرد و سرعت برنامه",
          en: "Performance optimization and app speed improvements",
        ),
        ChangeLogItem(
          fa: "رفع مشکلات گزارش شده توسط کاربران",
          en: "Fixed reported user issues",
        ),
      ];
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // انیمیشن کنترلر برای افکت‌های ورود
    final animationController = AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 600),
    );

    final curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOutQuart,
    );

    // اجرای انیمیشن پس از ساخت ویجت
    WidgetsBinding.instance.addPostFrameCallback((_) {
      animationController.forward();
    });

    Get.bottomSheet(
      WillPopScope(
        onWillPop: () async => !isForced,
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, (1 - curvedAnimation.value) * 100),
              child: Opacity(opacity: curvedAnimation.value, child: child),
            );
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.surface,
                  colorScheme.surfaceContainerHighest,
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 30,
                  spreadRadius: 5,
                  color: Colors.black.withOpacity(0.25),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar با انیمیشن
                  Center(
                    child: Container(
                      width: 48,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: colorScheme.outline.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),

                  // هدر با آیکون متحرک
                  SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(-0.5, 0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animationController,
                            curve: const Interval(
                              0.1,
                              0.5,
                              curve: Curves.easeOutBack,
                            ),
                          ),
                        ),
                    child: FadeTransition(
                      opacity: animationController,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  isForced
                                      ? colorScheme.errorContainer
                                      : colorScheme.primaryContainer,
                                  isForced
                                      ? colorScheme.error
                                      : colorScheme.primary,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      (isForced
                                              ? colorScheme.error
                                              : colorScheme.primary)
                                          .withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.rocket_launch_rounded,
                              size: 30,
                              color: isForced
                                  ? colorScheme.onErrorContainer
                                  : colorScheme.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isForced
                                      ? 'آپدیت ضروری'
                                      : 'نسخه جدید موجود است!',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                Text(
                                  'تجربه بهتری در انتظار شماست',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // نسخه‌ها با افکت موجی
                  ScaleTransition(
                    scale: animationController,
                    child: FadeTransition(
                      opacity: animationController,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceVariant.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'نسخه فعلی',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                Text(
                                  localVersion ?? '--',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: colorScheme.outlineVariant.withOpacity(
                                0.3,
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  'نسخه جدید',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.primary,
                                  ),
                                ),
                                Text(
                                  serverVersion ?? '--',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // عنوان تغییرات
                  SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0, 0.5),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animationController,
                            curve: const Interval(
                              0.3,
                              0.7,
                              curve: Curves.easeOut,
                            ),
                          ),
                        ),
                    child: FadeTransition(
                      opacity: animationController,
                      child: Row(
                        children: [
                          Icon(
                            Icons.new_releases_rounded,
                            color: colorScheme.primary,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'تغییرات نسخه جدید:',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // لیست تغییرات با انیمیشن پلکانی
                  ...List.generate(changelog.length, (index) {
                    final intervalStart = 0.4 + (index * 0.1);
                    return SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(-0.5, 0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animationController,
                              curve: Interval(
                                intervalStart.clamp(0.0, 1.0),
                                (intervalStart + 0.3).clamp(0.0, 1.0),
                                curve: Curves.easeOut,
                              ),
                            ),
                          ),
                      child: FadeTransition(
                        opacity: animationController,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.verified_rounded,
                                color: colorScheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  changelog[index].fa,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 28),

                  // دکمه‌های اقدام
                  ScaleTransition(
                    scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animationController,
                        curve: const Interval(
                          0.6,
                          1.0,
                          curve: Curves.easeOutBack,
                        ),
                      ),
                    ),
                    child: FadeTransition(
                      opacity: animationController,
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor: isForced
                                    ? colorScheme.errorContainer
                                    : colorScheme.primaryContainer,
                                foregroundColor: isForced
                                    ? colorScheme.onErrorContainer
                                    : colorScheme.onPrimaryContainer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 2,
                                shadowColor: isForced
                                    ? colorScheme.error
                                    : colorScheme.primary,
                              ),
                              onPressed: () => _launchUpdate(updateUrl),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.download_rounded, size: 22),
                                  const SizedBox(width: 8),
                                  Text(
                                    'دانلود و نصب آپدیت',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isForced
                                          ? colorScheme.onErrorContainer
                                          : colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          if (!isForced) ...[
                            const SizedBox(height: 12),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () {
                                animationController.reverse().then(
                                  (_) => Get.back(),
                                );
                              },
                              child: Text(
                                'فعلاً نه، ممنون',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      enableDrag: !isForced,
      barrierColor: Colors.black.withOpacity(0.6),
      isDismissible: !isForced,
    );

    // Dispose animation controller when sheet is closed
    Future.delayed(animationController.duration!, () {
      if (!animationController.isAnimating) {
        animationController.dispose();
      }
    });
  }

  Future<void> _launchUpdate(String? url) async {
    const bazaarUrl = 'bazaar://details?id=com.nazmino';
    final updateUrl = url ?? bazaarUrl;

    try {
      if (await canLaunchUrl(Uri.parse(updateUrl))) {
        await launchUrl(
          Uri.parse(updateUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        Get.snackbar('خطا', 'امکان باز کردن لینک آپدیت وجود ندارد');
      }
    } catch (e) {
      Get.snackbar('خطا', 'خطا در اجرای لینک آپدیت');
    }
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
