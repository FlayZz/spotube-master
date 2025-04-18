import 'package:audio_service/audio_service.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/env.dart';
import 'package:spotube/extensions/artist_simple.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/audio_services/mobile_audio_service.dart';
import 'package:spotube/services/audio_services/windows_audio_service.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';
import 'package:spotube/utils/platform.dart';

class AudioServices with WidgetsBindingObserver {
  final MobileAudioService? mobile;
  final WindowsAudioService? smtc;
  final Ref ref;

  AudioServices(this.mobile, this.smtc, this.ref) {
    WidgetsBinding.instance.addObserver(this);
  }

  static Future<AudioServices> create(
    Ref ref,
    AudioPlayerNotifier playback,
  ) async {
    final mobile = kIsMobile || kIsMacOS || kIsLinux
        ? await AudioService.init(
            builder: () => MobileAudioService(playback),
            config: AudioServiceConfig(
              androidNotificationChannelId: switch ((
                kIsLinux,
                Env.releaseChannel
              )) {
                (true, _) => "spotube",
                (_, ReleaseChannel.stable) => "com.krtirtho.Spotube",
                (_, ReleaseChannel.nightly) => "com.krtirtho.Spotube.nightly",
              },
              androidNotificationChannelName: 'Spotube',
              androidNotificationOngoing: false,
              androidStopForegroundOnPause: false,
            ),
          )
        : null;
    final smtc = kIsWindows ? await WindowsAudioService.create(playback) : null;
    return AudioServices(mobile, smtc, ref);
  }

  void setMediaItem(MediaItem mediaItem) {
    mobile?.setMediaItem(mediaItem);
    smtc?.setMediaItem(mediaItem);
  }

  void activateSession() {
    mobile?.session?.setActive(true);
  }

  void deactivateSession() {
    mobile?.session?.setActive(false);
  }

  // --- OPTIMISATION MODE ÉCO : Suspension UI quand l'app est en arrière-plan ---
  static final ValueNotifier<bool> ecoUiSuspended = ValueNotifier(false);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final ecoMode = ref.read(userPreferencesProvider).ecoMode;
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        if (ecoMode) {
          ecoUiSuspended.value = true; // Suspendre le rendu UI
          // TODO: Ajouter ici la désactivation des animations, timers, images, etc.
        }
        break;
      case AppLifecycleState.resumed:
        if (ecoMode) {
          ecoUiSuspended.value = false; // Réactiver le rendu UI
          // TODO: Réactiver les animations, timers, images, etc.
        }
        break;
      case AppLifecycleState.detached:
        deactivateSession();
        // audioPlayer.pause(); // Ajoute la logique si besoin
        break;
      default:
        break;
    }
  }

  void dispose() {
    smtc?.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
}
