import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:isar/isar.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../features/planning/domain/entities/stream_entity.dart';
import '../services/db_client/isar_service.dart';

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future init() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) {},
      notificationCategories: [
        DarwinNotificationCategory(
          'demoCategory',
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain('id_1', 'Action 1'),
            DarwinNotificationAction.plain(
              'id_2',
              'Action 2',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.destructive,
              },
            ),
            DarwinNotificationAction.plain(
              'id_3',
              'Action 3',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
              },
            ),
          ],
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
          },
        )
      ],
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsDarwin);
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) {});
  }

  notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        priority: Priority.high,
        importance: Importance.max,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future showNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduledNotificationDateTime}) async {
    return _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledNotificationDateTime, tz.local),
      await notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}

Future getPushNotify() async {
  final isarService = IsarService();
  final isar = await isarService.db;
  final NPStream? activeStream = await isar.nPStreams.filter().isActiveEqualTo(true).findFirst();

  if (activeStream != null) {
    // (новый) “Курс начался, желаем успехов!” (Пн в 18:45 первой недели - при запуске КАЖДОГО ДЕЛА)
    // Вт 5:00 утра Недели 1 “Старайтесь отмечать результаты как можно точнее”
    // (!возможно новый) Если человек создал дело, но план первой недели пустой (т.е. он вышел с Планирования), то дать пуш “Завершите настройку Дела и подтвердите план кнопкой “План мне подходит”. (в ШК моби такое дается через 24ч от момента создания дела +данный пуш “отключается”, если План все же был сохранен).
    // Сб 9:00 недели 1 (Первое прохождение) “Появилось 2 новых видео! Что делать, когда не хочу делать дело? Почему откладываются дела?”
    // Сб 9:00  недели 2 (Первое прохождение) “Появилось новое видео: Верное завершение дел” (текст в пушах без кавычек)

    DateTime startStream = activeStream.startAt!;
    DateTime now = DateTime.now();

    DateTime notifyTest = DateTime(now.year, now.month, now.day, now.hour, now.add(const Duration(minutes: 1)).minute);

    DateTime notifyStartStream = DateTime(startStream.year, startStream.month, startStream.day, 18, 45);
    DateTime notifyMorningTuesday =
        DateTime(startStream.year, startStream.month, startStream.add(const Duration(days: 1)).day, 5, 0);
    DateTime notifyMorningFirstWeek =
        DateTime(startStream.year, startStream.month, startStream.add(const Duration(days: 6)).day, 9, 0);
    DateTime notifyMorningSecondWeek =
        DateTime(startStream.year, startStream.month, startStream.add(const Duration(days: 12)).day, 9, 0);

    // print('notifyTest: $notifyTest');
    //
    // /// notifyTest
    // if (now.isBefore(notifyTest.add(const Duration(seconds: 1)))) {
    //   LocalNotifications().showNotification(
    //     id: 10,
    //     title: 'Воля',
    //     body: 'Курс начался, желаем успехов!',
    //     scheduledNotificationDateTime: tz.TZDateTime(
    //       tz.local,
    //       notifyTest.year,
    //       notifyTest.month,
    //       notifyTest.day,
    //       notifyTest.hour,
    //       notifyTest.minute,
    //     ),
    //   );
    // }

    /// notifyStartStream
    if (now.isBefore(notifyStartStream.add(const Duration(seconds: 1)))) {
      LocalNotifications().showNotification(
        id: 1,
        title: 'Воля',
        body: 'Курс начался, желаем успехов!',
        scheduledNotificationDateTime: tz.TZDateTime(
          tz.local,
          notifyStartStream.year,
          notifyStartStream.month,
          notifyStartStream.day,
          notifyStartStream.hour,
          notifyStartStream.minute,
        ),
      );
    }

    /// notifyMorningTuesday
    if (now.isBefore(notifyMorningTuesday.add(const Duration(seconds: 1)))) {
      LocalNotifications().showNotification(
        id: 2,
        title: 'Воля',
        body: 'Старайтесь отмечать результаты как можно точнее',
        scheduledNotificationDateTime: tz.TZDateTime(
          tz.local,
          notifyMorningTuesday.year,
          notifyMorningTuesday.month,
          notifyMorningTuesday.day,
          notifyMorningTuesday.hour,
          notifyMorningTuesday.minute,
        ),
      );
    }

    /// notifyMorningFirstWeek
    if (now.isBefore(notifyMorningFirstWeek.add(const Duration(seconds: 1)))) {
      LocalNotifications().showNotification(
        id: 3,
        title: 'Воля',
        body: 'Появилось 2 новых видео! Что делать, когда не хочу делать дело? Почему откладываются дела?',
        scheduledNotificationDateTime: tz.TZDateTime(
          tz.local,
          notifyMorningFirstWeek.year,
          notifyMorningFirstWeek.month,
          notifyMorningFirstWeek.day,
          notifyMorningFirstWeek.hour,
          notifyMorningFirstWeek.minute,
        ),
      );
    }

    /// notifyMorningFirstWeek
    if (now.isBefore(notifyMorningSecondWeek.add(const Duration(seconds: 1)))) {
      LocalNotifications().showNotification(
        id: 4,
        title: 'Воля',
        body: 'Появилось новое видео: Верное завершение дел',
        scheduledNotificationDateTime: tz.TZDateTime(
          tz.local,
          notifyMorningSecondWeek.year,
          notifyMorningSecondWeek.month,
          notifyMorningSecondWeek.day,
          notifyMorningSecondWeek.hour,
          notifyMorningSecondWeek.minute,
        ),
      );
    }
  }
}
