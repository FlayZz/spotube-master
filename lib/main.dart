import 'package:flutter/scheduler.dart';
import 'dart:async';
import 'dart:ui';

import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
import 'package:spotube/models/database/tables/preferences.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
// ... autres imports nécessaires ...

Future<void> main(List<String> rawArgs) async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  final ecoMode = container.read(userPreferencesProvider).ecoMode;
  if (ecoMode) {
    SchedulerBinding.instance?.setFrameRate(30);
    timeDilation = 2.0;
    // ... gestion ecoUiSuspended ...
  }
  // ... reste du main ...
}
// ... reste du fichier ...