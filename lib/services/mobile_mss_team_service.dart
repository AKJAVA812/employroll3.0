import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../commanScreen/allAPIList.dart';
import 'mobile_api_foundation.dart';

class MssTeamOption {
  const MssTeamOption({required this.id, required this.label});

  final int id;
  final String label;

  factory MssTeamOption.fromJson(Map<String, dynamic> json) => MssTeamOption(
        id: _int(json['id']),
        label: _text(json['label'], ''),
      );
}

class MssTeamEmployee {
  const MssTeamEmployee(this.data);

  final Map<String, dynamic> data;

  int get id => _int(data['employeeDetailsId']);
  String get code => _text(data['employeeCode'], '');
  String get name => _text(data['employeeName'], 'Employee');
  String get photo => _text(data['photo'], '');
  String get relation => _text(data['relation'], 'ASSIGNED');
  String get branch => _text(data['branch'], '');
  String get department => _text(data['department'], '');
  String get designation => _text(data['designation'], '');
  String get employmentType => _text(data['employmentType'], '');
  String get dateOfJoining => _text(data['dateOfJoining'], '');
}

class MssTeamFilters {
  const MssTeamFilters({
    required this.branches,
    required this.departments,
    required this.designations,
    required this.relations,
  });

  final List<MssTeamOption> branches;
  final List<MssTeamOption> departments;
  final List<MssTeamOption> designations;
  final List<String> relations;

  factory MssTeamFilters.fromJson(Map<String, dynamic> json) => MssTeamFilters(
        branches: _options(json['branches']),
        departments: _options(json['departments']),
        designations: _options(json['designations']),
        relations: (json['relations'] as List? ?? const [])
            .map((value) => value.toString())
            .toList(),
      );
}

class MssTeamPage {
  const MssTeamPage({
    required this.items,
    required this.summary,
    required this.filters,
    required this.page,
    required this.last,
  });

  final List<MssTeamEmployee> items;
  final Map<String, int> summary;
  final MssTeamFilters filters;
  final int page;
  final bool last;

  factory MssTeamPage.fromJson(Map<String, dynamic> json) {
    final summary = _map(json['summary']);
    final pagination = _map(json['pagination']);
    return MssTeamPage(
      items: (json['content'] as List? ?? const [])
          .whereType<Map>()
          .map((item) => MssTeamEmployee(_map(item)))
          .toList(),
      summary: {
        for (final key in const [
          'total',
          'direct',
          'dotted',
          'designated',
          'sharedServices',
          'branches',
          'departments',
        ])
          key: _int(summary[key]),
      },
      filters: MssTeamFilters.fromJson(_map(json['filters'])),
      page: _int(pagination['page']),
      last: pagination['last'] == true,
    );
  }
}

class MssTeamAttendance {
  const MssTeamAttendance({
    required this.summary,
    required this.days,
    required this.fromDate,
    required this.toDate,
  });

  final Map<String, dynamic> summary;
  final List<Map<String, dynamic>> days;
  final String fromDate;
  final String toDate;

  factory MssTeamAttendance.fromJson(Map<String, dynamic> json) =>
      MssTeamAttendance(
        summary: _map(json['summary']),
        days: (json['days'] as List? ?? const [])
            .whereType<Map>()
            .map(_map)
            .toList(),
        fromDate: _text(json['fromDate'], ''),
        toDate: _text(json['toDate'], ''),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'summary': summary,
        'days': days,
        'fromDate': fromDate,
        'toDate': toDate,
      };
}

class MobileMssTeamService {
  MobileMssTeamService._();

  static final MobileApiFoundation _api = MobileApiFoundation.instance;
  static final Map<String, Future<int>> _countLoads = {};
  static final ValueNotifier<int> countRefreshSignal = ValueNotifier<int>(0);

  static Future<int> employeeCount() async {
    final scope = await _scope();
    final prefs = await SharedPreferences.getInstance();
    final key = 'mobile_mss_team_count_$scope';
    final cached = prefs.getInt(key);
    if (cached != null) {
      _refreshEmployeeCountInBackground(scope, key);
      return cached;
    }
    return _refreshEmployeeCount(scope, key);
  }

  static void _refreshEmployeeCountInBackground(
    String scope,
    String key,
  ) async {
    try {
      await _refreshEmployeeCount(scope, key);
    } catch (error) {
      debugPrint('[MSS-TEAM] Employee count refresh failed: $error');
    }
  }

