import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../commanScreen/allAPIList.dart';
import '../sharedPrefancePage/ShardPre.dart';
import 'mobile_http_client.dart';

class MobileAuthService {
  MobileAuthService._();

  static final MobileAuthService instance = MobileAuthService._();
  static final SessionManager _sessionManager = SessionManager();
  bool _syncRunning = false;

  Future<void> syncAfterLogin({
    required String? accessToken,
    required String? sessionId,
    String? tokenType,
  }) async {
    if (_syncRunning) {
      print('[MOBILE-AUTH] syncAfterLogin -> skipped, sync already running');
      return;
    }
    _syncRunning = true;
    try {
      print('[MOBILE-AUTH] syncAfterLogin -> start');
      final auth = MobileAuthData(
        accessToken: accessToken,
        sessionId: sessionId,
        tokenType: tokenType ?? 'Bearer',
      );
      await _callBootstrapVersion(auth: auth, forceBootstrap: true);
      await sendMobileDeviceInfo(auth: auth);
      print('[MOBILE-AUTH] syncAfterLogin -> end');
    } finally {
      _syncRunning = false;
    }
  }

  Future<void> syncOnAppOpen({bool forceBootstrap = false}) async {
    if (_syncRunning) {
      print('[MOBILE-AUTH] syncOnAppOpen -> skipped, sync already running');
      return;
    }
    _syncRunning = true;
    try {
      print('[MOBILE-AUTH] syncOnAppOpen -> start');
      final auth = await _readAuthFromPrefs();
      if (!auth.hasAuth) {
        print('[MOBILE-AUTH] syncOnAppOpen -> skipped, token/session missing');
        return;
      }

      final sessionValid = await validateSession(auth: auth);
      if (!sessionValid) {
        final refreshed = await refreshToken(auth: auth);
        if (!refreshed) {
          print(
            '[MOBILE-AUTH] syncOnAppOpen -> refresh failed, login required',
          );
          return;
        }
      }

      final latestAuth = await _readAuthFromPrefs();
      await _callBootstrapVersion(
        auth: latestAuth,
        forceBootstrap: forceBootstrap,
      );
      await sendMobileDeviceInfo(auth: latestAuth);
      print('[MOBILE-AUTH] syncOnAppOpen -> end');
    } finally {
      _syncRunning = false;
    }
  }

  Future<bool> validateSession({MobileAuthData? auth}) async {
    final authData = auth ?? await _readAuthFromPrefs();
    final uri = _uri(ApiDetails.sessionIdAuth);
    print('[MOBILE-AUTH] SESSION -> GET $uri');
    final response = await MobileHttpClient.instance.get(
      uri,
      headers: _headers(authData),
    );
    _logResponse('SESSION', response);
    return _isSuccess(response);
  }

  Future<bool> refreshToken({MobileAuthData? auth}) async {
    final authData = auth ?? await _readAuthFromPrefs();
    final uri = _uri(ApiDetails.refreshTokenId);
    print('[MOBILE-AUTH] REFRESH -> POST $uri');
    final response = await MobileHttpClient.instance.post(
      uri,
      headers: _headers(authData),
    );
    _logResponse('REFRESH', response);

    if (!_isSuccess(response)) return false;
    final body = _decode(response.body);
    final accessToken = _firstString(body, const [
      'accessToken',
      'token',
      'jwt',
    ]);
    final tokenType = _firstString(body, const ['tokenType']) ?? 'Bearer';
    final sessionId =
        _firstString(body, const ['sessionId']) ?? _sessionFromNested(body);

    if (accessToken != null && accessToken.isNotEmpty) {
      await _sessionManager.setAccessToken(accessToken);
      await _sessionManager.setTokenType(tokenType);
      print('[MOBILE-AUTH] REFRESH -> accessToken saved');
    }
    if (sessionId != null && sessionId.isNotEmpty) {
      await _sessionManager.setSessionId(sessionId);
      print('[MOBILE-AUTH] REFRESH -> sessionId saved');
    }
    return true;
  }

