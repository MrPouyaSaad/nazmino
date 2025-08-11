part of 'splash_bloc.dart';

enum SplashStatus { initial, loading, success, failure }

class SplashState extends Equatable {
  final SplashStatus status;
  final bool hasValidToken;
  final bool updateRequired;
  final String? localVersion;
  final String? serverVersion;
  final String? error;

  const SplashState({
    this.status = SplashStatus.initial,
    this.hasValidToken = false,
    this.updateRequired = false,
    this.localVersion,
    this.serverVersion,
    this.error,
  });

  SplashState copyWith({
    SplashStatus? status,
    bool? hasValidToken,
    bool? updateRequired,
    String? localVersion,
    String? serverVersion,
    String? error,
  }) {
    return SplashState(
      status: status ?? this.status,
      hasValidToken: hasValidToken ?? this.hasValidToken,
      updateRequired: updateRequired ?? this.updateRequired,
      localVersion: localVersion ?? this.localVersion,
      serverVersion: serverVersion ?? this.serverVersion,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    hasValidToken,
    updateRequired,
    localVersion,
    serverVersion,
    error,
  ];
}
