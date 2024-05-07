class Endpoints {
  Endpoints._();

  /// DEV
  static const String host = 'https://naporoge-vuz-app.flutteria.dev';

  // PROD
  // static const String host = 'https://umadmin.naporoge.ru';

  static const String baseUrl = "$host/api";
  static const String fileUrl = "$host/storage";

  // static const String baseUrl = "https://umadmin.naporoge.ru/api";

  // receiveTimeout
  static const Duration receiveTimeout = Duration(seconds: 60);

  // connectTimeout
  static const Duration connectionTimeout = Duration(seconds: 60);

  // User
  static const String smsCode = '/code';
  static const String authCode = '/auth';
  static const String createStudent = '/create-student';
  static const String getStudent = '/get-student';
  static const String updateToken = '/update-token';

  /// Stream
  static const String createStream = '/create-stream';
  static const String deleteStream = '/delete-stream';
  static const String deactivateStream = '/deactivate-stream';
  static const String createNextStream = '/create-next-stream';
  static const String updateStream = '/update-stream';
  static const String expandStream = '/expand-stream';
  static const String createWeek = '/create-week';
  static const String updateWeek = '/update-week';
  static const String updateWeekProgress = '/update-week-progress';
  static const String createTwoTargets = '/create-two-targets';
  static const String updateTwoTargets = '/update-two-targets';
  static const String createDayResult = '/create-day-result';
  static const String createDiaryNote = '/create-note';
  static const String updateDiaryNote = '/update-note';
  static const String deleteDiaryNote = '/delete-note';
  static const String allTheoryPosts = '/theories';

  /// Todo
  static const String createTodo = '/todos';
  static const String updateTodo = '/update-todo';
  static const String deleteTodo = '/delete-todo';
  static const String getTodos = '/get-todos';

  /// get streams data
  static const String getStreams = '/get-streams';
  static const String getWeeks = '/get-weeks';
  static const String getDays = '/get-days';
  static const String getDaysResults = '/get-days-results';
  static const String getDiaryNotes = '/get-diary-notes';
  static const String getTwoTargets = '/get-two-targets';
  static const String getPushNotifications = '/get-push-notifications';

  //
  static const String deleteDuplicatesResult = '/delete-duplicates';
}
