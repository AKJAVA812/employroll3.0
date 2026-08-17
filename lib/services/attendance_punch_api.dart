import 'dart:convert';
import 'dart:io';

import 'package:er_flutter_project/commanScreen/allAPIList.dart';
import 'package:er_flutter_project/commanScreen/modalClass/geofenceListModal.dart';
import 'package:er_flutter_project/services/mobile_api_foundation.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'package:er_flutter_project/sharedPrefancePage/ShardPre.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AttendancePunchApi {
  AttendancePunchApi({SessionManager? sessionManager})
    : _sessionManager = sessionManager ?? SessionManager() {
    _foundation = MobileApiFoundation(sessionManager: _sessionManager);
  }

  final SessionManager _sessionManager;
  late final MobileApiFoundation _foundation;

  Future<AttendancePunchContext> getPunchContext() async {
    final requestId = _foundation.newRequestId();
    final response = await MobileHttpClient.instance
        .get(
          Uri.parse('${ApiDetails.server}${ApiDetails.mobilePunchContext}'),
          headers: await _headers(requestId),
        )
        .timeout(const Duration(seconds: 30));
    final decoded = jsonDecode(response.body);
    if (response.statusCode != 200 ||
        decoded is! Map<String, dynamic> ||
        decoded['success'] != true) {
      throw AttendancePunchException(
        'PUNCH_CONTEXT_LOAD_FAILED_${response.statusCode}',
      );
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
    final eventId = clientEventId ?? _foundation.newRequestId();
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
              deviceInstallationId: await _foundation.installationId(
                supplied: deviceInstallationId,
              ),
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
    final eventId = clientEventId ?? _foundation.newRequestId();
    final response = await _sendSelfiePunch(
      selfie: selfie,
      eventId: eventId,
      action: action,
      latitude: latitude,
      longitude: longitude,
      address: address,
      deviceInstallationId: deviceInstallationId,
      accuracyMeters: accuracyMeters,
      geofenceId: geofenceId,
    );
    if (!_isAmbiguousGatewayResponse(response)) {
      return _legacyCompatible(response);
    }

    if (await _punchWasSaved(eventId)) {
      return _legacyCompatible(_recoveredPunchResponse(eventId));
    }

    final retryResponse = await _sendSelfiePunch(
      selfie: selfie,
      eventId: eventId,
      action: action,
      latitude: latitude,
      longitude: longitude,
      address: address,
      deviceInstallationId: deviceInstallationId,
      accuracyMeters: accuracyMeters,
      geofenceId: geofenceId,
    );
    if (_isAmbiguousGatewayResponse(retryResponse) &&
        await _punchWasSaved(eventId)) {
      return _legacyCompatible(_recoveredPunchResponse(eventId));
    }
    return _legacyCompatible(retryResponse);
  }

  Future<http.Response> _sendSelfiePunch({
    required File selfie,
    required String eventId,
    required String action,
    required double latitude,
    required double longitude,
    required String address,
    String? deviceInstallationId,
    required double accuracyMeters,
    int? geofenceId,
  }) async {
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
        deviceInstallationId: await _foundation.installationId(
          supplied: deviceInstallationId,
        ),
        geofenceId: geofenceId,
      ),
    );
    request.files.add(
      await http.MultipartFile.fromPath(
        'selfie',
        selfie.path,
        contentType: _selfieContentType(selfie),
      ),
    );
    final streamed = await MobileHttpClient.instance
        .send(request)
        .timeout(const Duration(seconds: 30));
    return http.Response.fromStream(streamed);
  }

  bool _isAmbiguousGatewayResponse(http.Response response) {
    final body = response.body.toLowerCase();
    return response.statusCode == 502 ||
        response.statusCode == 504 ||
        body.contains('err_ngrok_3004') ||
        body.contains('ngrok gateway error') ||
        body.contains('invalid or incomplete http response');
  }

  Future<bool> _punchWasSaved(String eventId) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    try {
      final response = await MobileHttpClient.instance
          .get(
            Uri.parse(
              '${ApiDetails.server}${ApiDetails.mobileTodayPunches}',
            ),
            headers: await _headers(eventId),
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return false;
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic> || decoded['data'] is! List) {
        return false;
      }
      return (decoded['data'] as List).whereType<Map>().any(
        (punch) => punch['clientEventId']?.toString() == eventId,
      );
    } catch (error) {
      return false;
    }
  }

  http.Response _recoveredPunchResponse(String eventId) {
    return http.Response(
      jsonEncode(<String, Object?>{
        'success': true,
        'message': 'Punch recorded successfully',
        'data': <String, Object?>{
          'clientEventId': eventId,
          'status': 'ACCEPTED',
          'recoveredAfterGatewayError': true,
        },
      }),
      200,
    );
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
    'capturedAt': _foundation.offsetIso8601(DateTime.now()),
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
    final sessionId = await _sessionManager.getMobileSessionId();
    if (token == null || token.isEmpty) {
      throw const AttendancePunchException('AUTHENTICATION_REQUIRED');
    }
    return <String, String>{
      'Authorization': '$tokenType $token',
      if (sessionId != null && sessionId.isNotEmpty)
        'X-Mobile-Session-Id': sessionId,
      'X-Request-ID': eventId,
      'Idempotency-Key': eventId,
      if (json) 'Content-Type': 'application/json',
    };
  }

  MediaType _selfieContentType(File selfie) {
    final path = selfie.path.toLowerCase();
    if (path.endsWith('.png')) return MediaType('image', 'png');
    return MediaType('image', 'jpeg');
  }

  http.Response _legacyCompatible(http.Response response) {
    return _foundation.toLegacyResponse(
      response,
      successMessage: 'Punch recorded successfully',
      failureMessage: 'Punch failed',
    );
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

  factory AttendancePunchContext.fromJson(Map<String, dynamic> json) =>
      AttendancePunchContext(
        policyId: (json['policyId'] as num?)?.toInt(),
        enabled: json['enabled'] == true,
        selfieRequired: json['selfieRequired'] == true,
        geofenceRequired: json['geofenceRequired'] == true,
        locationRequired: json['locationRequired'] != false,
        maximumGpsAccuracyMeters:
            (json['maximumGpsAccuracyMeters'] as num?)?.toDouble() ?? 100,
        outsideGeofenceAction:
            json['outsideGeofenceAction']?.toString() ?? 'REJECT',
        assignedGeofences:
            (json['assignedGeofences'] as List? ?? const [])
                .whereType<Map>()
                .map(
                  (value) => AttendanceGeofence.fromJson(
                    Map<String, dynamic>.from(value),
                  ),
                )
                .toList(),
      );

  GeofenceListModal toLegacyGeofenceList() => GeofenceListModal(
    userdata:
        assignedGeofences
            .map(
              (fence) => Userdata(
                id: fence.id,
                name: fence.name,
                geofencetypename: fence.name,
                locationLatitude: fence.latitude,
                locationLongitude: fence.longitude,
                radius: fence.radiusMeters,
              ),
            )
            .toList(),
  );
}

class AttendanceGeofence {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final int radiusMeters;

  const AttendanceGeofence({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
  });

  factory AttendanceGeofence.fromJson(Map<String, dynamic> json) =>
      AttendanceGeofence(
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
