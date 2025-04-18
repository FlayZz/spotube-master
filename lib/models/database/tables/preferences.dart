part of '../database.dart';

enum LayoutMode {
  compact,
  extended,
  adaptive,
}

enum CloseBehavior {
  minimizeToTray,
  close,
}

enum AudioSource {
  youtube,
  piped,
  jiosaavn,
  invidious;

  String get label {
    return name[0].toUpperCase() + name.substring(1);
  }
}

enum YoutubeClientEngine {
  ytDlp("yt-dlp"),
  youtubeExplode("YouTubeExplode"),
  newPipe("NewPipe");

  final String label;

  const YoutubeClientEngine(this.label);

  bool isAvailableForPlatform() {
    return switch (this) {
      YoutubeClientEngine.youtubeExplode =>
        YouTubeExplodeEngine.isAvailableForPlatform,
      YoutubeClientEngine.ytDlp => YtDlpEngine.isAvailableForPlatform,
      YoutubeClientEngine.newPipe => NewPipeEngine.isAvailableForPlatform,
    };
  }
}

enum MusicCodec {
  m4a._("M4a (Best for downloaded music)"),
  weba._("WebA (Best for streamed music)\nDoesn't support audio metadata");

  final String label;
  const MusicCodec._(this.label);
}

enum SearchMode {
  youtube._("YouTube"),
  youtubeMusic._("YouTube Music");

  final String label;

  const SearchMode._(this.label);

  factory SearchMode.fromString(String key) {
    return SearchMode.values.firstWhere((e) => e.name == key);
  }
}

class PreferencesTable extends Table {
  BoolColumn get ecoMode {
    return boolean().withDefault(const Constant(false))();
  }
  IntColumn get id {
    return integer().autoIncrement()();
  }
  TextColumn get audioQuality {
    return textEnum<SourceQualities>().withDefault(Constant(SourceQualities.high.name))();
  }
  BoolColumn get albumColorSync {
    return boolean().withDefault(const Constant(true))();
  }
  BoolColumn get amoledDarkTheme {
    return boolean().withDefault(const Constant(false))();
  }
  BoolColumn get checkUpdate {
    return boolean().withDefault(const Constant(true))();
  }
  BoolColumn get normalizeAudio {
    return boolean().withDefault(const Constant(false))();
  }
  BoolColumn get showSystemTrayIcon {
    return boolean().withDefault(const Constant(false))();
  }
  BoolColumn get systemTitleBar {
    return boolean().withDefault(const Constant(false))();
  }
  BoolColumn get skipNonMusic {
    return boolean().withDefault(const Constant(false))();
  }
  TextColumn get closeBehavior {
    return textEnum<CloseBehavior>().withDefault(Constant(CloseBehavior.close.name))();
  }
  TextColumn get accentColorScheme {
    return text().withDefault(const Constant("Blue:0xFF2196F3")).map(const SpotubeColorConverter())();
  }
  TextColumn get layoutMode {
    return textEnum<LayoutMode>().withDefault(Constant(LayoutMode.adaptive.name))();
  }
  TextColumn get locale {
    return text().withDefault(
      const Constant('{"languageCode":"system","countryCode":"system"}'),
    ).map(const LocaleConverter())();
  }
  TextColumn get market {
    return textEnum<Market>().withDefault(Constant(Market.US.name))();
  }
  TextColumn get searchMode {
    return textEnum<SearchMode>().withDefault(Constant(SearchMode.youtube.name))();
  }
  TextColumn get downloadLocation {
    return text().withDefault(const Constant(""))();
  }
  TextColumn get localLibraryLocation {
    return text().withDefault(const Constant("")).map(const StringListConverter())();
  }
  TextColumn get pipedInstance {
    return text().withDefault(const Constant("https://pipedapi.kavin.rocks"))();
  }
  TextColumn get invidiousInstance {
    return text().withDefault(const Constant("https://inv.nadeko.net"))();
  }
  TextColumn get themeMode {
    return textEnum<ThemeMode>().withDefault(Constant(ThemeMode.system.name))();
  }
  TextColumn get audioSource {
    return textEnum<AudioSource>().withDefault(Constant(AudioSource.youtube.name))();
  }
  TextColumn get youtubeClientEngine {
    return textEnum<YoutubeClientEngine>().withDefault(Constant(YoutubeClientEngine.youtubeExplode.name))();
  }
  TextColumn get streamMusicCodec {
    return textEnum<SourceCodecs>().withDefault(Constant(SourceCodecs.weba.name))();
  }
  TextColumn get downloadMusicCodec {
    return textEnum<SourceCodecs>().withDefault(Constant(SourceCodecs.m4a.name))();
  }
  BoolColumn get discordPresence {
    return boolean().withDefault(const Constant(true))();
  }
  BoolColumn get endlessPlayback {
    return boolean().withDefault(const Constant(true))();
  }
  BoolColumn get enableConnect {
    return boolean().withDefault(const Constant(false))();
  }
  BoolColumn get cacheMusic {
    return boolean().withDefault(const Constant(true))();
  }

  // Default values as PreferencesTableData
  static PreferencesTableData defaults() {
    return PreferencesTableData(
      id: 0,
      audioQuality: SourceQualities.high,
      albumColorSync: true,
      amoledDarkTheme: false,
      checkUpdate: true,
      normalizeAudio: false,
      showSystemTrayIcon: false,
      systemTitleBar: false,
      skipNonMusic: false,
      closeBehavior: CloseBehavior.close,
      accentColorScheme: SpotubeColor(Colors.blue.value, name: "Blue"),
      layoutMode: LayoutMode.adaptive,
      locale: const Locale("system", "system"),
      market: Market.US,
      searchMode: SearchMode.youtube,
      downloadLocation: "",
      localLibraryLocation: [],
      pipedInstance: "https://pipedapi.kavin.rocks",
      invidiousInstance: "https://inv.nadeko.net",
      themeMode: ThemeMode.system,
      audioSource: AudioSource.youtube,
      youtubeClientEngine: YoutubeClientEngine.youtubeExplode,
      streamMusicCodec: SourceCodecs.m4a,
      downloadMusicCodec: SourceCodecs.m4a,
      discordPresence: true,
      endlessPlayback: true,
      enableConnect: false,
      cacheMusic: true,
      ecoMode: false,
    );
  }
}
