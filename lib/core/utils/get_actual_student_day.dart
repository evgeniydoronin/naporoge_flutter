import 'package:intl/intl.dart';

DateTime getActualStudentDay() {
  DateTime now = DateTime.now();
  DateTime? actualUserDay;

  DateTime midnight = DateTime.parse(DateFormat('y-MM-dd').format(now));
  DateTime threeOClock = DateTime(now.year, now.month, now.day, 2, 59, 59);

  // возвращаем предыдущий день
  // если текущее время с 00:00 до 2:59:59
  if (now.isAfter(midnight) && now.isBefore(threeOClock)) {
    DateTime _actualUserDay = now.subtract(const Duration(days: 1));
    actualUserDay = DateTime(_actualUserDay.year, _actualUserDay.month, _actualUserDay.day);
  }
  // возвращаем текущий день
  else {
    actualUserDay = DateTime(now.year, now.month, now.day);
  }

  return actualUserDay;
}
