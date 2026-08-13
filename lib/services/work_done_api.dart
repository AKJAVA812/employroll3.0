import 'dart:convert';
import 'dart:io';

import 'package:er_flutter_project/commanScreen/allAPIList.dart';
import 'package:er_flutter_project/services/mobile_api_foundation.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'package:er_flutter_project/sharedPrefancePage/ShardPre.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class WorkDoneApi {
  WorkDoneApi({SessionManager? sessionManager})
    : _sessionManager = sessionManager ?? SessionManager() {
    _foundation = MobileApiFoundation(sessionManager: _sessionManager);
  }

  final SessionManager _sessionManager;
  late final MobileApiFoundation _foundation;

  Future<http.Response> submit({
    required File image,
    required double latitude,
    required double longitude,
    required String address,
    required String taskDetails,
    String taskDone = 'DONE',
    String? clientName,
    String? contactNumber,
    String? emailId,
    String? organisationName,
    Map<String, Object?>? extraPayload,
    double accuracyMeters = 50,
    String? clientEventId,
  }) async {
    final eventId = clientEventId ?? _foundation.newRequestId();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiDetails.server}${ApiDetails.mobileWorkDone}'),
    );
    request.headers.addAll(await _headers(eventId));
    request.fields['metadata'] = jsonEncode(<String, Object?>{
      'clientEventId': eventId,
      'taskTime': _foundation.offsetIso8601(DateTime.now()),
      'taskDone': taskDone.trim().toUpperCase(),
      'taskDetails': taskDetails,
      'location': <String, Object?>{
        'latitude': latitude,
        'longitude': longitude,
        'accuracyMeters': accuracyMeters,
        'address': address,
      },
      'device': <String, Object?>{
        'installationId': await _foundation.installationId(),
        'platform': Platform.isIOS ? 'IOS' : 'ANDROID',
      },
      'customer': <String, Object?>{
        'name': clientName,
        'contactNumber': contactNumber,
        'emailId': emailId,
        'organisationName': organisationName,
      },
      if (extraPayload != null) 'extraPayload': extraPayload,
    });
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        image.path,
        contentType: _imageContentType(image),
      ),
    );

    print('[MOBILE-WORKDONE] SUBMIT -> POST ${request.url}');
    print(
      '[MOBILE-WORKDONE] SUBMIT headers -> tokenPresent=${request.headers['Authorization']?.isNotEmpty == true} sessionPresent=${request.headers['X-Mobile-Session-Id']?.isNotEmpty == true} requestId=$eventId',
    );
    print('[MOBILE-WORKDONE] SUBMIT fields -> ${request.fields['metadata']}');
    print(
      '[MOBILE-WORKDONE] SUBMIT file -> path=${image.path} contentType=${_imageContentType(image)}',
    );
    final streamed = await MobileHttpClient.instance
        .send(request)
        .timeout(const Duration(seconds: 45));
    final response = await http.Response.fromStream(streamed);
    print(
      '[MOBILE-WORKDONE] SUBMIT <- status=${response.statusCode} body=${response.body}',
    );
    return _legacyCompatible(response);
  }

  Future<Map<String, String>> _headers(String eventId) async {
    final token = await _sessionManager.getAccessToken();
    final tokenType = await _sessionManager.getTokenType() ?? 'Bearer';
    final sessionId = await _sessionManager.getMobileSessionId();
    if (token == null || token.isEmpty) {
      throw const WorkDoneException('AUTHENTICATION_REQUIRED');
    }
    print(
      '[MOBILE-WORKDONE] headers -> tokenPresent=${token.isNotEmpty} '
      'sessionPresent=${sessionId != null && sessionId.isNotEmpty}',
    );
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

  http.Response _legacyCompatible(http.Response response) {
    return _foundation.toLegacyResponse(
      response,
      successMessage: 'Work done submitted successfully',
      failureMessage: 'Work done failed',
    );
  }
}

class WorkDoneException implements Exception {
  final String code;
  const WorkDoneException(this.code);

  @override
  String toString() => code;
}
