import 'package:er_flutter_project/commanScreen/allAPIList.dart';
import 'package:er_flutter_project/services/mobile_api_foundation.dart';

class EmployeeProfileApi {
  EmployeeProfileApi({MobileApiFoundation? foundation})
    : _foundation = foundation ?? MobileApiFoundation.instance;

  final MobileApiFoundation _foundation;

  Future<EmployeeProfileResult> getDetails() async {
    final requestId = _foundation.newRequestId();
    final headers = await _foundation.authHeaders(requestId: requestId);
    EmployeeProfileException? lastError;

    for (var attempt = 1; attempt <= 3; attempt++) {
      final response = await _foundation.get(
        ApiDetails.mobileProfileDetails,
        headers: headers,
        tag: 'EMPLOYEE_PROFILE_DETAILS',
      );
      try {
        final body = _decodeResponse(response.body);
        if (!_isSuccess(response.statusCode, body)) {
          final error = EmployeeProfileException(
            _message(body, 'Unable to load profile'),
          );
          if (response.statusCode < 500 || attempt == 3) throw error;
          lastError = error;
        } else {
          return EmployeeProfileResult.fromJson(body);
        }
      } on EmployeeProfileException catch (error) {
        lastError = error;
        if (attempt == 3 || !_isGatewayError(error.message)) rethrow;
      }
      await Future<void>.delayed(Duration(milliseconds: 400 * attempt));
    }
    throw lastError ?? const EmployeeProfileException('Unable to load profile');
  }

  Future<String> submitUpdate(EmployeeProfileUpdate update) async {
    final requestId = _foundation.newRequestId();
    final response = await _foundation.postJson(
      ApiDetails.mobileProfileUpdateRequests,
      body: update.toJson(),
      headers: await _foundation.authHeaders(
        requestId: requestId,
        json: true,
      ),
      tag: 'EMPLOYEE_PROFILE_UPDATE',
    );
    final body = _decodeResponse(response.body);
    if (!_isSuccess(response.statusCode, body)) {
      throw EmployeeProfileException(
        _message(body, 'Unable to submit profile update request'),
      );
    }
    return _message(body, 'Profile update request submitted');
  }

  Map<String, dynamic> _decodeResponse(String responseBody) {
    final raw = responseBody.trim();
    if (raw.isEmpty) {
      throw const EmployeeProfileException(
        'Profile service returned an empty response. Please retry.',
      );
    }
    try {
      final body = _foundation.decodeMap(raw);
      final data = body['data'];
      if (body.length == 1 && data is String) {
        throw EmployeeProfileException(_plainResponseMessage(data));
      }
      final gatewayText = <Object?>[
        body['error_code'],
        body['errorCode'],
        body['msg'],
        body['message'],
      ].whereType<Object>().join(' ');
      if (_isGatewayError(gatewayText)) {
        throw EmployeeProfileException(_plainResponseMessage(gatewayText));
      }
      return body;
    } on EmployeeProfileException {
      rethrow;
    } on FormatException {
      throw EmployeeProfileException(_plainResponseMessage(raw));
    }
  }

  bool _isSuccess(int statusCode, Map<String, dynamic> body) {
    if (statusCode < 200 || statusCode >= 300 || body['success'] == false) {
      return false;
    }
    final status = (body['status'] ?? body['result'])
        ?.toString()
        .trim()
        .toLowerCase();
    return status == null ||
        status.isEmpty ||
        status == 'success' ||
        status == 'ok';
  }

  String _plainResponseMessage(String raw) {
    if (_isGatewayError(raw)) {
      return 'Temporary gateway error while loading profile. Please retry.';
    }
    return 'Profile service returned an invalid response. Please retry.';
  }

  bool _isGatewayError(String value) {
    final text = value.toLowerCase();
    return text.contains('ngrok') ||
        text.contains('gateway') ||
        text.contains('tunnel');
  }

  String _message(Map<String, dynamic> body, String fallback) {
    final direct = body['message']?.toString().trim();
    if (direct != null && direct.isNotEmpty) return direct;
    final detail = body['detail']?.toString().trim();
    if (detail != null && detail.isNotEmpty) return detail;
    final error = body['error'];
    if (error is Map) {
      final nested = error['message']?.toString().trim();
      if (nested != null && nested.isNotEmpty) return nested;
    }
    return fallback;
  }
}

