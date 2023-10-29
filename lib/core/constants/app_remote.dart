part of 'app_theme.dart';

class AppRemoteAssets {
  // static const String host = 'https://np-new.evgeniydoronin.com';

  static const String host = 'https://np-app.evgeniydoronin.com';

  // static const String host = 'https://umadmin.naporoge.ru';
  static const String videoFolder = '/storage/videos';
  static const String imagesFolder = '/storage/images';

  videoAssets() {
    return host + videoFolder;
  }

  imagesAssets() {
    return host + imagesFolder;
  }
}
