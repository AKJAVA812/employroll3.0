import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:er_flutter_project/commanScreen/allAPIList.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'package:er_flutter_project/sharedPrefancePage/ShardPre.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

enum MobileSyncStatus { pending, syncing, synced, failed }

enum MobileApiPriority { read, write, upload, auth }

class MobileApiFoundation {
  MobileApiFoundation({SessionManager? sessionManager})
    : _sessionManager = sessionManager ?? SessionManager();

  static final MobileApiFoundation instance = MobileApiFoundation();
  static const Uuid _uuid = Uuid();

  final SessionManager _sessionManager;

  static const Duration readTimeout = Duration(seconds: 15);
  static const Duration writeTimeout = Duration(seconds: 30);
  static const Duration uploadTimeout = Duration(seconds: 45);
  static const Duration authTimeout = Duration(seconds: 20);

  String newRequestId() => _uuid.v4();

  Uri uri(String path, {Map<String, Object?>? queryParameters}) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final base = Uri.parse('${ApiDetails.server}$normalizedPath');
    if (queryParameters == null || queryParameters.isEmpty) return base;
    return base.replace(
      queryParameters: <String, String>{
        ...base.queryParameters,
        for (final entry in queryParameters.entries)
          if (entry.value != null) entry.key: entry.value.toString(),
      },
    );
  }

  Future<Map<String, String>> authHeaders({
    String? requestId,
    bool json = false,
  }) async {
    final token = await _sessionManager.getAccessToken();
    final tokenType = await _sessionManager.getTokenType() ?? 'Bearer';
    final sessionId = await _sessionManager.getMobileSessionId();
    if (token == null || token.isEmpty) {
      throw const MobileApiException('AUTHENTICATION_REQUIRED');
    }
    final headers = <String, String>{
      'Authorization': '$tokenType $token',
      if (sessionId != null && sessionId.isNotEmpty)
        'X-Mobile-Session-Id': sessionId,
      if (requestId != null && requestId.isNotEmpty) ...<String, String>{
        'X-Request-ID': requestId,
        'Idempotency-Key': requestId,
      },
      'Accept': 'application/json',
      'ngrok-skip-browser-warning': 'true',
      if (json) 'Content-Type': 'application/json',
    };
    print(
      '[MOBILE-API] headers -> tokenPresent=${token.isNotEmpty} '
      'sessionPresent=${sessionId != null && sessionId.isNotEmpty} '
      'requestId=$requestId',
    );
    return headers;
  }

  Future<http.Response> get(
    String path, {
    Map<String, Object?>? queryParameters,
    Map<String, String>? headers,
    Duration timeout = readTimeout,
    String tag = 'GET',
  }) {
    final requestUri = uri(path, queryParameters: queryParameters);
    return _guard(
      () => MobileHttpClient.instance
          .get(requestUri, headers: headers)
          .timeout(timeout),
      tag: tag,
      uri: requestUri,
    );
  }

  Future<http.Response> postJson(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? queryParameters,
    Map<String, String>? headers,
    Duration timeout = writeTimeout,
    String tag = 'POST_JSON',
  }) {
    final requestUri = uri(path, queryParameters: queryParameters);
    return _guard(
      () => MobileHttpClient.instance
          .post(requestUri, headers: headers, body: jsonEncode(body))
          .timeout(timeout),
      tag: tag,
      uri: requestUri,
    );
  }

  Future<http.Response> postForm(
    String path, {
    Map<String, Object?>? queryParameters,
    Map<String, String>? headers,
    Duration timeout = writeTimeout,
    String tag = 'POST_FORM',
  }) {
    final requestUri = uri(path, queryParameters: queryParameters);
    return _guard(
      () => MobileHttpClient.instance
          .post(requestUri, headers: headers)
          .timeout(timeout),
      tag: tag,
      uri: requestUri,
    );
  }

  Future<http.StreamedResponse> send(
    http.BaseRequest request, {
    Duration timeout = uploadTimeout,
    String tag = 'MULTIPART',
  }) async {
    print('[MOBILE-API] $tag -> ${request.method} ${request.url}');
    try {
      final response = await MobileHttpClient.instance
          .send(request)
          .timeout(timeout);
      print('[MOBILE-API] $tag <- status=${response.statusCode}');
      return response;
    } on TimeoutException {
      throw MobileApiException.timeout();
    } on SocketException catch (error) {
      throw MobileApiException.network(error.message);
    } on http.ClientException catch (error) {
      throw MobileApiException.network(error.message);
    }
  }

  Map<String, dynamic> decodeMap(String body) {
    if (body.trim().isEmpty) return <String, dynamic>{};
    final decoded = jsonDecode(body);
    return decoded is Map<String, dynamic>
        ? decoded
        : <String, dynamic>{'data': decoded};
  }

  bool isSuccess(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) return false;
    final body = decodeMap(response.body);
    final status = _firstString(body, const ['status', 'result']);
    if (body['success'] == true) return true;
    if (status == null || status.isEmpty) return true;
    return status.toUpperCase() == 'SUCCESS' ||
        status.toLowerCase() == 'success';
  }

  http.Response toLegacyResponse(
    http.Response response, {
    required String successMessage,
    required String failureMessage,
  }) {
    try {
      final body = decodeMap(response.body);
      if (body.isNotEmpty) {
        final success = body['success'] == true || isSuccess(response);
        final error = body['error'];
        final reason =
            success
                ? (body['message']?.toString() ?? successMessage)
                : error is Map
                ? (error['message'] ?? error['code'] ?? failureMessage)
                    .toString()
                : (body['message']?.toString() ?? failureMessage);
        return http.Response(
          jsonEncode(<String, Object?>{
            'result': success ? 'success' : 'failed',
            'reason': reason,
            'data': body['data'],
          }),
          success ? 200 : response.statusCode,
          headers: response.headers,
          request: response.request,
        );
      }
    } catch (_) {}
    return http.Response(
      jsonEncode(<String, Object?>{
        'result': 'failed',
        'reason': response.body.isEmpty ? failureMessage : response.body,
      }),
      response.statusCode,
      headers: response.headers,
      request: response.request,
    );
  }

  String offsetIso8601(DateTime value) {
    if (value.isUtc) return value.toIso8601String();
    final offset = value.timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final hours = offset.inHours.abs().toString().padLeft(2, '0');
    final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    return '${value.toIso8601String()}$sign$hours:$minutes';
  }

  Future<String> installationId({String? supplied}) async {
    if (supplied != null && supplied.isNotEmpty) return supplied;
    final preferences = await SharedPreferences.getInstance();
    const key = 'attendanceDeviceInstallationId';
    final existing = preferences.getString(key);
    if (existing != null && existing.isNotEmpty) return existing;
    final generated = newRequestId();
    await preferences.setString(key, generated);
    return generated;
  }

  Future<http.Response> _guard(
    Future<http.Response> Function() call, {
    required String tag,
    required Uri uri,
  }) async {
    print('[MOBILE-API] $tag -> $uri');
    try {
      final response = await call();
      final body =
          response.body.length > 1200
              ? '${response.body.substring(0, 1200)}...'
              : response.body;
      print('[MOBILE-API] $tag <- status=${response.statusCode} body=$body');
      return response;
    } on TimeoutException {
      throw MobileApiException.timeout();
    } on SocketException catch (error) {
      throw MobileApiException.network(error.message);
    } on http.ClientException catch (error) {
      throw MobileApiException.network(error.message);
    }
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
        if (value != null && value.toString().isNotEmpty) {
          return value.toString();
        }
      }
    }
    return null;
  }
}

