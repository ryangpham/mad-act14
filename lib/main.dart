import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'fcm_service.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('Background message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'act14', home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FCMService _fcmService = FCMService();
  String _status = 'Firebase initialized for Android and Web.';

  @override
  void initState() {
    super.initState();
    _initializeFcm();
  }

  Future<void> _initializeFcm() async {
    try {
      await _fcmService.initialize(
        onData: (RemoteMessage message) {
          final notification = message.notification;
          final title = notification?.title ?? 'Notification received';
          final body = notification?.body;

          if (!mounted) {
            return;
          }

          setState(() {
            _status = body == null ? title : '$title\n$body';
          });
        },
      );

      final token = await _fcmService.getToken();
      debugPrint('FCM token: $token');
    } catch (error) {
      debugPrint('FCM initialization skipped: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Setup')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(_status, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
