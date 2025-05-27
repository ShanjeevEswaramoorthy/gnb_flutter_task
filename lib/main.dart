import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gnb_flutter_task/firebase_options.dart';
import 'package:gnb_flutter_task/views/home_view.dart';
import 'package:gnb_flutter_task/views/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/property_bloc.dart';
import 'views/property_listing_view.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (context) => PropertyBloc())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    setupFirebaseMessaging();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GNB Flutter Task',
      navigatorKey: navigatorKey,
      routes: {
        '/': (context) => HomeScreen(),
        '/properties': (context) => const PropertyListingView(),
      },
      initialRoute: '/',
    );
  }
}

Future<void> storeFcmToken(String fcmToken) async {
  final prefs = await SharedPreferences.getInstance();
  final key = kIsWeb ? 'web_fcm_Token' : 'fcm_Token';
  await prefs.setString(key, fcmToken);
  debugPrint("FCM Token stored under key $key: $fcmToken");
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

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint('Notification clicked');
    navigatorKey.currentState?.pushNamed('/properties');
  });
}
