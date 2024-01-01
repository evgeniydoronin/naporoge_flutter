class Endpoints {
  Endpoints._();

  // base url
  // static const String baseUrl = "https://np-new.evgeniydoronin.com/api";

  // static const String site = "https://umadmin.naporoge.ru";
  static const String site = "https://naporoge-vuz-app.flutteria.dev";

  static const String baseUrl = "$site/api";
  static const String fileUrl = "$site/storage";

  // static const String baseUrl = "https://umadmin.naporoge.ru/api";

  // receiveTimeout
  static const Duration receiveTimeout = Duration(seconds: 60);

  // connectTimeout
  static const Duration connectionTimeout = Duration(seconds: 60);

  // User data
  static const String smsCode = '/code';
  static const String authCode = '/auth';
  static const String createStudent = '/create-student';

  // Stream data
  static const String createStream = '/create-stream';
  static const String deleteStream = '/delete-stream';
  static const String deactivateStream = '/deactivate-stream';
  static const String createNextStream = '/create-next-stream';
  static const String updateStream = '/update-stream';
  static const String expandStream = '/expand-stream';
  static const String createWeek = '/create-week';
  static const String updateWeek = '/update-week';
  static const String updateWeekProgress = '/update-week-progress';
  static const String createDayResult = '/create-day-result';
  static const String createDiaryNote = '/create-note';
  static const String updateDiaryNote = '/update-note';
  static const String deleteDiaryNote = '/delete-note';
  static const String allTheoryPosts = '/theories';

  //
  static const String deleteDuplicatesResult = '/delete-duplicates';
}
