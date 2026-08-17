import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}
class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final FCMToken = await _firebaseMessaging.getToken();
    print('Token- $FCMToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}*/

class NotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  // Keys for shared preferences
  static const String _fcmTokenKey = "fcm_token";

  initFCM() async {
    await _firebaseMessaging.requestPermission();
    final FCMToken = await _firebaseMessaging.getToken();

    // Save token to SharedPreferences
    if (FCMToken != null) {
      await _saveToken(FCMToken);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    });

/*    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('Payload: ${message.data}');
    });*/


  }
  /// Save token into SharedPreferences
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fcmTokenKey, token);
  }

  /// Retrieve token from SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fcmTokenKey);
  }
}