import 'dart:convert';
import 'dart:io';

import 'package:er_flutter_project/commanScreen/allAPIList.dart';
import 'package:er_flutter_project/services/mobile_api_foundation.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'package:er_flutter_project/sharedPrefancePage/ShardPre.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class OdPunchApi {
  OdPunchApi({SessionManager? sessionManager})
    : _sessionManager = sessionManager ?? SessionManager() {
    _foundation = MobileApiFoundation(sessionManager: _sessionManager);
  }

  final SessionManager _sessionManager;
  late final MobileApiFoundation _foundation;

  Future<http.Response> getPunchContext() async {
    final requestId = _foundation.newRequestId();
    final uri = Uri.parse(
      '${ApiDetails.server}${ApiDetails.mobileOdPunchContext}',
    );
    final response = await MobileHttpClient.instance
        .get(uri, headers: await _headers(requestId))
        .timeout(const Duration(seconds: 30));
    return _legacyCompatible(response);
  }

  Future<http.Response> punchWithImage({
    required File image,
    required String punchAction,
    required double latitude,
    required double longitude,
    required String address,
    String? remark,
    String? firstImei,
    String? secondImei,
    String? macAddress,
    String? deviceInstallationId,
    double accuracyMeters = 50,
    String? clientEventId,
  }) async {
    final eventId = clientEventId ?? _foundation.newRequestId();
    final uri = Uri.parse(
      '${ApiDetails.server}${ApiDetails.mobileOdPunchSelfie}',
    );
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(await _headers(eventId));
    request.fields['metadata'] = jsonEncode(
      _metadata(
        eventId: eventId,
        punchAction: punchAction,
        latitude: latitude,
        longitude: longitude,
        accuracyMeters: accuracyMeters,
        address: address,
        remark: remark,
        firstImei: firstImei,
        secondImei: secondImei,
        macAddress: macAddress,
        deviceInstallationId: await _foundation.installationId(
          supplied: deviceInstallationId,
        ),
      ),
    );
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        image.path,
        contentType: _imageContentType(image),
      ),
    );

    final streamed = await MobileHttpClient.instance
        .send(request)
        .timeout(const Duration(seconds: 45));
    final response = await http.Response.fromStream(streamed);
    return _legacyCompatible(response);
  }

  Future<http.Response> punchFieldVisit({
    required File selfie,
    required File supportingDocument,
    required String punchAction,
    required double latitude,
    required double longitude,
    required String address,
    required String remark,
    String? clientName,
    String? clientContact,
    double accuracyMeters = 50,
    String? clientEventId,
  }) async {
    final eventId = clientEventId ?? _foundation.newRequestId();
    final uri = Uri.parse(
      '${ApiDetails.server}${ApiDetails.mobileOdFieldVisitPunch}',
    );
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(await _headers(eventId));
    request.fields['metadata'] = jsonEncode(
      _metadata(
        eventId: eventId,
        punchAction: punchAction,
        latitude: latitude,
        longitude: longitude,
        accuracyMeters: accuracyMeters,
        address: address,
        remark: remark,
        deviceInstallationId: await _foundation.installationId(),
        extraPayload: <String, Object?>{
          'source': 'OD',
          'workflowVariant': 'FIELD_VISIT',
          'clientName': clientName?.trim(),
          'clientContact': clientContact?.trim(),
        },
      ),
    );
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        selfie.path,
        contentType: _imageContentType(selfie),
      ),
    );
    request.files.add(
      await http.MultipartFile.fromPath(
        'supportingDocument',
        supportingDocument.path,
        contentType: _documentContentType(supportingDocument),
      ),
    );

    final streamed = await MobileHttpClient.instance
        .send(request)
        .timeout(const Duration(seconds: 120));
    return _legacyCompatible(await http.Response.fromStream(streamed));
  }

  Map<String, Object?> _metadata({
    required String eventId,
    required String punchAction,
    required double latitude,
    required double longitude,
    required double accuracyMeters,
    required String address,
    required String deviceInstallationId,
    String? remark,
    String? firstImei,
    String? secondImei,
    String? macAddress,
    Map<String, Object?>? extraPayload,
  }) => <String, Object?>{
    'clientEventId': eventId,
    'punchAction': punchAction.trim().toUpperCase(),
    'capturedAt': _foundation.offsetIso8601(DateTime.now()),
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
    'remark': remark,
    'firstImei': firstImei,
    'secondImei': secondImei,
    'macAddress': macAddress,
    'extraPayload': extraPayload ?? <String, Object?>{'source': 'OD'},
  };

  Future<Map<String, String>> _headers(String eventId) async {
    final token = await _sessionManager.getAccessToken();
    final tokenType = await _sessionManager.getTokenType() ?? 'Bearer';
    final sessionId = await _sessionManager.getMobileSessionId();
    if (token == null || token.isEmpty) {
      throw const OdPunchException('AUTHENTICATION_REQUIRED');
    }
    return <String, String>{
      'Authorization': '$tokenType $token',
      if (sessionId != null && sessionId.isNotEmpty)
        'X-Mobile-Session-Id': sessionId,
      'X-Request-ID': eventId,
      'Idempotency-Key': eventId,
      'Accept': 'application/json',
      'ngrok-skip-browser-warning': 'true',
    };
  }

  MediaType _imageContentType(File image) {
    final path = image.path.toLowerCase();
    if (path.endsWith('.png')) return MediaType('image', 'png');
    return MediaType('image', 'jpeg');
  }

  MediaType _documentContentType(File document) {
    final path = document.path.toLowerCase();
    if (path.endsWith('.pdf')) return MediaType('application', 'pdf');
    if (path.endsWith('.png')) return MediaType('image', 'png');
    return MediaType('image', 'jpeg');
  }

  http.Response _legacyCompatible(http.Response response) {
    return _foundation.toLegacyResponse(
      response,
      successMessage: 'OD requisition submitted for approval',
      failureMessage: 'OD requisition submission failed',
    );
  }
}

class OdPunchException implements Exception {
  final String code;
  const OdPunchException(this.code);

  @override
  String toString() => code;
}
