import 'dart:convert';

import '../commanScreen/allAPIList.dart';
import 'mobile_api_foundation.dart';
import 'mobile_mss_dashboard_service.dart';

class MssLifecyclePage {
  const MssLifecyclePage({required this.items, required this.summary, required this.last});
  final List<Map<String, dynamic>> items;
  final Map<String, int> summary;
  final bool last;
}

class MobileMssLifecycleService {
  MobileMssLifecycleService._();
  static final MobileApiFoundation _api = MobileApiFoundation.instance;

  static Future<MssLifecyclePage> list({
    required String module,
    required String tab,
    int page = 0,
    String? search,
  }) async {
    final response = await _api.get(
      '${ApiDetails.mobileMssLifecycle}/${module.toLowerCase()}',
      queryParameters: {'tab': tab, 'page': page, 'size': 20, 'search': search},
      headers: await _api.authHeaders(requestId: _api.newRequestId()),
      tag: 'MSS_${module}_LIST',
    );
    final data = _data(response.body, response.statusCode);
    final pagination = _map(data['pagination']);
    return MssLifecyclePage(
      items: (data['content'] as List? ?? const [])
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList(),
      summary: _map(data['summary']).map((key, value) => MapEntry(key, _int(value))),
      last: pagination['last'] != false,
    );
  }

  static Future<Map<String, dynamic>> detail(String module, int requestId) async {
    final response = await _api.get(
      '${ApiDetails.mobileMssLifecycle}/${module.toLowerCase()}/$requestId',
      headers: await _api.authHeaders(requestId: _api.newRequestId()),
      tag: 'MSS_${module}_DETAIL',
    );
    return _data(response.body, response.statusCode);
  }

  static Future<MssLifecyclePage> exitEmployees({
    int page = 0,
    String? search,
  }) async {
    final response = await _api.get(
      '${ApiDetails.mobileMssLifecycle}/exit-employees',
      queryParameters: {'page': page, 'size': 20, 'search': search},
      headers: await _api.authHeaders(requestId: _api.newRequestId()),
      tag: 'MSS_EXIT_EMPLOYEES',
    );
    final data = _data(response.body, response.statusCode);
    final pagination = _map(data['pagination']);
    return MssLifecyclePage(
      items: (data['content'] as List? ?? const [])
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList(),
      summary: _map(data['summary']).map((key, value) => MapEntry(key, _int(value))),
      last: pagination['last'] != false,
    );
  }

  static Future<Map<String, dynamic>> exitEmployeeDetail(int caseId) async {
    final response = await _api.get(
      '${ApiDetails.mobileMssLifecycle}/exit-employees/$caseId',
      headers: await _api.authHeaders(requestId: _api.newRequestId()),
      tag: 'MSS_EXIT_EMPLOYEE_DETAIL',
    );
    return _data(response.body, response.statusCode);
  }

  static Future<void> decide({
    required String module,
    required int requestId,
    required String decision,
    required String remarks,
  }) async {
    final requestIdHeader = _api.newRequestId();
    final response = await _api.postJson(
      '${ApiDetails.mobileMssLifecycle}/${module.toLowerCase()}/$requestId/decision',
      body: {'decision': decision, 'remarks': remarks},
      headers: await _api.authHeaders(requestId: requestIdHeader, json: true),
      tag: 'MSS_${module}_DECISION',
    );
    _data(response.body, response.statusCode);
    MobileMssDashboardService.invalidate();
  }

  static Map<String, dynamic> _data(String body, int statusCode) {
    Map<String, dynamic> decoded = {};
    try {
      final value = jsonDecode(body);
      if (value is Map) decoded = Map<String, dynamic>.from(value);
    } catch (_) {}
    if (statusCode < 200 || statusCode >= 300) {
      final error = _map(_map(decoded['data'])['error']);
      throw MobileApiException(
        (error['code'] ?? 'MSS_LIFECYCLE_REQUEST_FAILED').toString(),
        message: (decoded['message'] ?? 'Unable to load lifecycle requests').toString(),
        statusCode: statusCode,
      );
    }
    final data = decoded['data'];
    if (data is! Map) {
      throw const MobileApiException('INVALID_MSS_LIFECYCLE_RESPONSE');
    }
    return Map<String, dynamic>.from(data);
  }
}

Map<String, dynamic> _map(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};

int _int(dynamic value) => value is num ? value.toInt() : int.tryParse('$value') ?? 0;
