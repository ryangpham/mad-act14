import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  FirebaseMessaging get messaging => FirebaseMessaging.instance;

  Future<NotificationSettings> initialize({
    required void Function(RemoteMessage) onData,
  }) async {
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      onData(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onData(message);
    });

    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      onData(initialMessage);
    }

    return settings;
  }

  Future<String?> getToken() {
    return messaging.getToken();
  }
}
