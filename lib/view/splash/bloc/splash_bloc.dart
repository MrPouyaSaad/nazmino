import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nazmino/bloc/repository/token_repo.dart';
import 'package:nazmino/bloc/repository/version_repo.dart';

import '../../../bloc/model/version.dart';

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

    try {
      final localVersionFuture = versionRepository.getLocalVersion();
      final serverInfoFuture = versionRepository.getServerVersionInfo();
      final tokenValidFuture = tokenRepository.isTokenValid();

      final results = await Future.wait([
        localVersionFuture,
        serverInfoFuture,
        tokenValidFuture,
      ]);

      final localVersion = results[0] as String;
      final serverInfo = results[1] as VersionInfo?;
      final hasToken = results[2] as bool;

      if (serverInfo == null) {
        emit(
          state.copyWith(
            status: SplashStatus.failure,
            error: "دریافت اطلاعات نسخه ناموفق بود",
          ),
        );
        return;
      }

      final isForcedUpdate = versionRepository.isServerVersionGreater(
        localVersion,
        serverInfo.minSupportedVersion,
      );

      final isOptionalUpdate =
          !isForcedUpdate &&
          versionRepository.isServerVersionGreater(
            localVersion,
            serverInfo.latestVersion,
          );

      emit(
        state.copyWith(
          status: SplashStatus.success,
          hasValidToken: hasToken,
          isForcedUpdate: isForcedUpdate,
          isOptionalUpdate: isOptionalUpdate,
          localVersion: localVersion,
          serverVersion: serverInfo.latestVersion,
          updateUrl: serverInfo.updateUrl,
          changelog: serverInfo.changelog,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: SplashStatus.failure, error: e.toString()));
    }
  }
}
