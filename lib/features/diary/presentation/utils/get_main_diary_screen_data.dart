Future getMainDiaryData(date) async {
  Map data = {};

  // данные для календаря за выбранный месяц
  Map calendarData = await getDiaryCalendarData(date);
  data['calendarData'] = calendarData;

  // данные для учета результатов
  Map dayResultsData = await getDiaryDayResultsData(date);
  data['dayResultsData'] = dayResultsData;

  // данные для последней заметки + ссылка на все заметки за выбранный день
  Map noteData = await getNoteData(date);
  data['noteData'] = noteData;

  return data;
}

Future getDiaryCalendarData(date) async {
  await Future.delayed(const Duration(seconds: 1));
  Map data = {};
  data['test'] = 'qwqw';
  print('getDiaryCalendarData');
  return data;
}

Future getDiaryDayResultsData(date) async {
  // await Future.delayed(const Duration(seconds: 2));
  Map data = {};
  data['test'] = 'qwqw';
  print('getDiaryDayResultsData');
  return data;
}

Future getNoteData(date) async {
  // await Future.delayed(const Duration(seconds: 2));
  Map data = {};
  data['test'] = 'qwqw';
  print('getNoteData');
  return data;
}
