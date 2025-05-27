import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gnb_flutter_task/firebase_options.dart';
import 'package:gnb_flutter_task/utils/firebase_utils.dart';
import 'package:gnb_flutter_task/views/home_view.dart';
import 'package:gnb_flutter_task/views/notification_service.dart';

import 'bloc/property_bloc.dart';
import 'views/property_listing_view.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.init();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
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
