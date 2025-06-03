import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:gnb_flutter_task/main.dart';
import 'package:gnb_flutter_task/views/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> storeFcmToken(String fcmToken) async {
  final prefs = await SharedPreferences.getInstance();
  final key = kIsWeb ? 'web_fcm_Token' : 'fcm_Token';
  await prefs.setString(key, fcmToken);
  debugPrint("FCM Token stored under key $key: $fcmToken");
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final notification = message.notification;
  if (notification != null) {
    NotificationService.showNotification(
      title: notification.title ?? 'No Title',
      body: notification.body ?? 'No Body',
      payload: '/properties',
    );
  }
  debugPrint("Handling a background message: ${message.messageId}");
}

Future<void> setupFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();

  String? token = await messaging.getToken();
  if (token != null) {
    await storeFcmToken(token);
  }
  debugPrint("FCM Token: $token");

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      NotificationService.showNotification(
        title: notification.title ?? 'No Title',
        body: notification.body ?? 'No Body',
        payload: '/properties',
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    debugPrint('Notification clicked');
    await navigatorKey.currentState?.pushNamed('/properties');
  });
}
