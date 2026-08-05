import 'dart:convert';
import 'dart:io';

import 'package:er_flutter_project/commanScreen/allAPIList.dart';
import 'package:er_flutter_project/commanScreen/modalClass/geofenceListModal.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'package:er_flutter_project/sharedPrefancePage/ShardPre.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AttendancePunchApi {
  AttendancePunchApi({SessionManager? sessionManager})
    : _sessionManager = sessionManager ?? SessionManager();

  final SessionManager _sessionManager;
  static const Uuid _uuid = Uuid();

  Future<AttendancePunchContext> getPunchContext() async {
    final requestId = _uuid.v4();
    final response = await MobileHttpClient.instance
        .get(
          Uri.parse('${ApiDetails.server}${ApiDetails.mobilePunchContext}'),
          headers: await _headers(requestId),
        )
        .timeout(const Duration(seconds: 30));
    final decoded = jsonDecode(response.body);
    if (response.statusCode != 200 || decoded is! Map<String, dynamic> || decoded['success'] != true) {
      throw AttendancePunchException('PUNCH_CONTEXT_LOAD_FAILED_${response.statusCode}');
    }
    final data = decoded['data'];
    if (data is! Map<String, dynamic>) {
      throw const AttendancePunchException('INVALID_PUNCH_CONTEXT');
    }
    return AttendancePunchContext.fromJson(data);
  }

  Future<http.Response> punchWithoutSelfie({
    required String action,
    required double latitude,
    required double longitude,
    required String address,
    String? deviceInstallationId,
    double accuracyMeters = 50,
    int? geofenceId,
    String? clientEventId,
  }) async {
    final eventId = clientEventId ?? _uuid.v4();
    final response = await MobileHttpClient.instance
        .post(
          Uri.parse('${ApiDetails.server}${ApiDetails.mobilePunch}'),
          headers: await _headers(eventId, json: true),
          body: jsonEncode(
            _metadata(
              eventId: eventId,
              action: action,
              latitude: latitude,
              longitude: longitude,
              accuracyMeters: accuracyMeters,
              address: address,
              deviceInstallationId: await _installationId(deviceInstallationId),
              geofenceId: geofenceId,
            ),
          ),
        )
        .timeout(const Duration(seconds: 30));
    return _legacyCompatible(response);
  }

  Future<http.Response> punchWithSelfie({
    required File selfie,
    required String action,
    required double latitude,
    required double longitude,
    required String address,
    String? deviceInstallationId,
    double accuracyMeters = 50,
    int? geofenceId,
    String? clientEventId,
  }) async {
    final eventId = clientEventId ?? _uuid.v4();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiDetails.server}${ApiDetails.mobilePunchSelfie}'),
    );
    request.headers.addAll(await _headers(eventId));
    request.fields['metadata'] = jsonEncode(
      _metadata(
        eventId: eventId,
        action: action,
        latitude: latitude,
        longitude: longitude,
        accuracyMeters: accuracyMeters,
        address: address,
        deviceInstallationId: await _installationId(deviceInstallationId),
        geofenceId: geofenceId,
      ),
    );
    request.files.add(await http.MultipartFile.fromPath('selfie', selfie.path));
    final streamed = await MobileHttpClient.instance
        .send(request)
        .timeout(const Duration(seconds: 30));
    return _legacyCompatible(await http.Response.fromStream(streamed));
  }

  Map<String, Object?> _metadata({
    required String eventId,
    required String action,
    required double latitude,
    required double longitude,
    required double accuracyMeters,
    required String address,
    required String deviceInstallationId,
    int? geofenceId,
  }) => <String, Object?>{
    'clientEventId': eventId,
    'punchAction': action.trim().toUpperCase(),
    'capturedAt': _offsetIso8601(DateTime.now()),
    if (geofenceId != null) 'geofenceId': geofenceId,
    'location': <String, Object?>{
      'latitude': latitude,
      'longitude': longitude,
      'accuracyMeters': accuracyMeters,
      'address': address,
    },
    'device': <String, Object?>{
      'installationId': deviceInstallationId,
      'platform': Platform.isIOS ? 'IOS' : 'ANDROID',
    },
  };

  Future<Map<String, String>> _headers(
    String eventId, {
    bool json = false,
  }) async {
    final token = await _sessionManager.getAccessToken();
    final tokenType = await _sessionManager.getTokenType() ?? 'Bearer';
    if (token == null || token.isEmpty) {
      throw const AttendancePunchException('AUTHENTICATION_REQUIRED');
    }
    return <String, String>{
      'Authorization': '$tokenType $token',
      'X-Request-ID': eventId,
      'Idempotency-Key': eventId,
      if (json) 'Content-Type': 'application/json',
    };
  }

  String _offsetIso8601(DateTime value) {
    if (value.isUtc) return value.toIso8601String();
    final offset = value.timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final hours = offset.inHours.abs().toString().padLeft(2, '0');
    final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    return '${value.toIso8601String()}$sign$hours:$minutes';
  }

  Future<String> _installationId(String? supplied) async {
    if (supplied != null && supplied.isNotEmpty) return supplied;
    final preferences = await SharedPreferences.getInstance();
    const key = 'attendanceDeviceInstallationId';
    final existing = preferences.getString(key);
    if (existing != null && existing.isNotEmpty) return existing;
    final generated = _uuid.v4();
    await preferences.setString(key, generated);
    return generated;
  }

  http.Response _legacyCompatible(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic>) {
        final success = body['success'] == true;
        final error = body['error'];
        final reason =
            success
                ? (body['message']?.toString() ?? 'Punch recorded successfully')
                : error is Map
                ? (error['message'] ?? error['code'] ?? 'Punch failed')
                    .toString()
                : (body['message']?.toString() ?? 'Punch failed');
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
    return response;
  }
}

