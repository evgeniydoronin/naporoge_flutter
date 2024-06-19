import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../firebase_options.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  factory NotificationService() => _instance;

  NotificationService._internal() {
    _init();
  }

  Future<void> _init() async {
    await Firebase.initializeApp();
    await _initFirebaseMessaging();
    await _initLocalNotifications();
  }

  Future<void> _initFirebaseMessaging() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
  }

  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher_round_notifs');
    const iOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(android: android, iOS: iOS);
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
    );
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    await _showNotification(message);
  }

  Future<void> _handleMessageOpenedApp(RemoteMessage message) async {
    print("Message clicked!");
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'group_channel_id',
      'Group Notifications',
      channelDescription: 'Notifications for group updates',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      groupKey: 'your_group_key',
      icon: '@mipmap/ic_launcher_round_notifs',
      setAsGroupSummary: true,
      styleInformation: null,
    );
    const iOSDetails = DarwinNotificationDetails(
      sound: "default",
      badgeNumber: 1,
    );
    const details = NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000), // Уникальный ID для каждого уведомления
      message.notification?.title ?? 'Воля',
      message.notification?.body ?? '...',
      details,
    );
  }

  Future<String?> getToken() async {
    final fCMToken = await _messaging.getToken();
    print('FCM Token: $fCMToken');
    return fCMToken;
  }

  static Future<void> _firebaseBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    print("Handling a background message: ${message.messageId}");

    // После инициализации Firebase создаём новый экземпляр сервиса уведомлений
    final service = NotificationService();
    await service._showNotification(message);
  }
}

void onDidReceiveNotificationResponse(NotificationResponse response) {
  print("Notification clicked with payload: ${response.payload}");
}

void onDidReceiveBackgroundNotificationResponse(NotificationResponse response) {
  print("Background notification clicked with payload: ${response.payload}");
}

// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
//
//   factory NotificationService() {
//     return _instance;
//   }
//
//   NotificationService._internal();
//
//   Future<void> init() async {
//     await _initFirebaseMessaging();
//     await _initLocalNotifications();
//   }
//
//   Future<void> _initFirebaseMessaging() async {
//     await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       _showNotification(message);
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("Message clicked!");
//     });
//   }
//
//   Future<void> _initLocalNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_group_notification');
//     final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//       onDidReceiveLocalNotification: onDidReceiveLocalNotification,
//     );
//     final InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsDarwin, // Используйте iOS как алиас для Darwin
//     );
//     await _localNotifications.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
//       onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
//     );
//   }
//
//   Future _showNotification(RemoteMessage message) async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       /// Group push icon
//       'group_channel_id', // ID канала для групповых уведомлений
//       'group_channel_name', // Имя канала
//       channelDescription: 'Description for group notifications',
//       // Описание канала
//       groupKey: 'your_group_key',
//       // Ключ группы
//       setAsGroupSummary: true,
//       // Это уведомление будет суммарным для группы
//       icon: '@mipmap/ic_group_notification',
//       // Иконка для групповых уведомлений
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: false,
//
//       /// Unique push icon ,
//       // 'your_channel_id',
//       // 'your_channel_name',
//       // channelDescription: 'your_channel_description',
//       // importance: Importance.max,
//       // priority: Priority.high,
//       // showWhen: false,
//     );
//     const DarwinNotificationDetails darwinDetails = DarwinNotificationDetails(
//       sound: "default",
//       badgeNumber: 1,
//     );
//     const NotificationDetails platformDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: darwinDetails, // Используйте iOS как алиас для Darwin
//     );
//
//     // Генерация уникального ID для уведомления
//     int notificationId = DateTime.now().millisecondsSinceEpoch.remainder(100000);
//
//     await _localNotifications.show(
//         notificationId, // Уникальный ID для каждого уведомления
//         message.notification?.title, // Notification title
//         message.notification?.body, // Notification body
//         platformDetails,
//         payload: 'item x');
//   }
//
//   static Future<void> _firebaseBackgroundMessage(RemoteMessage message) async {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//
//     print("Handling a background data: ${message.data}");
//     print("Handling a background notification: ${message.notification}");
//     print("Handling a background from: ${message.from}");
//     print("Handling a background message: ${message.messageId}");
//     // Так как это статический метод, создайте новый экземпляр сервиса для показа уведомления
//     final service = NotificationService();
//     await service._showNotification(message);
//   }
//
//   void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
//     // Handle notification tapped logic here
//   }
//
//   Future onSelectNotification(String? payload) async {
//     // Handle notification tapped logic here
//     print("Handle notification tapped logic here: ${payload}");
//   }
//
//   Future<String?> getToken() async {
//     final fCMToken = await _messaging.getToken();
//     print('Token: ${fCMToken.toString()}');
//     return fCMToken;
//   }
// }
//
// void onDidReceiveNotificationResponse(NotificationResponse response) {
//   // Ваш код для обработки нажатия на уведомление в активном состоянии приложения
//   print("Notification clicked with payload: ${response.payload}");
// }
//
// void onDidReceiveBackgroundNotificationResponse(NotificationResponse response) {
//   // Ваш код для обработки нажатия на уведомление в фоновом состоянии
//   print("Notification clicked in background with payload: ${response.payload}");
// }
