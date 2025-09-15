// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class PushService {
//   final _fm = FirebaseMessaging.instance;
//   final _local = FlutterLocalNotificationsPlugin();

//   Future<void> init() async {
//     await _fm.requestPermission();
//     // Android local notification channel
//     const channel = AndroidNotificationChannel(
//       'high_importance_channel',
//       'High Importance',
//       importance: Importance.high,
//     );
//     await _local
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(channel);

//     FirebaseMessaging.onMessage.listen((message) {
//       // show local notification, or update UI
//     });

//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }
// }

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // handle messages when app is in background
// }
