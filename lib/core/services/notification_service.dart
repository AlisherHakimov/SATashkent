// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// import '../di/di_container.dart';
// import '../router/app_router.dart';
// import '../../firebase_options.dart';
//
// // ─── Background handler (top-level, required by FCM) ─────────────────────────
// @pragma('vm:entry-point')
// Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await NotificationService.showNotification(message);
// }
//
// // ─── Helper ───────────────────────────────────────────────────────────────────
// int _uuidToInt(String id) => id.hashCode.abs() % 2147483647;
//
// // ─── Service ──────────────────────────────────────────────────────────────────
// class NotificationService {
//   static final _messaging = FirebaseMessaging.instance;
//   static final _localNotifications = FlutterLocalNotificationsPlugin();
//
//   // ── Init ────────────────────────────────────────────────────────────────────
//   static Future<void> initialize() async {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//
//     final settings = await _messaging.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       criticalAlert: true,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       await _initLocalNotifications();
//       _listenToMessages();
//     } else {
//       log('[NotificationService] Permission denied');
//     }
//   }
//
//   // ── FCM Token ───────────────────────────────────────────────────────────────
//   static Future<String?> getFcmToken() async {
//     try {
//       final token = await _messaging.getToken();
//       log('[NotificationService] FCM token: $token');
//       return token;
//     } catch (e) {
//       log('[NotificationService] Failed to get FCM token: $e');
//       return null;
//     }
//   }
//
//   // ── Local notifications init ─────────────────────────────────────────────────
//   static Future<void> _initLocalNotifications() async {
//     const initSettings = InitializationSettings(
//       android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//       iOS: DarwinInitializationSettings(),
//     );
//
//     await _localNotifications.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: _onNotificationTap,
//       onDidReceiveBackgroundNotificationResponse: _onNotificationTap,
//     );
//
//     // Android 13+ permission
//     await _localNotifications
//         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestNotificationsPermission();
//   }
//
//   // ── Message listeners ────────────────────────────────────────────────────────
//   static void _listenToMessages() {
//     // Foreground
//     FirebaseMessaging.onMessage.listen(showNotification);
//
//     // Background → app opened via notification
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleNavigation);
//
//     // Terminated → app opened via notification
//     _messaging.getInitialMessage().then((message) {
//       if (message != null) _handleNavigation(message);
//     });
//   }
//
//   // ── Show notification ────────────────────────────────────────────────────────
//   static Future<void> showNotification(RemoteMessage message) async {
//     try {
//       const channelId = 'high_importance_channel';
//       const channelName = 'High Importance Notifications';
//
//       // Create Android channel (idempotent)
//       await _localNotifications
//           .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//           ?.createNotificationChannel(
//             const AndroidNotificationChannel(
//               channelId,
//               channelName,
//               description: 'Used for important notifications.',
//               importance: Importance.max,
//             ),
//           );
//
//       final id = _uuidToInt(
//         message.data['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
//       );
//
//       await _localNotifications.show(
//         id,
//         message.notification?.title ?? 'Notification',
//         message.notification?.body ?? 'You have a new notification',
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             channelId,
//             channelName,
//             channelDescription: 'Used for important notifications.',
//             importance: Importance.max,
//             priority: Priority.high,
//             playSound: true,
//             enableVibration: true,
//             icon: '@mipmap/ic_launcher',
//           ),
//           iOS: DarwinNotificationDetails(
//             presentAlert: true,
//             presentBadge: true,
//             presentSound: true,
//           ),
//         ),
//         payload: jsonEncode(message.data),
//       );
//     } catch (e, st) {
//       log('[NotificationService] Error showing notification: $e\n$st');
//     }
//   }
//
//   // ── Notification tap (local) ─────────────────────────────────────────────────
//   @pragma('vm:entry-point')
//   static void _onNotificationTap(NotificationResponse response) {
//     if (response.payload != null && response.payload!.isNotEmpty) {
//       WidgetsBinding.instance.addPostFrameCallback(
//         (_) => _navigateToNotifications(),
//       );
//     }
//   }
//
//   // ── FCM message tap (background/terminated) ──────────────────────────────────
//   static void _handleNavigation(RemoteMessage message) {
//     try {
//       WidgetsBinding.instance.addPostFrameCallback(
//         (_) => _navigateToNotifications(),
//       );
//     } catch (e) {
//       log('[NotificationService] Navigation error: $e');
//     }
//   }
//
//   // ── Navigate to notifications screen ────────────────────────────────────────
//   static void _navigateToNotifications() {
//     sl<AppRouter>().router.push(Routes.notifications);
//   }
//
//   // ── Cancel a notification ────────────────────────────────────────────────────
//   static Future<void> cancelNotification(String notificationId) async {
//     try {
//       await _localNotifications.cancel(_uuidToInt(notificationId));
//     } catch (e) {
//       log('[NotificationService] Error cancelling notification: $e');
//     }
//   }
// }
