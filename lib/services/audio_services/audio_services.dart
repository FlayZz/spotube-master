import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
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
    final mobile = (kIsMobile || kIsMacOS || kIsLinux)
        ? await AudioService.init(
            builder: () => MobileAudioService(playback),
            config: AudioServiceConfig(/* … */),
          )
        : null;
    final smtc = kIsWindows ? WindowsAudioService(ref, playback) : null;
    return AudioServices(mobile, smtc, ref);
  }

  Future<void> addTrack(Track track) async {
    smtc?.addTrack(track);
    mobile?.addItem(MediaItem(
      id: track.id!,
      title: track.name!,
      album: track.album?.name ?? '',
      artist: (track.artists)?.asString() ?? '',
      duration: track is SourcedTrack
          ? track.sourceInfo.duration
          : Duration(milliseconds: track.durationMs ?? 0),
      artUri: Uri.parse(
        (track.album?.images).asUrlString(),
      ),
      playable: true,
    ));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final eco = ref.read(userPreferencesProvider).ecoMode;
    if (eco && (state == AppLifecycleState.paused || state == AppLifecycleState.inactive)) {
      ecoUiSuspended.value = true;
    } else if (eco && state == AppLifecycleState.resumed) {
      ecoUiSuspended.value = false;
    }
  }

  void dispose() {
    smtc?.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  static final ValueNotifier<bool> ecoUiSuspended = ValueNotifier(false);
}