  Future<void> _callBootstrapVersion({
    required MobileAuthData auth,
    bool forceBootstrap = false,
  }) async {
    final uri = _uri(ApiDetails.bootStrapVersion);
    print('[MOBILE-AUTH] BOOTSTRAP_VERSION -> GET $uri');
    final response = await MobileHttpClient.instance.get(
      uri,
      headers: _headers(auth),
    );
    _logResponse('BOOTSTRAP_VERSION', response);

    if (!_isSuccess(response)) return;
    final body = _decode(response.body);
    final remotePermissionVersion = _firstString(body, const [
      'permissionsVersion',
      'permissionVersion',
    ]);
    final remoteProfileVersion = _firstString(body, const ['profileVersion']);
    final localPermissionVersion =
        await _sessionManager.getPermissionsVersion();
    final localProfileVersion = await _sessionManager.getProfileVersion();

    final versionChanged =
        forceBootstrap ||
        (remotePermissionVersion != null &&
            _normalizeVersion(remotePermissionVersion) !=
                _normalizeVersion(localPermissionVersion)) ||
        (remoteProfileVersion != null &&
            _normalizeVersion(remoteProfileVersion) !=
                _normalizeVersion(localProfileVersion));

    print(
      '[MOBILE-AUTH] BOOTSTRAP_VERSION -> local permission=$localPermissionVersion profile=$localProfileVersion',
    );
    print(
      '[MOBILE-AUTH] BOOTSTRAP_VERSION -> remote permission=$remotePermissionVersion profile=$remoteProfileVersion changed=$versionChanged',
    );

    if (versionChanged) {
      await bootstrap(auth: auth);
    } else {
      print('[MOBILE-AUTH] BOOTSTRAP -> skipped, local cache is current');
    }
  }

  Future<bool> bootstrap({MobileAuthData? auth}) async {
    final authData = auth ?? await _readAuthFromPrefs();
    final uri = _uri(ApiDetails.bootStrap);
    print('[MOBILE-AUTH] BOOTSTRAP -> GET $uri');
    final response = await MobileHttpClient.instance.get(
      uri,
      headers: _headers(authData),
    );
    _logResponse('BOOTSTRAP', response);

    if (!_isSuccess(response)) return false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mobileBootstrapJson', response.body);

    final body = _decode(response.body);
    final permissionVersion = _firstString(body, const [
      'permissionsVersion',
      'permissionVersion',
    ]);
    final profileVersion = _firstString(body, const ['profileVersion']);
    if (permissionVersion != null)
      await _sessionManager.setPermissionsVersion(permissionVersion);
    if (profileVersion != null)
      await _sessionManager.setProfileVersion(profileVersion);
    print('[MOBILE-AUTH] BOOTSTRAP -> cache saved');
    return true;
  }

  Future<bool> sendMobileDeviceInfo({MobileAuthData? auth}) async {
    try {
      final authData = auth ?? await _readAuthFromPrefs();
      if (!authData.hasAuth) {
        print('[MOBILE-AUTH] DEVICE_INFO -> skipped, token/session missing');
        return false;
      }

      final uri = _uri(ApiDetails.mobileInfo);
      final payload = await _deviceInfoPayload();
      print('[MOBILE-AUTH] DEVICE_INFO -> POST $uri');
      print('[MOBILE-AUTH] DEVICE_INFO payload -> $payload');
      final response = await MobileHttpClient.instance.post(
        uri,
        headers: <String, String>{
          ..._headers(authData),
          'Content-Type': 'application/json',
        },
        body: json.encode(payload),
      );
      _logResponse('DEVICE_INFO', response);
      return _isSuccess(response);
    } catch (error) {
      print('[MOBILE-AUTH] DEVICE_INFO -> error=$error');
      return false;
    }
  }

