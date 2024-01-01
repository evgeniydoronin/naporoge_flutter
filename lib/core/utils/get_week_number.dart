int getWeekNumber(date) {
  int weeksBetween(DateTime from, DateTime to) {
    from = DateTime.utc(from.year, from.month, from.day);
    to = DateTime.utc(to.year, to.month, to.day);
    return (to.difference(from).inDays / 7).ceil();
  }

  final firstJan = DateTime(date.year, 1, 1);
  return weeksBetween(firstJan, date) == 0 ? 1 : weeksBetween(firstJan, date);
}
