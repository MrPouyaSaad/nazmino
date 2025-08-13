class ChangeLogItem {
  final String fa;
  final String en;

  ChangeLogItem({required this.fa, required this.en});

  factory ChangeLogItem.fromJson(Map<String, dynamic> json) {
    return ChangeLogItem(fa: json['fa'] ?? '', en: json['en'] ?? '');
  }
}

class VersionInfo {
  final String latestVersion;
  final String minSupportedVersion;
  final String updateUrl;
  final List<ChangeLogItem> changelog;

  VersionInfo({
    required this.latestVersion,
    required this.minSupportedVersion,
    required this.updateUrl,
    required this.changelog,
  });

  factory VersionInfo.fromJson(Map<String, dynamic> json) {
    return VersionInfo(
      latestVersion: json['latest_version'] as String,
      minSupportedVersion: json['minimum_supported_version'] as String,
      updateUrl: json['update_url'] as String,
      changelog: (json['changelog'] as List<dynamic>? ?? [])
          .map((item) => ChangeLogItem.fromJson(item))
          .toList(),
    );
  }
}
