import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../commanScreen/allAPIList.dart';
import 'mobile_api_foundation.dart';
import 'mobile_mss_dashboard_service.dart';

class MssAttendanceApprovalItem {
  const MssAttendanceApprovalItem(this.data);

  final Map<String, dynamic> data;

  int get id => _int(data['sourceId']);
  String get requestCode => _text(data['requestCode'], '#$id');
  String get requestType => _text(data['requestType'], 'Attendance');
  String get employeeName => _text(data['employeeName'], 'Employee');
  String get employeeCode => _text(data['employeeCode'], '');
  String get department => _text(data['department'], '');
  String get branch => _text(data['branch'], '');
  String get requestedFor => _text(data['requestedFor'], '');
  String get summary => _text(data['summary'], '');
  String get status => _text(data['status'], 'PENDING').toUpperCase();
  String get submittedAt => _text(data['submittedAt'], '');
  int get currentLevel => _int(data['currentLevel']);
  int get totalLevels => _int(data['totalLevels']);
  bool get hasAttachment => data['hasAttachment'] == true;

  factory MssAttendanceApprovalItem.fromJson(Map<String, dynamic> json) =>
      MssAttendanceApprovalItem(Map<String, dynamic>.from(json));
}

class MssAttendanceApprovalPage {
  const MssAttendanceApprovalPage({
    required this.items,
    required this.summary,
    required this.page,
    required this.totalPages,
    required this.totalElements,
    required this.last,
  });

  final List<MssAttendanceApprovalItem> items;
  final Map<String, int> summary;
  final int page;
  final int totalPages;
  final int totalElements;
  final bool last;

  factory MssAttendanceApprovalPage.fromJson(Map<String, dynamic> json) {
    final pagination = _map(json['pagination']);
    final summary = _map(json['summary']);
    final rawItems = json['content'] ?? json['items'] ?? json['list'];
    return MssAttendanceApprovalPage(
      items: (rawItems as List? ?? const [])
          .whereType<Map>()
          .map((item) => MssAttendanceApprovalItem.fromJson(_map(item)))
          .toList(),
      summary: <String, int>{
        for (final key in const [
          'total',
          'pending',
          'approved',
          'rejected',
          'actioned',
        ])
          key: _int(summary[key]),
      },
      page: _int(pagination['page']),
      totalPages: _int(pagination['totalPages']),
      totalElements: _int(pagination['totalElements']),
      last: pagination['last'] == true,
    );
  }
}

class MssAttendanceApprovalDetail {
  const MssAttendanceApprovalDetail(this.data);

  final Map<String, dynamic> data;

  MssAttendanceApprovalItem get item => MssAttendanceApprovalItem(data);
  List<Map<String, dynamic>> get history => (data['history'] as List? ?? const [])
      .whereType<Map>()
      .map(_map)
      .toList();
  List<Map<String, dynamic>> get attachments =>
      (data['attachments'] as List? ?? const [])
          .whereType<Map>()
          .map(_map)
          .toList();
  List<String> get availableActions =>
      (data['availableActions'] as List? ?? const [])
          .map((item) => item.toString().toUpperCase())
          .toList();
}

class MobileMssAttendanceApprovalService {
  MobileMssAttendanceApprovalService._();

  static final MobileApiFoundation _api = MobileApiFoundation.instance;

  static Future<MssAttendanceApprovalPage> list({
    required String tab,
    int page = 0,
    int size = 20,
    String sortBy = 'submittedAt',
    String direction = 'DESC',
    String? search,
    String? requestType,
    int? stage,
    String? branch,
  }) async {
    final headers = await _api.authHeaders(requestId: _api.newRequestId());
    final cacheKey = _listCacheKey(
      headers,
      tab: tab,
      page: page,
      size: size,
      sortBy: sortBy,
      direction: direction,
      search: search,
      requestType: requestType,
      stage: stage,
      branch: branch,
    );
    final cached = await MobileApiCache.instance.readJson(cacheKey);
    try {
      final response = await _api.get(
        ApiDetails.mobileMssAttendanceApprovals,
        queryParameters: <String, Object?>{
          'tab': tab,
          'page': page,
          'size': size,
          'sortBy': sortBy,
          'direction': direction,
          'search': search,
          'requestType': requestType,
          'stage': stage,
          'branch': branch,
        },
        headers: headers,
        timeout: const Duration(seconds: 30),
        tag: 'MSS_ATTENDANCE_APPROVAL_LIST',
      );
      final data = _data(response);
      await MobileApiCache.instance.saveJson(cacheKey, data);
      return MssAttendanceApprovalPage.fromJson(data);
    } catch (_) {
      if (cached != null) {
        return MssAttendanceApprovalPage.fromJson(cached.data);
      }
      rethrow;
    }
  }

