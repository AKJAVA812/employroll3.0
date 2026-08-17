import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../commanScreen/allAPIList.dart';
import '../sharedPrefancePage/ShardPre.dart';

typedef RefreshAccessToken = Future<bool> Function();
typedef SessionExpiredCallback = Future<void> Function();

class MobileHttpClient extends http.BaseClient {
  MobileHttpClient._() : _inner = _createClient();

  static final MobileHttpClient instance = MobileHttpClient._();

  final http.Client _inner;
  final SessionManager _sessionManager = SessionManager();
  RefreshAccessToken? _refreshAccessToken;
  SessionExpiredCallback? _onSessionExpired;
  Future<bool>? _activeRefresh;
  Future<void>? _activeLogout;
  bool _sessionExpiredHandled = false;

  void configureUnauthorizedRecovery({
    required RefreshAccessToken refreshAccessToken,
    required SessionExpiredCallback onSessionExpired,
  }) {
    _refreshAccessToken = refreshAccessToken;
    _onSessionExpired = onSessionExpired;
  }

  void markAuthenticated() {
    _sessionExpiredHandled = false;
  }

  Future<void> expireSession() => _logoutOnce();

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    return _withUnauthorizedRecovery(
      url,
      headers,
      (retryHeaders) => _inner.get(url, headers: retryHeaders),
    );
  }

  @override
  Future<http.Response> head(Uri url, {Map<String, String>? headers}) {
    return _withUnauthorizedRecovery(
      url,
      headers,
      (retryHeaders) => _inner.head(url, headers: retryHeaders),
    );
  }

  @override
  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return _withUnauthorizedRecovery(
      url,
      headers,
      (retryHeaders) => _inner.post(
        url,
        headers: retryHeaders,
        body: body,
        encoding: encoding,
      ),
    );
  }

  @override
  Future<http.Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return _withUnauthorizedRecovery(
      url,
      headers,
      (retryHeaders) => _inner.put(
        url,
        headers: retryHeaders,
        body: body,
        encoding: encoding,
      ),
    );
  }

  @override
  Future<http.Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return _withUnauthorizedRecovery(
      url,
      headers,
      (retryHeaders) => _inner.patch(
        url,
        headers: retryHeaders,
        body: body,
        encoding: encoding,
      ),
    );
  }

  @override
  Future<http.Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return _withUnauthorizedRecovery(
      url,
      headers,
      (retryHeaders) => _inner.delete(
        url,
        headers: retryHeaders,
        body: body,
        encoding: encoding,
      ),
    );
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final body = await request.finalize().toBytes();
    final originalHeaders = Map<String, String>.from(request.headers);

    Future<http.StreamedResponse> submit(Map<String, String> headers) {
      final copy = http.Request(request.method, request.url)
        ..followRedirects = request.followRedirects
        ..maxRedirects = request.maxRedirects
        ..persistentConnection = request.persistentConnection
        ..headers.addAll(headers)
        ..bodyBytes = body;
      return _inner.send(copy);
    }

    var response = await submit(originalHeaders);
    if (response.statusCode != HttpStatus.unauthorized ||
        !_canRecover(request.url)) {
      return response;
    }

    final unauthorizedBody = await response.stream.toBytes();
    final refreshed = await _refreshOnce();
    if (!refreshed) {
      await _logoutOnce();
      return http.StreamedResponse(
        Stream<List<int>>.value(unauthorizedBody),
        response.statusCode,
        contentLength: unauthorizedBody.length,
        request: response.request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
      );
    }

    response = await submit(await _latestHeaders(originalHeaders));
    if (response.statusCode == HttpStatus.unauthorized) {
      await _logoutOnce();
    }
    return response;
  }

  Future<http.Response> _withUnauthorizedRecovery(
    Uri url,
    Map<String, String>? headers,
    Future<http.Response> Function(Map<String, String>? headers) request,
  ) async {
    var response = await request(headers);
    if (response.statusCode != HttpStatus.unauthorized || !_canRecover(url)) {
      return response;
    }

    debugPrint('[MOBILE-AUTH] 401 ${url.path} -> refreshing token');
    final refreshed = await _refreshOnce();
    if (!refreshed) {
      await _logoutOnce();
      return response;
    }

    response = await request(await _latestHeaders(headers));
    if (response.statusCode == HttpStatus.unauthorized) {
      debugPrint('[MOBILE-AUTH] retry 401 ${url.path} -> session expired');
      await _logoutOnce();
    }
    return response;
  }

  bool _canRecover(Uri url) {
    final server = Uri.tryParse(ApiDetails.server);
    if (server == null || url.host != server.host) return false;
    return url.path != ApiDetails.login &&
        url.path != ApiDetails.sessionIdAuth &&
        url.path != ApiDetails.refreshTokenId &&
        url.path != ApiDetails.logoutAPi;
  }

  Future<bool> _refreshOnce() {
    final running = _activeRefresh;
    if (running != null) return running;

    final callback = _refreshAccessToken;
    if (callback == null) return Future<bool>.value(false);

    final future = Future<bool>.sync(callback).catchError((
      Object error,
      StackTrace stackTrace,
    ) {
      debugPrint('[MOBILE-AUTH] token refresh failed -> $error');
      return false;
    });
    _activeRefresh = future;
    return future.whenComplete(() {
      if (identical(_activeRefresh, future)) _activeRefresh = null;
    });
  }

  Future<void> _logoutOnce() {
    if (_sessionExpiredHandled) return Future<void>.value();
    final running = _activeLogout;
    if (running != null) return running;

    final callback = _onSessionExpired;
    if (callback == null) return Future<void>.value();

    _sessionExpiredHandled = true;
    final future = Future<void>.sync(callback).catchError((
      Object error,
      StackTrace stackTrace,
    ) {
      debugPrint('[MOBILE-AUTH] forced logout failed -> $error');
    });
    _activeLogout = future;
    return future.whenComplete(() {
      if (identical(_activeLogout, future)) _activeLogout = null;
    });
  }

  Future<Map<String, String>> _latestHeaders(
    Map<String, String>? original,
  ) async {
    final headers = <String, String>{...?original};
    final accessToken = await _sessionManager.getAccessToken();
    final tokenType = await _sessionManager.getTokenType() ?? 'Bearer';
    final sessionId = await _sessionManager.getMobileSessionId();

    headers.removeWhere((key, value) {
      final normalized = key.toLowerCase();
      return normalized == 'authorization' ||
          normalized == 'x-mobile-session-id';
    });
    if ((accessToken ?? '').isNotEmpty) {
      headers['Authorization'] = '$tokenType $accessToken';
    }
    if ((sessionId ?? '').isNotEmpty) {
      headers['X-Mobile-Session-Id'] = sessionId!;
    }
    return headers;
  }

  @override
  void close() => _inner.close();

  static http.Client _createClient() {
    final context = SecurityContext(withTrustedRoots: true);
    try {
      context.setTrustedCertificatesBytes(utf8.encode(_sectigoR36Pem));
    } catch (error) {
    }

    final client = HttpClient(context: context);
    client.connectionTimeout = const Duration(seconds: 30);
    return IOClient(client);
  }
}

