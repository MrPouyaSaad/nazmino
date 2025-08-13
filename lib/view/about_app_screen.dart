import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nazmino/core/extensions/app_version.dart';
import 'package:nazmino/core/translate/messages.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(AppMessages.aboutApp.tr), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Logo and Name
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppMessages.appName.tr,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppVersion.version,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 30),

            // App Description
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      AppMessages.aboutDescription.tr,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // Features List
                    _buildFeatureItem(
                      context,
                      icon: CupertinoIcons.money_dollar_circle,
                      text: AppMessages.feature1.tr,
                    ),
                    _buildFeatureItem(
                      context,
                      icon: CupertinoIcons.square_grid_2x2,
                      text: AppMessages.feature2.tr,
                    ),
                    _buildFeatureItem(
                      context,
                      icon: CupertinoIcons.time,
                      text: AppMessages.feature3.tr,
                    ),
                    _buildFeatureItem(
                      context,
                      icon: CupertinoIcons.wifi_slash,
                      text: AppMessages.feature4.tr,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Developer Info
            Text(
              AppMessages.developedBy.tr,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppMessages.pouyaDev.tr,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Contact and Links
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIconButton(
                  context: context,
                  icon: Icons.email,
                  tooltip: 'ارسال ایمیل',
                  onPressed: () =>
                      _launchUrl('mailto:Mr.PouyaSadeghzadeh@gmail.com'),
                ),
                // _buildIconButton(
                //   context: context,
                //   icon: Icons.language,
                //   tooltip: 'وب‌سایت',
                //   onPressed: () => _launchUrl('https://example.com'),
                // ),
                _buildIconButton(
                  context: context,
                  icon: Icons.code,
                  tooltip: 'گیت‌هاب',
                  onPressed: () =>
                      _launchUrl('https://github.com/MrPouyaSaad/nazmino'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Copyright
            Text(
              '© ${DateTime.now().year} ${AppMessages.pouyaDev.tr}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    log('Attempting to launch: $url');
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        log('Can launch, proceeding...');
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        log('Cannot launch: $uri');
      }
    } catch (e) {
      log('Error launching URL: $e');
    }
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required BuildContext context,
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 200),
      tween: Tween(begin: 1.0, end: 0.9),
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        onHover: (hovering) {
          // می‌توانید برای افکت‌های بیشتر از این استفاده کنید
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Tooltip(
            message: tooltip,
            waitDuration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),

            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
        ),
      ).marginSymmetric(horizontal: 8, vertical: 2),
    );
  }
}
