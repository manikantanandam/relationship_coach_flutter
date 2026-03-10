import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> setupNotifications() async {
    // 1. Request Permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    // 2. Set Foreground Presentation Options
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 3. Handle Token Logic Safely
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await _fetchTokenWithRetry();
    }
  }

  Future<void> _fetchTokenWithRetry() async {
    try {
      if (Platform.isIOS) {
        // Essential: Wait for APNs token before asking for FCM token
        String? apnsToken = await _messaging.getAPNSToken();

        // If APNs isn't ready yet, wait a moment and try one more time
        if (apnsToken == null) {
          await Future.delayed(const Duration(seconds: 2));
          apnsToken = await _messaging.getAPNSToken();
        }

        if (apnsToken == null) {
          print("⚠️ APNs token still null. FCM token fetch might fail.");
          return;
        }
      }

      String? fcmToken = await _messaging.getToken();
      print("🔥 FCM Registration Token: $fcmToken");
    } catch (e) {
      print("❌ Error fetching FCM token: $e");
    }
  }
}
