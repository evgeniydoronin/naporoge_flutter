class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "https://np-app.evgeniydoronin.com/api";

  // receiveTimeout
  static const Duration receiveTimeout = Duration(seconds: 3);

  // connectTimeout
  static const Duration connectionTimeout = Duration(seconds: 5);

  // User data
  static const String smsCode = '/code';
  static const String authCode = '/auth';
  static const String createStudent = '/create-student';

  // Stream data
  static const String createStream = '/create-stream';
  static const String updateStream = '/update-stream';
  static const String createWeek = '/create-week';
  static const String updateWeek = '/update-week';
  static const String updateWeekProgress = '/update-week-progress';
  static const String createDayResult = '/create-day-result';
}
