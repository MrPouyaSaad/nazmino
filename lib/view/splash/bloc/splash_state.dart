part of 'splash_bloc.dart';

enum SplashStatus { initial, loading, success, failure }

class SplashState extends Equatable {
  final SplashStatus status;
  final bool hasValidToken;
  final bool isForcedUpdate;
  final bool isOptionalUpdate;
  final String? localVersion;
  final String? serverVersion;
  final String? updateUrl;
  final List<ChangeLogItem> changelog; // ⬅ اضافه شد
  final String? error;
  const SplashState({
    this.status = SplashStatus.initial,
    this.hasValidToken = false,
    this.isForcedUpdate = false,
    this.isOptionalUpdate = false,
    this.localVersion,
    this.serverVersion,
    this.updateUrl,
    this.changelog = const [], // ⬅ پیش‌فرض لیست خالی
    this.error,
  });

  SplashState copyWith({
    SplashStatus? status,
    bool? hasValidToken,
    bool? isForcedUpdate,
    bool? isOptionalUpdate,
    String? localVersion,
    String? serverVersion,
    String? updateUrl,
    List<ChangeLogItem>? changelog, // ⬅ اضافه شد
    String? error,
  }) {
    return SplashState(
      status: status ?? this.status,
      hasValidToken: hasValidToken ?? this.hasValidToken,
      isForcedUpdate: isForcedUpdate ?? this.isForcedUpdate,
      isOptionalUpdate: isOptionalUpdate ?? this.isOptionalUpdate,
      localVersion: localVersion ?? this.localVersion,
      serverVersion: serverVersion ?? this.serverVersion,
      updateUrl: updateUrl ?? this.updateUrl,
      changelog: changelog ?? this.changelog, // ⬅
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    hasValidToken,
    isForcedUpdate,
    isOptionalUpdate,
    localVersion,
    serverVersion,
    updateUrl,
    changelog, // ⬅
    error,
  ];
}
