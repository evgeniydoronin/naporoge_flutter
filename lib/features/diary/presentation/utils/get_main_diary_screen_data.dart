Future getMainDiaryData(date) async {
  await Future.delayed(const Duration(milliseconds: 200));
  Map data = {};

  // данные для учета результатов
  Map dayResultsData = await getDiaryDayResultsData(date);
  data['dayResultsData'] = dayResultsData;

  // данные для последней заметки + ссылка на все заметки за выбранный день
  Map noteData = await getNoteData(date);
  data['noteData'] = noteData;

  return data;
}

Future getDiaryDayResultsData(date) async {
  // await Future.delayed(const Duration(seconds: 2));
  Map data = {};
  data['date'] = date;
  print('getDiaryDayResultsData: $date');
  return data;
}

Future getNoteData(date) async {
  Map data = {};
  data['date'] = date;
  print('getNoteData: $date');

  return data;
}
