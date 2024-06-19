part of 'app_theme.dart';

class AppRemoteAssets {
  /// DEV
  // static const String host = 'https://naporoge-vuz-app.flutteria.dev';

  // PROD
  static const String host = 'https://umadmin.naporoge.ru';

  static const String videoFolder = '/storage/videos';
  static const String imagesFolder = '/storage/images';

  videoAssets() {
    return host + videoFolder;
  }

  imagesAssets() {
    return host + imagesFolder;
  }
}
