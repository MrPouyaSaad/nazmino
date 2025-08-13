import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key, this.size = 24});
  final double size;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SpinKitFadingCircle(
        size: size,
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}
