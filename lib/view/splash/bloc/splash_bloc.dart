import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nazmino/bloc/repository/token_repo.dart';
import 'package:nazmino/bloc/repository/version_repo.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final ITokenRepository tokenRepository;
  final IVersionRepository versionRepository;
  SplashBloc(this.tokenRepository, this.versionRepository)
    : super(SplashState()) {
    on<SplashStarted>(_onStarted);
  }

  Future<void> _onStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    emit(state.copyWith(status: SplashStatus.loading));
    await Future.delayed(Duration(seconds: 10));
    try {
      // run both tasks in parallel
      final localVersionFuture = versionRepository.getLocalVersion();
      final serverVersionFuture = versionRepository.getServerVersion();
      final tokenValidFuture = tokenRepository.isTokenValid();

      final results = await Future.wait([
        localVersionFuture,
        serverVersionFuture,
        tokenValidFuture,
      ]);

      final localVersion = results[0] as String;
      final serverVersion = results[1] as String?;
      final hasToken = results[2] as bool;

      bool updateRequired = false;
      if (serverVersion != null) {
        updateRequired = versionRepository.isServerVersionGreater(
          localVersion,
          serverVersion,
        );
      }

      emit(
        state.copyWith(
          status: SplashStatus.success,
          hasValidToken: hasToken,
          updateRequired: updateRequired,
          localVersion: localVersion,
          serverVersion: serverVersion,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: SplashStatus.failure, error: e.toString()));
    }
  }
}