  static String _listCacheKey(
    Map<String, String> headers, {
    required String tab,
    required int page,
    required int size,
    required String sortBy,
    required String direction,
    String? search,
    String? requestType,
    int? stage,
    String? branch,
  }) {
    final profile = headers['X-MSS-Profile-Id'] ?? '';
    final organisation = headers['X-MSS-Organisation-Id'] ?? '';
    final profileType = headers['X-MSS-Profile-Type'] ?? '';
    final generation = MobileMssDashboardService.refreshSignal.value;
    return <Object?>[
      'mssAttendanceApprovals',
      profileType,
      profile,
      organisation,
      tab,
      page,
      size,
      sortBy,
      direction,
      search ?? '',
      requestType ?? '',
      stage ?? '',
      branch ?? '',
      generation,
    ].join(':');
  }

  static Future<MssAttendanceApprovalDetail> detail(int requisitionId) async {
    final response = await _api.get(
      '${ApiDetails.mobileMssAttendanceApprovals}/$requisitionId',
      headers: await _api.authHeaders(requestId: _api.newRequestId()),
      tag: 'MSS_ATTENDANCE_APPROVAL_DETAIL',
    );
    return MssAttendanceApprovalDetail(_data(response));
  }

  static Future<void> action({
    required int requisitionId,
    required String action,
    String remarks = '',
  }) async {
    final requestId = _api.newRequestId();
    final response = await _api.postJson(
      '${ApiDetails.mobileMssAttendanceApprovals}/$requisitionId/actions',
      body: <String, Object?>{'action': action, 'remarks': remarks},
      headers: await _api.authHeaders(requestId: requestId, json: true),
      tag: 'MSS_ATTENDANCE_APPROVAL_ACTION',
    );
    _data(response);
    MobileMssDashboardService.invalidate();
  }

  static Future<String> downloadAttachment(int requisitionId) async {
    final response = await _api.get(
      '${ApiDetails.mobileMssAttendanceApprovals}/$requisitionId/attachment',
      headers: await _api.authHeaders(requestId: _api.newRequestId()),
      timeout: MobileApiFoundation.uploadTimeout,
      tag: 'MSS_ATTENDANCE_ATTACHMENT',
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw MobileApiException(
        'MSS_ATTENDANCE_ATTACHMENT_FAILED',
        message: 'Unable to download supporting document',
        statusCode: response.statusCode,
      );
    }
    final disposition = response.headers['content-disposition'] ?? '';
    final match = RegExp(
      r'''filename\*?=(?:UTF-8'')?["']?([^"';]+)''',
    ).firstMatch(disposition);
    final rawName = Uri.decodeComponent(match?.group(1) ?? 'attendance-attachment-$requisitionId');
    final fileName = rawName.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}${Platform.pathSeparator}$fileName');
    await file.writeAsBytes(response.bodyBytes, flush: true);
    return file.path;
  }

  static Map<String, dynamic> _data(http.Response response) {
    Map<String, dynamic> decoded;
    try {
      final value = jsonDecode(response.body);
      decoded = value is Map ? _map(value) : <String, dynamic>{};
    } catch (_) {
      decoded = <String, dynamic>{};
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final error = _map(_map(decoded['data'])['error']);
      throw MobileApiException(
        _text(error['code'], 'MSS_ATTENDANCE_APPROVAL_FAILED'),
        message: _text(decoded['message'], 'Unable to process attendance approval'),
        statusCode: response.statusCode,
      );
    }
    final data = decoded['data'];
    if (data is! Map) {
      throw const MobileApiException(
        'INVALID_MSS_ATTENDANCE_RESPONSE',
        message: 'Invalid attendance approval response',
      );
    }
    return _map(data);
  }
}

Map<String, dynamic> _map(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};

int _int(dynamic value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String _text(dynamic value, String fallback) {
  final text = value?.toString().trim() ?? '';
  return text.isEmpty ? fallback : text;
}
