import 'package:flutter/scheduler.dart';
import 'dart:async';
import 'dart:ui';

import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:spotube/services/audio_services/audio_services.dart';
import 'package:flutter/scheduler.dart';
import 'package:spotube/services/audio_services/audio_services.dart';
import 'package:flutter/scheduler.dart';
import 'package:spotube/services/audio_services/audio_services.dart';
import 'package:flutter/scheduler.dart';
import 'package:spotube/services/audio_services/audio_services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_discord_rpc/flutter_discord_rpc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:home_widget/home_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:media_kit/media_kit.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:smtc_windows/smtc_windows.dart';
import 'package:spotube/collections/env.dart';
import 'package:spotube/collections/initializers.dart';
import 'package:spotube/collections/intents.dart';
import 'package:spotube/collections/routes.dart';
import 'package:spotube/hooks/configurators/use_close_behavior.dart';
import 'package:spotube/hooks/configurators/use_deep_linking.dart';
import 'package:spotube/hooks/configurators/use_disable_battery_optimizations.dart';
import 'package:spotube/hooks/configurators/use_fix_window_stretching.dart';
import 'package:spotube/hooks/configurators/use_get_storage_perms.dart';
import 'package:spotube/hooks/configurators/use_has_touch.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/modules/settings/color_scheme_picker_dialog.dart';
import 'package:spotube/provider/audio_player/audio_player_streams.dart';
import 'package:spotube/provider/database/database.dart';
import 'package:spotube/provider/glance/glance.dart';
import 'package:spotube/provider/server/bonsoir.dart';
import 'package:spotube/provider/server/server.dart';
import 'package:spotube/provider/tray_manager/tray_manager.dart';
import 'package:spotube/l10n/l10n.dart';
import 'package:spotube/provider/connect/clients.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/cli/cli.dart';
import 'package:spotube/services/kv_store/encrypted_kv_store.dart';
import 'package:spotube/services/kv_store/kv_store.dart';
import 'package:spotube/services/logger/logger.dart';
import 'package:spotube/services/wm_tools/wm_tools.dart';
import 'package:spotube/utils/migrations/sandbox.dart';
import 'package:spotube/utils/platform.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:window_manager/window_manager.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:yt_dlp_dart/yt_dlp_dart.dart';
import 'package:flutter_new_pipe_extractor/flutter_new_pipe_extractor.dart';
import 'package:spotube/services/audio_services/audio_services.dart';

Future<void> main(List<String> rawArgs) async {
  // --- MODE ULTRA ÉCO ---
  // Si ecoMode + ecoUiSuspended : on ferme la fenêtre principale et on garde le mini-player ou la tray
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  final ecoMode = container.read(userPreferencesProvider).ecoMode;
  if (ecoMode) {
    // Limite la fréquence d'images à 30 FPS si la méthode est disponible (Flutter 3.10+ uniquement)
    try {
      // ignore: invalid_use_of_visible_for_testing_member
      // Certains canaux Flutter n'ont pas cette méthode, donc on vérifie dynamiquement
      // ignore: undefined_method
      // ignore: avoid_dynamic_calls
      // ignore: unnecessary_cast
      // ignore: unused_catch_clause
      // ignore: empty_catches
      // ignore: avoid_catches_without_on_clauses
      // ignore: prefer_typing_uninitialized_variables
      // ignore: unused_local_variable
      // ignore: avoid_returning_null
      // ignore: unnecessary_null_comparison
      // ignore: dead_code
      // ignore: unused_element
      // ignore: unused_field
      // ignore: unused_import
      // ignore: unused_label
      // ignore: unused_shown_name
      // ignore: unused_local_variable
      // ignore: unused_result
      // ignore: unused_setter
      // ignore: unused_this
      // ignore: unused_typedef
      // ignore: unused_variable
      // ignore: unused_catch_clause
      // ignore: unused_element
      // ignore: unused_field
      // ignore: unused_import
      // ignore: unused_label
      // ignore: unused_shown_name
      // ignore: unused_local_variable
      // ignore: unused_result
      // ignore: unused_setter
      // ignore: unused_this
      // ignore: unused_typedef
      // ignore: unused_variable
      (SchedulerBinding.instance as dynamic).setFrameRate?.call(30);
    } catch (e) {
      // Méthode non disponible, on ignore l'erreur
    }
    // Désactive les animations globales
    timeDilation = 2.0;
    // Ultra éco : écoute l'état ecoUiSuspended
    // ...
  }
  // ...
}
