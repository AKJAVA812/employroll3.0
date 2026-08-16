import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../commanScreen/allAPIList.dart';
import 'mobile_api_foundation.dart';

class MssDashboardModule {
  const MssDashboardModule({
    required this.code,
    required this.label,
    required this.count,
    required this.enabled,
    required this.order,
  });

  final String code;
  final String label;
  final int count;
  final bool enabled;
  final int order;

  factory MssDashboardModule.fromJson(Map<String, dynamic> json) {
    return MssDashboardModule(
      code: (json['code'] ?? '').toString().toUpperCase(),
      label: (json['label'] ?? json['code'] ?? '').toString(),
      count: _intValue(json['count']),
      enabled: _boolValue(json['enabled']),
      order: _intValue(json['order']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'label': label,
        'count': count,
        'enabled': enabled,
        'order': order,
      };
}

class MssDashboardSummary {
  const MssDashboardSummary({
    required this.organisationId,
    required this.profileId,
    required this.profileType,
    required this.totalPending,
    required this.modules,
    this.generatedAt,
  });

  final int organisationId;
  final int profileId;
  final String profileType;
  final int totalPending;
  final List<MssDashboardModule> modules;
  final DateTime? generatedAt;

  int count(String code) {
    final normalized = code.toUpperCase();
    for (final module in modules) {
      if (module.code == normalized) return module.count;
    }
    return 0;
  }

  factory MssDashboardSummary.fromJson(Map<String, dynamic> json) {
    final summary = Map<String, dynamic>.from(json['summary'] as Map? ?? {});
    final modules = (json['modules'] as List? ?? const <Object>[])
        .whereType<Map>()
        .map(
          (item) => MssDashboardModule.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
    return MssDashboardSummary(
      organisationId: _intValue(json['organisationId']),
      profileId: _intValue(json['profileId']),
      profileType: (json['profileType'] ?? '').toString(),
      totalPending: _intValue(summary['totalPending']),
      modules: modules,
      generatedAt: DateTime.tryParse(json['generatedAt']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'organisationId': organisationId,
        'profileId': profileId,
        'profileType': profileType,
        'summary': <String, dynamic>{'totalPending': totalPending},
        'modules': modules.map((module) => module.toJson()).toList(),
        if (generatedAt != null) 'generatedAt': generatedAt!.toIso8601String(),
      };
}

class MobileMssDashboardService {
  MobileMssDashboardService._();

  static final MobileApiFoundation _api = MobileApiFoundation.instance;
  static final Map<String, Future<MssDashboardSummary>> _loads = {};
  static final Map<String, MssDashboardSummary> _memoryCache = {};
  static final ValueNotifier<int> refreshSignal = ValueNotifier<int>(0);
  static final ValueNotifier<int> manualRefreshSignal = ValueNotifier<int>(0);

  static void invalidate() {
    refreshSignal.value++;
  }

  static void requestManualRefresh() {
    manualRefreshSignal.value++;
  }

  static Future<MssDashboardSummary> refresh({
    required int organisationId,
    required int profileId,
    required String profileType,
  }) {
    final scope = '$profileType:$profileId:$organisationId';
    return _refresh(scope, organisationId, profileId, profileType);
  }

  static Future<MssDashboardSummary> load({
    required int organisationId,
    required int profileId,
    required String profileType,
  }) async {
    final scope = '$profileType:$profileId:$organisationId';
    final memory = _memoryCache[scope];
    if (memory != null) {
      _refreshInBackground(scope, organisationId, profileId, profileType);
      return memory;
    }

    final persisted = await _readCache(scope);
    if (persisted != null) {
      _memoryCache[scope] = persisted;
      _refreshInBackground(scope, organisationId, profileId, profileType);
      return persisted;
    }

    return _refresh(scope, organisationId, profileId, profileType);
  }

  static void _refreshInBackground(
    String scope,
    int organisationId,
    int profileId,
    String profileType,
  ) async {
    try {
      await _refresh(scope, organisationId, profileId, profileType);
    } catch (error) {
      debugPrint('[MSS-DASHBOARD] Background refresh failed: $error');
    }
  }

  static Future<MssDashboardSummary> _refresh(
    String scope,
    int organisationId,
    int profileId,
    String profileType,
  ) {
    final running = _loads[scope];
    if (running != null) return running;

    final load = (() async {
      final headers = await _api.authHeaders(requestId: _api.newRequestId());
      final response = await _api.get(
        ApiDetails.mobileMssDashboard,
        queryParameters: <String, Object?>{
          'organisationId': organisationId,
          'profileId': profileId,
          'profileType': profileType,
        },
        headers: headers,
        tag: 'MSS_DASHBOARD',
      );
      Map<String, dynamic> decoded;
      try {
        final value = json.decode(response.body);
        decoded = value is Map
            ? Map<String, dynamic>.from(value)
            : <String, dynamic>{};
      } catch (_) {
        decoded = <String, dynamic>{};
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        final data = decoded['data'];
        final error = data is Map ? data['error'] : null;
        throw MobileApiException(
          error is Map
              ? (error['code'] ?? 'MSS_DASHBOARD_FAILED').toString()
              : 'MSS_DASHBOARD_FAILED',
          message: (decoded['message'] ?? 'Unable to load team dashboard')
              .toString(),
          statusCode: response.statusCode,
        );
      }
      final data = decoded['data'];
      if (data is! Map) {
        throw const MobileApiException(
          'INVALID_MSS_DASHBOARD_RESPONSE',
          message: 'Invalid team dashboard response',
        );
      }
      final fresh = MssDashboardSummary.fromJson(
        Map<String, dynamic>.from(data),
      );
      final previous = _memoryCache[scope] ?? await _readCache(scope);
      final changed = previous == null ||
          jsonEncode(_comparable(previous)) != jsonEncode(_comparable(fresh));
      _memoryCache[scope] = fresh;
      await _writeCache(scope, fresh);
      if (previous != null && changed) refreshSignal.value++;
      return fresh;
    })();
    _loads[scope] = load;
    return load.whenComplete(() {
      if (identical(_loads[scope], load)) _loads.remove(scope);
    });
  }

  static Future<MssDashboardSummary?> _readCache(String scope) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cacheKey(scope));
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map
          ? MssDashboardSummary.fromJson(Map<String, dynamic>.from(decoded))
          : null;
    } catch (_) {
      await prefs.remove(_cacheKey(scope));
      return null;
    }
  }

  static Future<void> _writeCache(
    String scope,
    MssDashboardSummary summary,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey(scope), jsonEncode(summary.toJson()));
  }

  static String _cacheKey(String scope) => 'mobile_mss_dashboard_cache_$scope';

  static Map<String, dynamic> _comparable(MssDashboardSummary summary) {
    final value = summary.toJson();
    value.remove('generatedAt');
    return value;
  }
}

int _intValue(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

bool _boolValue(dynamic value) {
  if (value is bool) return value;
  final normalized = value?.toString().toLowerCase();
  return normalized == 'true' || normalized == '1' || normalized == 'yes';
}