  static Future<int> _refreshEmployeeCount(String scope, String key) {
    final running = _countLoads[scope];
    if (running != null) return running;
    final load = (() async {
      final page = await employees(page: 0, size: 1);
      final count = page.summary['total'] ?? 0;
      final prefs = await SharedPreferences.getInstance();
      final previous = prefs.getInt(key);
      await prefs.setInt(key, count);
      if (previous != null && previous != count) countRefreshSignal.value++;
      return count;
    })();
    _countLoads[scope] = load;
    return load.whenComplete(() {
      if (identical(_countLoads[scope], load)) _countLoads.remove(scope);
    });
  }

  static Future<MssTeamPage> employees({
    int page = 0,
    int size = 20,
    String sortBy = 'employeeName',
    String direction = 'ASC',
    String? search,
    int? branchId,
    int? departmentId,
    int? designationId,
    String? relation,
  }) async {
    final response = await _api.get(
      '${ApiDetails.mobileMssTeam}/employees',
      queryParameters: {
        'page': page,
        'size': size,
        'sortBy': sortBy,
        'direction': direction,
        'search': search,
        'branchId': branchId,
        'departmentId': departmentId,
        'designationId': designationId,
        'relation': relation,
      },
      headers: await _api.authHeaders(requestId: _api.newRequestId()),
      tag: 'MSS_TEAM_EMPLOYEES',
    );
    return MssTeamPage.fromJson(_data(response));
  }

  static Future<Map<String, dynamic>> employee(int employeeDetailsId) async {
    final response = await _api.get(
      '${ApiDetails.mobileMssTeam}/employees/$employeeDetailsId',
      headers: await _api.authHeaders(requestId: _api.newRequestId()),
      tag: 'MSS_TEAM_EMPLOYEE_DETAIL',
    );
    return _map(_data(response)['employee']);
  }

  static Future<MssTeamAttendance> attendance({
    required int employeeDetailsId,
    required DateTime month,
  }) async {
    final fromDate = DateTime(month.year, month.month, 1);
    final toDate = DateTime(month.year, month.month + 1, 0);
    final response = await _api.get(
      '${ApiDetails.mobileMssTeam}/employees/$employeeDetailsId/attendance-summary',
      queryParameters: {
        'fromDate': _date(fromDate),
        'toDate': _date(toDate),
      },
      headers: await _api.authHeaders(requestId: _api.newRequestId()),
      timeout: const Duration(seconds: 30),
      tag: 'MSS_TEAM_EMPLOYEE_ATTENDANCE',
    );
    final attendance = MssTeamAttendance.fromJson(_data(response));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      await _attendanceCacheKey(employeeDetailsId, month),
      jsonEncode(attendance.toJson()),
    );
    return attendance;
  }

  static Future<MssTeamAttendance?> cachedAttendance({
    required int employeeDetailsId,
    required DateTime month,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(
      await _attendanceCacheKey(employeeDetailsId, month),
    );
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map
          ? MssTeamAttendance.fromJson(Map<String, dynamic>.from(decoded))
          : null;
    } catch (_) {
      return null;
    }
  }

  static Future<String> _attendanceCacheKey(
    int employeeDetailsId,
    DateTime month,
  ) async {
    final monthKey =
        '${month.year}-${month.month.toString().padLeft(2, '0')}';
    return 'mobile_mss_team_attendance_${await _scope()}_${employeeDetailsId}_$monthKey';
  }

  static Future<String> _scope() async {
    final prefs = await SharedPreferences.getInstance();
    final panel = prefs.getString('activePanel') ?? 'MSS';
    final profileId = prefs.getInt('profileIdNew') ?? 0;
    final organisationId = prefs.getInt('activeOrgId') ?? 0;
    return '$panel:$profileId:$organisationId';
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
        _text(error['code'], 'MSS_TEAM_REQUEST_FAILED'),
        message: _text(decoded['message'], 'Unable to load team data'),
        statusCode: response.statusCode,
      );
    }
    final data = decoded['data'];
    if (data is! Map) {
      throw const MobileApiException(
        'INVALID_MSS_TEAM_RESPONSE',
        message: 'Invalid MSS team response',
      );
    }
    return _map(data);
  }
}

List<MssTeamOption> _options(dynamic value) => (value as List? ?? const [])
    .whereType<Map>()
    .map((item) => MssTeamOption.fromJson(_map(item)))
    .toList();

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

String _date(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
