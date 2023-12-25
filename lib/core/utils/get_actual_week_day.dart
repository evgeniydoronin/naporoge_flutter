/// FIRST DAY OF THE WEEK
DateTime findFirstDateOfTheWeek(DateTime dateTime) {
  DateTime _zero = DateTime(
    DateTime.now().year,
  );
  return dateTime.subtract(Duration(days: dateTime.weekday - 1));
}

/// LAST DAY OF THE WEEK
DateTime findLastDateOfTheWeek(DateTime dateTime) {
  return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
}

/// LAST DAY OF THE MONTH
DateTime findLastDateOfTheMonth(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month + 1, 0);
}

/// FIRST DAY OF THE MONTH
DateTime findFirstDateOfTheMonth(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, 1);
}

/// LAST DAY OF THE YEAR
DateTime findLastDateOfTheYear(DateTime dateTime) {
  return DateTime(dateTime.year, 12, 31);
}

/// FIRST DAY OF THE YEAR
DateTime findFirstDateOfTheYear(DateTime dateTime) {
  return DateTime(dateTime.year, 1, 1);
}