class MobileApiCache {
  MobileApiCache._();

  static final MobileApiCache instance = MobileApiCache._();

  Future<void> saveJson(String key, Map<String, dynamic> json) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      key,
      jsonEncode(<String, Object?>{
        'cachedAt': DateTime.now().toIso8601String(),
        'data': json,
      }),
    );
  }

  Future<MobileCachedJson?> readJson(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) return null;
    final data = decoded['data'];
    if (data is! Map<String, dynamic>) return null;
    return MobileCachedJson(
      cachedAt:
          DateTime.tryParse(decoded['cachedAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      data: data,
    );
  }

  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}

class MobilePendingQueue {
  MobilePendingQueue._();

  static final MobilePendingQueue instance = MobilePendingQueue._();
  static const String _storageKey = 'mobilePendingApiQueue';

  Future<void> enqueue(MobilePendingRequest request) async {
    final items = await list();
    items.add(request);
    await _save(items);
  }

  Future<List<MobilePendingRequest>> list() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return <MobilePendingRequest>[];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return <MobilePendingRequest>[];
    return decoded
        .whereType<Map>()
        .map(
          (item) =>
              MobilePendingRequest.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  Future<void> update(MobilePendingRequest request) async {
    final items = await list();
    final index = items.indexWhere((item) => item.id == request.id);
    if (index == -1) return;
    items[index] = request;
    await _save(items);
  }

  Future<void> remove(String id) async {
    final items = await list();
    items.removeWhere((item) => item.id == id);
    await _save(items);
  }

  Future<void> _save(List<MobilePendingRequest> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode(items.map((item) => item.toJson()).toList()),
    );
  }
}