  Future<Map<String, String>> _deviceInfoPayload() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final applicationVersion =
        '${packageInfo.version}+${packageInfo.buildNumber}';
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      return <String, String>{
        'applicationVersion': applicationVersion,
        'manufacturer': androidInfo.manufacturer,
        'brand': androidInfo.brand,
        'model': androidInfo.model,
        'deviceName': androidInfo.device,
        'androidVersion': androidInfo.version.release,
        'sdkVersion': androidInfo.version.sdkInt.toString(),
        'product': androidInfo.product,
      };
    }

    if (Platform.isIOS) {
      final iosInfo = await DeviceInfoPlugin().iosInfo;
      return <String, String>{
        'applicationVersion': applicationVersion,
        'manufacturer': 'Apple',
        'brand': 'Apple',
        'model': iosInfo.model,
        'deviceName': iosInfo.name,
        'androidVersion': iosInfo.systemVersion,
        'sdkVersion': iosInfo.utsname.version,
        'product': iosInfo.utsname.machine,
      };
    }

    return <String, String>{
      'applicationVersion': applicationVersion,
      'manufacturer': Platform.operatingSystem,
      'brand': Platform.operatingSystem,
      'model': Platform.operatingSystemVersion,
      'deviceName': Platform.localHostname,
      'androidVersion': Platform.operatingSystemVersion,
      'sdkVersion': '',
      'product': Platform.operatingSystem,
    };
  }

  Future<MobileAuthData> _readAuthFromPrefs() async {
    return MobileAuthData(
      accessToken: await _sessionManager.getAccessToken(),
      sessionId: await _sessionManager.getSessionId(),
      tokenType: await _sessionManager.getTokenType() ?? 'Bearer',
    );
  }

  Uri _uri(String path) => Uri.parse('${ApiDetails.server}$path');

  Map<String, String> _headers(MobileAuthData auth) {
    return <String, String>{
      'Accept': 'application/json',
      if ((auth.accessToken ?? '').isNotEmpty)
        'Authorization': '${auth.tokenType ?? 'Bearer'} ${auth.accessToken}',
      if ((auth.sessionId ?? '').isNotEmpty)
        'X-Mobile-Session-Id': auth.sessionId!,
    };
  }

  bool _isSuccess(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) return false;
    final body = _decode(response.body);
    final status = _firstString(body, const ['status', 'result']);
    if (status == null || status.isEmpty) return true;
    return status.toUpperCase() == 'SUCCESS' ||
        status.toLowerCase() == 'success';
  }

  Map<String, dynamic> _decode(String body) {
    if (body.trim().isEmpty) return <String, dynamic>{};
    final decoded = json.decode(body);
    return decoded is Map<String, dynamic>
        ? decoded
        : <String, dynamic>{'data': decoded};
  }

  String? _firstString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value != null && value.toString().isNotEmpty) return value.toString();
    }
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      for (final key in keys) {
        final value = data[key];
        if (value != null && value.toString().isNotEmpty)
          return value.toString();
      }
    }
    return null;
  }

  String? _normalizeVersion(String? version) {
    if (version == null || version.trim().isEmpty) return version;
    final parsed = DateTime.tryParse(version);
    return parsed?.toUtc().toIso8601String() ?? version.trim();
  }

  String? _sessionFromNested(Map<String, dynamic> json) {
    final session = json['session'];
    if (session is Map<String, dynamic>)
      return session['sessionId']?.toString();
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      final nested = data['session'];
      if (nested is Map<String, dynamic>)
        return nested['sessionId']?.toString();
      return data['sessionId']?.toString();
    }
    return null;
  }

  void _logResponse(String tag, http.Response response) {
    final body =
        response.body.length > 1200
            ? '${response.body.substring(0, 1200)}...'
            : response.body;
    print('[MOBILE-AUTH] $tag <- status=${response.statusCode} body=$body');
  }
}

class MobileAuthData {
  final String? accessToken;
  final String? sessionId;
  final String? tokenType;

  const MobileAuthData({this.accessToken, this.sessionId, this.tokenType});

  bool get hasAuth =>
      (accessToken ?? '').isNotEmpty && (sessionId ?? '').isNotEmpty;
}
