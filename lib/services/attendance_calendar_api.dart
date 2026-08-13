import 'dart:convert';

import 'package:er_flutter_project/commanScreen/allAPIList.dart';
import 'package:er_flutter_project/services/mobile_api_foundation.dart';
import 'package:er_flutter_project/sharedPrefancePage/ShardPre.dart';

class AttendanceCalendarApi {
  AttendanceCalendarApi({MobileApiFoundation? foundation})
    : _foundation = foundation ?? MobileApiFoundation.instance;

  final MobileApiFoundation _foundation;

  Future<AttendanceCalendarResult> fetchMonth(String month) async {
    print('[MOBILE_CALENDAR_FETCH_START] month=$month');
    final cacheKey = _cacheKey(month);
    final cached = await MobileApiCache.instance.readJson(cacheKey);
    try {
      final requestId = _foundation.newRequestId();
      final session = SessionManager();
      final organisationId = await session.getOrgId();
      final employeeDetailsId = await session.getEmployeeDetailsId();
      final storedEmployeeCode = await session.getEmpCode();
      final storedEmployeeId = await session.getEmployeeId();
      final employeeCode =
          storedEmployeeCode?.toString().trim().isNotEmpty == true
          ? storedEmployeeCode
          : storedEmployeeId;
      print(
        '[MOBILE_CALENDAR_PARAMS] organisationId=$organisationId '
        'employeeDetailsId=$employeeDetailsId employeeCode=$employeeCode month=$month',
      );
      final response = await _foundation.get(
        ApiDetails.mobileCalendar,
        queryParameters: <String, Object?>{
          'month': month,
          'organisationId': organisationId,
          'employeeDetailsId': employeeDetailsId,
          'employeeCode': employeeCode,
        },
        headers: await _foundation.authHeaders(requestId: requestId),
        timeout: MobileApiFoundation.readTimeout,
        tag: 'MOBILE_CALENDAR',
      );
      _logLong('MOBILE_CALENDAR_RAW_RESPONSE', response.body);
      final body = _foundation.decodeMap(response.body);
      _logCalendarSummary(body);
      if (!_foundation.isSuccess(response)) {
        throw MobileApiException(
          'CALENDAR_LOAD_FAILED',
          message: body['message']?.toString() ?? response.body,
          statusCode: response.statusCode,
          retryable: response.statusCode >= 500,
        );
      }
      await MobileApiCache.instance.saveJson(cacheKey, body);
      return AttendanceCalendarResult(data: body, cached: false);
    } on MobileApiException {
      if (cached != null) {
        _logLong('MOBILE_CALENDAR_CACHED_RESPONSE', jsonEncode(cached.data));
        _logCalendarSummary(cached.data);
        return AttendanceCalendarResult(
          data: cached.data,
          cached: true,
          cachedAt: cached.cachedAt,
        );
      }
      rethrow;
    } catch (error) {
      if (cached != null) {
        _logLong('MOBILE_CALENDAR_CACHED_RESPONSE', jsonEncode(cached.data));
        _logCalendarSummary(cached.data);
        return AttendanceCalendarResult(
          data: cached.data,
          cached: true,
          cachedAt: cached.cachedAt,
        );
      }
      throw MobileApiException(
        'CALENDAR_LOAD_FAILED',
        message: error.toString(),
        retryable: true,
      );
    }
  }

  String _cacheKey(String month) => 'attendanceCalendar:$month';

  void _logCalendarSummary(Map<String, dynamic> body) {
    final counts = <String, int>{};
    final rows = body['data'];
    if (rows is List) {
      for (final row in rows) {
        if (row is Map) {
          final status =
              (row['attendanceStatus'] ?? row['status'] ?? 'UNKNOWN')
                  .toString();
          counts[status] = (counts[status] ?? 0) + 1;
        }
      }
    }
    print('[MOBILE_CALENDAR_STATUS_COUNTS] $counts');
  }

  void _logLong(String tag, String value) {
    const chunkSize = 700;
    print('[$tag] length=${value.length}');
    for (var start = 0; start < value.length; start += chunkSize) {
      final end =
          start + chunkSize > value.length ? value.length : start + chunkSize;
      print('[$tag][$start-$end] ${value.substring(start, end)}');
    }
  }
}

class AttendanceCalendarResult {
  final Map<String, dynamic> data;
  final bool cached;
  final DateTime? cachedAt;

  const AttendanceCalendarResult({
    required this.data,
    required this.cached,
    this.cachedAt,
  });

  String toJsonString() => jsonEncode(data);
}