class EmployeeProfileResult {
  const EmployeeProfileResult({
    required this.details,
    required this.pendingRequest,
  });

  final EmployeeProfileDetails details;
  final EmployeeProfilePendingRequest? pendingRequest;

  factory EmployeeProfileResult.fromJson(Map<String, dynamic> json) {
    final detailsJson = _map(json['details']).isNotEmpty
        ? _map(json['details'])
        : _map(json['data']);
    final pendingJson = _map(json['pendingRequest']);
    return EmployeeProfileResult(
      details: EmployeeProfileDetails.fromJson(detailsJson),
      pendingRequest: pendingJson.isEmpty
          ? null
          : EmployeeProfilePendingRequest.fromJson(pendingJson),
    );
  }
}

class EmployeeProfileDetails {
  const EmployeeProfileDetails({
    required this.dateOfBirth,
    required this.dateOfJoining,
    required this.aadharCardNumber,
    required this.pfNumber,
    required this.uanNumber,
    required this.esicNumber,
    required this.accountHolderName,
    required this.bankAccountNo,
    required this.bankIfsc,
    required this.bankName,
  });

  final String dateOfBirth;
  final String dateOfJoining;
  final String aadharCardNumber;
  final String pfNumber;
  final String uanNumber;
  final String esicNumber;
  final String accountHolderName;
  final String bankAccountNo;
  final String bankIfsc;
  final String bankName;

  factory EmployeeProfileDetails.fromJson(Map<String, dynamic> json) {
    String value(String key) => json[key]?.toString().trim() ?? '';
    return EmployeeProfileDetails(
      dateOfBirth: value('dateOfBirth'),
      dateOfJoining: value('dateOfJoining'),
      aadharCardNumber: value('aadharCardNumber'),
      pfNumber: value('pfNumber'),
      uanNumber: value('uanNumber'),
      esicNumber: value('esicNumber'),
      accountHolderName: value('accountHolderName'),
      bankAccountNo: value('bankAccountNo'),
      bankIfsc: value('bankIfsc'),
      bankName: value('bankName'),
    );
  }
}

class EmployeeProfilePendingRequest {
  const EmployeeProfilePendingRequest({
    required this.requestId,
    required this.status,
    required this.approverName,
    required this.current,
    required this.proposed,
    required this.employeeRemarks,
    required this.requestedAt,
  });

  final String requestId;
  final String status;
  final String approverName;
  final EmployeeProfileDetails current;
  final EmployeeProfileDetails proposed;
  final String employeeRemarks;
  final String requestedAt;

  factory EmployeeProfilePendingRequest.fromJson(Map<String, dynamic> json) {
    return EmployeeProfilePendingRequest(
      requestId: json['requestId']?.toString() ?? '',
      status: json['status']?.toString() ?? 'PENDING',
      approverName: json['approverName']?.toString().trim() ?? '',
      current: EmployeeProfileDetails.fromJson(_map(json['current'])),
      proposed: EmployeeProfileDetails.fromJson(_map(json['proposed'])),
      employeeRemarks: json['employeeRemarks']?.toString().trim() ?? '',
      requestedAt: json['requestedAt']?.toString().trim() ?? '',
    );
  }
}

class EmployeeProfileUpdate {
  const EmployeeProfileUpdate({
    required this.dateOfBirth,
    required this.accountHolderName,
    required this.bankAccountNo,
    required this.bankIfsc,
    required this.bankName,
    required this.remarks,
  });

  final String dateOfBirth;
  final String accountHolderName;
  final String bankAccountNo;
  final String bankIfsc;
  final String bankName;
  final String remarks;

  Map<String, Object?> toJson() => <String, Object?>{
    if (dateOfBirth.isNotEmpty) 'dateOfBirth': dateOfBirth,
    'accountHolderName': accountHolderName,
    'bankAccountNo': bankAccountNo,
    'bankIfsc': bankIfsc.toUpperCase(),
    'bankName': bankName,
    'remarks': remarks,
  };
}

class EmployeeProfileException implements Exception {
  const EmployeeProfileException(this.message);
  final String message;

  @override
  String toString() => message;
}

Map<String, dynamic> _map(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, item) => MapEntry(key.toString(), item));
  }
  return <String, dynamic>{};
}