class AttendancePunchContext {
  final int? policyId;
  final bool enabled;
  final bool selfieRequired;
  final bool geofenceRequired;
  final bool locationRequired;
  final double maximumGpsAccuracyMeters;
  final String outsideGeofenceAction;
  final List<AttendanceGeofence> assignedGeofences;

  const AttendancePunchContext({
    required this.policyId,
    required this.enabled,
    required this.selfieRequired,
    required this.geofenceRequired,
    required this.locationRequired,
    required this.maximumGpsAccuracyMeters,
    required this.outsideGeofenceAction,
    required this.assignedGeofences,
  });

  factory AttendancePunchContext.fromJson(Map<String, dynamic> json) => AttendancePunchContext(
    policyId: (json['policyId'] as num?)?.toInt(),
    enabled: json['enabled'] == true,
    selfieRequired: json['selfieRequired'] == true,
    geofenceRequired: json['geofenceRequired'] == true,
    locationRequired: json['locationRequired'] != false,
    maximumGpsAccuracyMeters: (json['maximumGpsAccuracyMeters'] as num?)?.toDouble() ?? 100,
    outsideGeofenceAction: json['outsideGeofenceAction']?.toString() ?? 'REJECT',
    assignedGeofences: (json['assignedGeofences'] as List? ?? const [])
        .whereType<Map>()
        .map((value) => AttendanceGeofence.fromJson(Map<String, dynamic>.from(value)))
        .toList(),
  );

  GeofenceListModal toLegacyGeofenceList() => GeofenceListModal(
    userdata: assignedGeofences.map((fence) => Userdata(
      id: fence.id,
      name: fence.name,
      geofencetypename: fence.name,
      locationLatitude: fence.latitude,
      locationLongitude: fence.longitude,
      radius: fence.radiusMeters,
    )).toList(),
  );
}

class AttendanceGeofence {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final int radiusMeters;

  const AttendanceGeofence({required this.id, required this.name, required this.latitude,
    required this.longitude, required this.radiusMeters});

  factory AttendanceGeofence.fromJson(Map<String, dynamic> json) => AttendanceGeofence(
    id: (json['id'] as num).toInt(),
    name: json['name']?.toString() ?? '',
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    radiusMeters: (json['radiusMeters'] as num).toInt(),
  );
}

class AttendancePunchException implements Exception {
  final String code;
  const AttendancePunchException(this.code);
  @override
  String toString() => code;
}
