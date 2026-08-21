import 'dart:convert';

import 'package:http/http.dart' as http;

import '../commanScreen/allAPIList.dart';
import '../sharedPrefancePage/ShardPre.dart';
import 'mobile_api_foundation.dart';
import 'mobile_mo_organisation_service.dart';
import 'mobile_mss_dashboard_service.dart';
import 'mobile_panel_service.dart';

class MssRequisitionItem {
  const MssRequisitionItem(this.data);

  final Map<String, dynamic> data;

  String get requestId => _text(data['requestId'], '');
  String get requestCode => _text(data['requestCode'], requestId);
  String get module => _text(data['module'], '');
  String get requestType => _text(data['requestType'], module);
  String get employeeName => _text(data['employeeName'], 'Employee');
  String get employeeCode => _text(data['employeeCode'], '');
  String get department => _text(data['department'], '');
  String get branch => _text(data['branch'], '');
  String get requestedFor => _text(data['requestedFor'], '');
  String get summary => _text(data['summary'], '');
  String get status => _text(data['status'], 'PENDING').toUpperCase();
  int get currentLevel => _int(data['currentLevel']);
  int get totalLevels => _int(data['totalLevels']);
}

class MssRequisitionPage {
  const MssRequisitionPage({
    required this.items,
    required this.summary,
    required this.page,
    required this.last,
  });

  final List<MssRequisitionItem> items;
  final Map<String, int> summary;
  final int page;
  final bool last;

  factory MssRequisitionPage.fromJson(Map<String, dynamic> json) {
    final summary = _map(json['summary']);
    final pagination = _map(json['pagination']);
    return MssRequisitionPage(
      items: (json['content'] as List? ?? const [])
          .whereType<Map>()
          .map((item) => MssRequisitionItem(_map(item)))
          .toList(),
      summary: <String, int>{
        for (final key in const ['total', 'pending', 'approved', 'rejected', 'actioned'])
          key: _int(summary[key]),
      },
      page: _int(pagination['page']),
      last: pagination['last'] == true,
    );
  }
}

class MssRequisitionDetail {
  const MssRequisitionDetail({required this.data, required this.history});

  final Map<String, dynamic> data;
  final List<Map<String, dynamic>> history;

  MssRequisitionItem get item => MssRequisitionItem(data);
  List<String> get availableDecisions =>
      (data['availableDecisions'] as List? ?? const [])
          .map((value) => value.toString().toUpperCase())
          .toList();
}

class MobileMssRequisitionService {
  MobileMssRequisitionService._();

  static final MobileApiFoundation _api = MobileApiFoundation.instance;
  static final SessionManager _shared = SessionManager();
  static final Map<String, MssRequisitionPage> _listCache =
      <String, MssRequisitionPage>{};

  static Future<void> _ensureActiveContext() async {
    final activePanel = await _shared.getActivePanel();
    final profileType = activePanel ?? await _shared.getDefaultProfileType();
    final profileId = await _shared.getDefaultProfileId() ?? 0;
    if (profileType == MobilePanel.mssMo) {
      await MobileMoOrganisationService.loadForActivePanel();
    }
    var organisationId = await _shared.getActiveOrgId();
    organisationId ??= await _shared.getOrgId();
    if ((organisationId ?? 0) > 0 && await _shared.getActiveOrgId() == null) {
      await _shared.setActiveOrgId(organisationId!);
    }
    if (profileId <= 0 || (organisationId ?? 0) <= 0 ||
        (profileType != MobilePanel.mss && profileType != MobilePanel.mssMo)) {
      throw const MobileApiException(
        'MSS_CONTEXT_NOT_READY',
        message: 'MSS profile and organisation context is not ready. Please retry.',
        retryable: true,
      );
    }
  }

  static Future<MssRequisitionPage> list({
    required String module,
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
    await _ensureActiveContext();
    final query = <String, Object?>{
      'module': module,
      'tab': tab,
      'page': page,
      'size': size,
      'sortBy': sortBy,
      'direction': direction,
      'search': search,
      'requestType': requestType,
      'stage': stage,
      'branch': branch,
    };
    final headers = await _api.authHeaders(requestId: _api.newRequestId());
    final cacheKey = _listCacheKey(
      headers,
      module: module,
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
    try {
      final response = await _api.get(
          ApiDetails.mobileMssRequisitions,
          queryParameters: query,
          headers: headers,
          timeout: const Duration(seconds: 30),
          tag: 'MSS_${module}_REQUISITION_LIST',
        );
      final pageData = MssRequisitionPage.fromJson(_data(response));
      _listCache[cacheKey] = pageData;
      return pageData;
    } on MobileApiException catch (error) {
      final cached = _listCache[cacheKey];
      if (cached != null &&
          (error.retryable ||
              error.statusCode == 502 ||
              error.statusCode == 503 ||
              error.statusCode == 504)) {
        return cached;
      }
      rethrow;
    }
  }

  static String _listCacheKey(
    Map<String, String> headers, {
    required String module,
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
    final tokenScope = (headers['Authorization'] ?? '').hashCode;
    return <Object?>[
      'mssRequisitions',
      tokenScope,
      headers['X-MSS-Profile-Type'] ?? '',
      headers['X-MSS-Profile-Id'] ?? '',
      headers['X-MSS-Organisation-Id'] ?? '',
      module,
      tab,
      page,
      size,
      sortBy,
      direction,
      search ?? '',
      requestType ?? '',
      stage ?? '',
      branch ?? '',
      MobileMssDashboardService.refreshSignal.value,
    ].join(':');
  }

  static Future<MssRequisitionDetail> detail(String requestId) async {
    await _ensureActiveContext();
    final headers = await _api.authHeaders(requestId: _api.newRequestId());
    final responses = await Future.wait([
      _api.get(
        '${ApiDetails.mobileMssRequisitions}/$requestId',
        headers: headers,
        tag: 'MSS_REQUISITION_DETAIL',
      ),
      _api.get(
        '${ApiDetails.mobileMssRequisitions}/$requestId/history',
        headers: headers,
        tag: 'MSS_REQUISITION_HISTORY',
      ),
    ]);
    final detail = _data(responses[0]);
    final historyData = _data(responses[1]);
    final history = (historyData['history'] as List? ?? const [])
        .whereType<Map>()
        .map(_map)
        .toList();
    return MssRequisitionDetail(data: detail, history: history);
  }

  static Future<void> decision({
    required String requestId,
    required String decision,
    String remarks = '',
  }) async {
    await _ensureActiveContext();
    final requestKey = _api.newRequestId();
    final response = await _api.postJson(
      '${ApiDetails.mobileMssRequisitions}/$requestId/decision',
      body: <String, Object?>{'decision': decision, 'remarks': remarks},
      headers: await _api.authHeaders(requestId: requestKey, json: true),
      tag: 'MSS_REQUISITION_DECISION',
    );
    _data(response);
    MobileMssDashboardService.invalidate();
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
        _text(error['code'], 'MSS_REQUISITION_FAILED'),
        message: _text(decoded['message'], 'Unable to process MSS requisition'),
        statusCode: response.statusCode,
      );
    }
    final data = decoded['data'];
    if (data is! Map) {
      throw const MobileApiException(
        'INVALID_MSS_REQUISITION_RESPONSE',
        message: 'Invalid MSS requisition response',
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
