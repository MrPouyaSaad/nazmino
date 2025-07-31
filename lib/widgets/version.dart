import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionWidget extends StatefulWidget {
  const VersionWidget({super.key});

  @override
  State<VersionWidget> createState() => _VersionWidgetState();
}

class _VersionWidgetState extends State<VersionWidget> {
  String appVersion = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = 'Version ${packageInfo.version}'; // مثلا: 1.0.1
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      appVersion,
      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
    );
  }
}
