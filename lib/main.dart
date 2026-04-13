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
  String statusText = 'Waiting for a cloud message';
  String imagePath = 'assets/images/tacobell.png';
  Color cardColor = Colors.blueGrey;
  String permissionText = 'Permission status: pending';
  String tokenText = 'FCM token: unavailable';

  @override
  void initState() {
    super.initState();
    _initializeFcm();
  }

  Future<void> _initializeFcm() async {
    try {
      final settings = await _fcmService.initialize(
        onData: (RemoteMessage message) {
          final notification = message.notification;
          final title = notification?.title ?? 'Payload received';
          final body = notification?.body;
          final assetName = message.data['asset'] ?? 'default';
          final colorName = message.data['color'] ?? 'blueGrey';

          if (!mounted) {
            return;
          }

          setState(() {
            statusText = body == null ? title : '$title\n$body';
            imagePath = _imagePathFromPayload(assetName);
            cardColor = _colorFromPayload(colorName);
          });

          debugPrint('FCM payload data: ${message.data}');
        },
      );

      final authorizationStatus = settings.authorizationStatus.name;
      debugPrint('FCM permission status: $authorizationStatus');

      final token = await _fcmService.getToken();
      debugPrint('FCM token: $token');

      if (!mounted) {
        return;
      }

      setState(() {
        permissionText = 'Permission status: $authorizationStatus';
        tokenText = token == null
            ? 'FCM token: unavailable'
            : 'FCM token: $token';
      });
    } catch (error) {
      debugPrint('FCM initialization skipped: $error');

      if (!mounted) {
        return;
      }

      setState(() {
        permissionText = 'Permission status: error';
        tokenText = 'FCM token: unavailable';
      });
    }
  }

  Color _colorFromPayload(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.blueGrey;
    }
  }

  String _imagePathFromPayload(String assetName) {
    switch (assetName.toLowerCase()) {
      case 'alert':
        return 'assets/images/alert.png';
      case 'gordita':
      case 'promo':
        return 'assets/images/gordita.png';
      case 'default':
      case 'tacobell':
      default:
        return 'assets/images/tacobell.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Setup')),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cardColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.image_not_supported,
                      size: 72,
                      color: cardColor,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(statusText, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                imagePath,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                permissionText,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                tokenText,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
