import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../commanScreen/allAPIList.dart';
import '../commanScreen/routes.dart';
import '../firebase_options.dart';
import '../sharedPrefancePage/ShardPre.dart';
import 'mobile_http_client.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  debugPrint('[PUSH] background message -> ${message.messageId}');
}

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const String _channelId = 'employroll_push';
  static const String _channelName = 'EmployRoll Notifications';
  static const String _pendingPayloadKey = 'pendingPushPayload';

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final SessionManager _sessionManager = SessionManager();

  FirebaseMessaging get _messaging => FirebaseMessaging.instance;

  GlobalKey<NavigatorState>? _navigatorKey;
  bool _initialized = false;

  Future<void> initialize({
    required GlobalKey<NavigatorState> navigatorKey,
  }) async {
    if (_initialized) return;
    _navigatorKey = navigatorKey;

    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await _initializeLocalNotifications();
    await requestPermission();
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_showForegroundNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleRemoteMessageTap);
    _messaging.onTokenRefresh.listen((token) async {
      debugPrint('[PUSH] token refreshed');
      await _sessionManager.setFirebaseTokenId(token);
      await registerCurrentToken(force: true);
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleRemoteMessageTap(initialMessage);
      });
    }

    _initialized = true;
    debugPrint('[PUSH] initialized');
  }

  Future<void> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    debugPrint('[PUSH] permission -> ${settings.authorizationStatus}');

    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }
  }

  Future<void> registerCurrentToken({bool force = false}) async {
    try {
      final auth = await _readAuth();
      if (!auth.hasAuth) {
        debugPrint('[PUSH] register skipped, auth missing');
        return;
      }

      final token = await _messaging.getToken();
      if (token == null || token.isEmpty) {
        debugPrint('[PUSH] register skipped, token missing');
        return;
      }

      final savedToken = await _sessionManager.getfirebaseTokenId();
      if (!force && savedToken == token) {
        debugPrint('[PUSH] register skipped, token unchanged');
        return;
      }

      final payload = await _tokenPayload(token, active: true);
      final registered = await _sendTokenToMobileBackend(auth, payload);
      if (registered || await _sendTokenToLegacyBackend(auth, token)) {
        await _sessionManager.setFirebaseTokenId(token);
        debugPrint('[PUSH] token registered');
      } else {
        debugPrint('[PUSH] token registration failed');
      }
    } catch (error) {
      debugPrint('[PUSH] register error -> $error');
    }
  }

  Future<void> deactivateCurrentToken() async {
    final auth = await _readAuth();
    final token = await _sessionManager.getfirebaseTokenId();
    if (!auth.hasAuth || token == null || token.isEmpty) {
      return;
    }

    final payload = await _tokenPayload(token, active: false);
    final deactivated = await _sendTokenDeactivateToMobileBackend(
      auth,
      payload,
    );
    if (!deactivated) {
      await _sendTokenToLegacyBackend(auth, '');
    }
    debugPrint('[PUSH] token deactivate requested');
  }

  Future<void> processPendingNotification() async {
    final prefsPayload = await _readPendingPayload();
    if (prefsPayload == null) return;

    final auth = await _readAuth();
    if (!auth.hasAuth) return;

    await _clearPendingPayload();
    await _navigateFromPayload(prefsPayload);
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload == null || payload.isEmpty) return;
        final decoded = json.decode(payload);
        if (decoded is Map<String, dynamic>) {
          _handlePayloadTap(decoded);
        }
      },
    );

    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'Employee and manager workflow notifications',
      importance: Importance.high,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    final title = notification?.title ?? message.data['title']?.toString();
    final body = notification?.body ?? message.data['body']?.toString();
    if ((title == null || title.isEmpty) && (body == null || body.isEmpty)) {
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: 'Employee and manager workflow notifications',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      title,
      body,
      details,
      payload: json.encode(message.data),
    );
  }

  Future<void> _handleRemoteMessageTap(RemoteMessage message) async {
    await _handlePayloadTap(Map<String, dynamic>.from(message.data));
  }

  Future<void> _handlePayloadTap(Map<String, dynamic> payload) async {
    final auth = await _readAuth();
    if (!auth.hasAuth) {
      await _storePendingPayload(payload);
      _navigatorKey?.currentState?.pushNamedAndRemoveUntil(
        MyRoutings.loginRoute,
        (route) => false,
      );
      return;
    }

    await _navigateFromPayload(payload);
  }

  Future<void> _navigateFromPayload(Map<String, dynamic> payload) async {
    final navigator = _navigatorKey?.currentState;
    if (navigator == null) {
      await _storePendingPayload(payload);
      return;
    }

    final activePanel = (await _sessionManager.getActivePanel() ?? '').toUpperCase();
    final route = _routeForPayload(payload, activePanel: activePanel);
    debugPrint('[PUSH] navigate -> $route payload=$payload');
    navigator.pushNamed(route);
  }

  String _routeForPayload(
    Map<String, dynamic> payload, {
    required String activePanel,
  }) {
    final directRoute = payload['route']?.toString();
    if (directRoute != null && directRoute.trim().isNotEmpty) {
      return directRoute;
    }

    final module =
        (payload['module'] ?? payload['type'] ?? '').toString().toUpperCase();
    final action = (payload['action'] ?? '').toString().toUpperCase();
    final panel = (payload['panel'] ?? '').toString().toUpperCase();
    final managerPayload = _isManagerPayload(panel, action);
    final isMo = activePanel == 'MSS_MO';

    if (panel == 'ESS' &&
        (action.contains('APPROVED') ||
            action.contains('DISAPPROVED') ||
            action.contains('REJECTED') ||
            action.contains('DECISION'))) {
      return MyRoutings.myAllRequestRoute;
    }

    if (module.contains('ATTENDANCE') && managerPayload) {
      return isMo
          ? MyRoutings.mssMoAttPendingRequestRoRoute
          : MyRoutings.mssAttPendingRequestRoRoute;
    }
    if (module.contains('LEAVE') && managerPayload) {
      return isMo
          ? MyRoutings.mssMoPendingLeaveRequestRoute
          : MyRoutings.mssPendingLeaveRequestRoute;
    }
    if (module == 'OD' && managerPayload) {
      return isMo
          ? MyRoutings.mssMoPendingOdRequisitionRoute
          : MyRoutings.mssPendingOdRequisitionRoute;
    }
    if (module == 'WFH' && managerPayload) {
      return MyRoutings.mssWfhApprovalRoute;
    }
    if (module == 'COMP_OFF' && managerPayload) {
      return MyRoutings.mssCompOffApprovalRoute;
    }
    if (module.contains('CLAIM')) return MyRoutings.mssClaimItemRoute;
    if (module.contains('LOAN') && _isManagerPayload(panel, action)) {
      return MyRoutings.pendingLoanRequestListRoute;
    }
    if (module.contains('SALARY') || module.contains('PAYSLIP')) {
      return MyRoutings.myAllReportsRoute;
    }
    if (module.contains('DOCUMENT')) return MyRoutings.documentsAddedRoute;
    if (module.contains('EXIT') && _isManagerPayload(panel, action)) {
      return MyRoutings.mssExitRoute;
    }
    if (module.contains('INDUCTION') && _isManagerPayload(panel, action)) {
      return MyRoutings.mssInductionRoute;
    }

    return MyRoutings.homePageRoute;
  }

  bool _isManagerPayload(String panel, String action) {
    return panel.contains('MSS') || action.contains('APPROVAL');
  }

  Future<bool> _sendTokenToMobileBackend(
    _NotificationAuth auth,
    Map<String, dynamic> payload,
  ) async {
    final uri = Uri.parse('${ApiDetails.server}${ApiDetails.mobilePushToken}');
    try {
      final response = await MobileHttpClient.instance.post(
        uri,
        headers: _headers(auth),
        body: json.encode(payload),
      );
      return _isSuccess(response);
    } catch (error) {
      debugPrint('[PUSH] mobile token endpoint error -> $error');
      return false;
    }
  }

  Future<bool> _sendTokenDeactivateToMobileBackend(
    _NotificationAuth auth,
    Map<String, dynamic> payload,
  ) async {
    final uri = Uri.parse(
      '${ApiDetails.server}${ApiDetails.mobilePushTokenDeactivate}',
    );
    try {
      final response = await MobileHttpClient.instance.post(
        uri,
        headers: _headers(auth),
        body: json.encode(payload),
      );
      return _isSuccess(response);
    } catch (error) {
      debugPrint('[PUSH] mobile token deactivate error -> $error');
      return false;
    }
  }

  Future<bool> _sendTokenToLegacyBackend(
    _NotificationAuth auth,
    String token,
  ) async {
    final legacyPath =
        ApiDetails.firebaseApiSend.startsWith('/')
            ? ApiDetails.firebaseApiSend
            : '/${ApiDetails.firebaseApiSend}';
    final uri = Uri.parse('${ApiDetails.server}$legacyPath').replace(
      queryParameters: <String, String>{
        'sessionId': auth.sessionId!,
        'firebaseId': token,
      },
    );

    try {
      final response = await MobileHttpClient.instance.post(uri);
      return _isSuccess(response);
    } catch (error) {
      debugPrint('[PUSH] legacy token endpoint error -> $error');
      return false;
    }
  }

  Future<Map<String, dynamic>> _tokenPayload(
    String token, {
    required bool active,
  }) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final deviceId = await _deviceId();
    return <String, dynamic>{
      'firebaseToken': token,
      'platform': Platform.isIOS ? 'IOS' : 'ANDROID',
      'active': active,
      'appVersion': '${packageInfo.version}+${packageInfo.buildNumber}',
      'deviceId': deviceId,
      'orgId': await _sessionManager.getOrgId(),
      'employeeDetailsId': await _sessionManager.getEmployeeDetailsId(),
      'employeeId': await _sessionManager.getEmployeeId(),
      'activePanel': await _sessionManager.getActivePanel(),
    };
  }

  Future<String> _deviceId() async {
    final plugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final info = await plugin.androidInfo;
      return info.id;
    }
    if (Platform.isIOS) {
      final info = await plugin.iosInfo;
      return info.identifierForVendor ?? info.utsname.machine;
    }
    return Platform.localHostname;
  }

  Future<_NotificationAuth> _readAuth() async {
    return _NotificationAuth(
      accessToken: await _sessionManager.getAccessToken(),
      tokenType: await _sessionManager.getTokenType() ?? 'Bearer',
      sessionId: await _sessionManager.getMobileSessionId(),
    );
  }

  Map<String, String> _headers(_NotificationAuth auth) {
    return <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': '${auth.tokenType} ${auth.accessToken!}',
      'X-Mobile-Session-Id': auth.sessionId!,
    };
  }

  bool _isSuccess(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      return false;
    }
    if (response.body.trim().isEmpty) return true;
    try {
      final decoded = json.decode(response.body);
      if (decoded is! Map<String, dynamic>) return true;
      final status = (decoded['status'] ?? decoded['result'] ?? '').toString();
      if (status.isEmpty) return true;
      return status.toUpperCase() == 'SUCCESS' ||
          status.toLowerCase() == 'success';
    } catch (_) {
      return true;
    }
  }

  Future<void> _storePendingPayload(Map<String, dynamic> payload) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pendingPayloadKey, json.encode(payload));
  }

  Future<Map<String, dynamic>?> _readPendingPayload() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_pendingPayloadKey);
    if (value == null || value.isEmpty) return null;
    final decoded = json.decode(value);
    return decoded is Map<String, dynamic> ? decoded : null;
  }

  Future<void> _clearPendingPayload() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pendingPayloadKey);
  }
}

class _NotificationAuth {
  final String? accessToken;
  final String tokenType;
  final String? sessionId;

  const _NotificationAuth({
    required this.accessToken,
    required this.tokenType,
    required this.sessionId,
  });

  bool get hasAuth =>
      (accessToken ?? '').isNotEmpty && (sessionId ?? '').isNotEmpty;
}