class MobileCachedJson {
  final DateTime cachedAt;
  final Map<String, dynamic> data;

  const MobileCachedJson({required this.cachedAt, required this.data});
}

class MobilePendingRequest {
  MobilePendingRequest({
    required this.id,
    required this.module,
    required this.actionType,
    required this.payloadJson,
    required this.createdAt,
    this.status = MobileSyncStatus.pending,
    this.retryCount = 0,
    this.lastError,
  });

  factory MobilePendingRequest.create({
    required String module,
    required String actionType,
    required Map<String, dynamic> payloadJson,
  }) {
    final foundation = MobileApiFoundation.instance;
    return MobilePendingRequest(
      id: foundation.newRequestId(),
      module: module,
      actionType: actionType,
      payloadJson: payloadJson,
      createdAt: DateTime.now(),
    );
  }

  factory MobilePendingRequest.fromJson(Map<String, dynamic> json) {
    return MobilePendingRequest(
      id: json['id']?.toString() ?? '',
      module: json['module']?.toString() ?? '',
      actionType: json['actionType']?.toString() ?? '',
      payloadJson: Map<String, dynamic>.from(json['payloadJson'] as Map),
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      status: MobileSyncStatus.values.firstWhere(
        (status) => status.name == json['status']?.toString(),
        orElse: () => MobileSyncStatus.pending,
      ),
      retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
      lastError: json['lastError']?.toString(),
    );
  }

  final String id;
  final String module;
  final String actionType;
  final Map<String, dynamic> payloadJson;
  final DateTime createdAt;
  final MobileSyncStatus status;
  final int retryCount;
  final String? lastError;

  MobilePendingRequest copyWith({
    MobileSyncStatus? status,
    int? retryCount,
    String? lastError,
  }) {
    return MobilePendingRequest(
      id: id,
      module: module,
      actionType: actionType,
      payloadJson: payloadJson,
      createdAt: createdAt,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
    );
  }

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'module': module,
    'actionType': actionType,
    'payloadJson': payloadJson,
    'createdAt': createdAt.toIso8601String(),
    'status': status.name,
    'retryCount': retryCount,
    'lastError': lastError,
  };
}

class MobileApiException implements Exception {
  final String code;
  final String? message;
  final int? statusCode;
  final bool retryable;

  const MobileApiException(
    this.code, {
    this.message,
    this.statusCode,
    this.retryable = false,
  });

  factory MobileApiException.timeout() => const MobileApiException(
    'REQUEST_TIMEOUT',
    message: 'Server response timeout',
    retryable: true,
  );

  factory MobileApiException.network(String message) =>
      MobileApiException('NETWORK_ERROR', message: message, retryable: true);

  @override
  String toString() => message == null ? code : '$code: $message';
}