const String _sectigoR36Pem = '''-----BEGIN CERTIFICATE-----
MIIGTDCCBDSgAwIBAgIQOXpmzCdWNi4NqofKbqvjsTANBgkqhkiG9w0BAQwFADBf
MQswCQYDVQQGEwJHQjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMTYwNAYDVQQD
Ey1TZWN0aWdvIFB1YmxpYyBTZXJ2ZXIgQXV0aGVudGljYXRpb24gUm9vdCBSNDYw
HhcNMjEwMzIyMDAwMDAwWhcNMzYwMzIxMjM1OTU5WjBgMQswCQYDVQQGEwJHQjEY
MBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMTcwNQYDVQQDEy5TZWN0aWdvIFB1Ymxp
YyBTZXJ2ZXIgQXV0aGVudGljYXRpb24gQ0EgRFYgUjM2MIIBojANBgkqhkiG9w0B
AQEFAAOCAY8AMIIBigKCAYEAljZf2HIz7+SPUPQCQObZYcrxLTHYdf1ZtMRe7Yeq
RPSwygz16qJ9cAWtWNTcuICc++p8Dct7zNGxCpqmEtqifO7NvuB5dEVexXn9RFFH
12Hm+NtPRQgXIFjx6MSJcNWuVO3XGE57L1mHlcQYj+g4hny90aFh2SCZCDEVkAja
EMMfYPKuCjHuuF+bzHFb/9gV8P9+ekcHENF2nR1efGWSKwnfG5RawlkaQDpRtZTm
M64TIsv/r7cyFO4nSjs1jLdXYdz5q3a4L0NoabZfbdxVb+CUEHfB0bpulZQtH1Rv
38e/lIdP7OTTIlZh6OYL6NhxP8So0/sht/4J9mqIGxRFc0/pC8suja+wcIUna0HB
pXKfXTKpzgis+zmXDL06ASJf5E4A2/m+Hp6b84sfPAwQ766rI65mh50S0Di9E3Pn
2WcaJc+PILsBmYpgtmgWTR9eV9otfKRUBfzHUHcVgarub/XluEpRlTtZudU5xbFN
xx/DgMrXLUAPaI60fZ6wA+PTAgMBAAGjggGBMIIBfTAfBgNVHSMEGDAWgBRWc1hk
lfmSGrASKgRieaFAFYghSTAdBgNVHQ4EFgQUaMASFhgOr872h6YyV6NGUV3LBycw
DgYDVR0PAQH/BAQDAgGGMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0lBBYwFAYI
KwYBBQUHAwEGCCsGAQUFBwMCMBsGA1UdIAQUMBIwBgYEVR0gADAIBgZngQwBAgEw
VAYDVR0fBE0wSzBJoEegRYZDaHR0cDovL2NybC5zZWN0aWdvLmNvbS9TZWN0aWdv
UHVibGljU2VydmVyQXV0aGVudGljYXRpb25Sb290UjQ2LmNybDCBhAYIKwYBBQUH
AQEEeDB2ME8GCCsGAQUFBzAChkNodHRwOi8vY3J0LnNlY3RpZ28uY29tL1NlY3Rp
Z29QdWJsaWNTZXJ2ZXJBdXRoZW50aWNhdGlvblJvb3RSNDYucDdjMCMGCCsGAQUF
BzABhhdodHRwOi8vb2NzcC5zZWN0aWdvLmNvbTANBgkqhkiG9w0BAQwFAAOCAgEA
YtOC9Fy+TqECFw40IospI92kLGgoSZGPOSQXMBqmsGWZUQ7rux7cj1du6d9rD6C8
ze1B2eQjkrGkIL/OF1s7vSmgYVafsRoZd/IHUrkoQvX8FZwUsmPu7amgBfaY3g+d
q1x0jNGKb6I6Bzdl6LgMD9qxp+3i7GQOnd9J8LFSietY6Z4jUBzVoOoz8iAU84OF
h2HhAuiPw1ai0VnY38RTI+8kepGWVfGxfBWzwH9uIjeooIeaosVFvE8cmYUB4TSH
5dUyD0jHct2+8ceKEtIoFU/FfHq/mDaVnvcDCZXtIgitdMFQdMZaVehmObyhRdDD
4NQCs0gaI9AAgFj4L9QtkARzhQLNyRf87Kln+YU0lgCGr9HLg3rGO8q+Y4ppLsOd
unQZ6ZxPNGIfOApbPVf5hCe58EZwiWdHIMn9lPP6+F404y8NNugbQixBber+x536
WrZhFZLjEkhp7fFXf9r32rNPfb74X/U90Bdy4lzp3+X1ukh1BuMxA/EEhDoTOS3l
7ABvc7BYSQubQ2490OcdkIzUh3ZwDrakMVrbaTxUM2p24N6dB+ns2zptWCva6jzW
r8IWKIMxzxLPv5Kt3ePKcUdvkBU/smqujSczTzzSjIoR5QqQA6lN1ZRSnuHIWCvh
JEltkYnTAH41QJ6SAWO66GrrUESwN/cgZzL4JLEqz1Y=
-----END CERTIFICATE-----''';
