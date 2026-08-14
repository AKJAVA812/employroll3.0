import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../commanScreen/allAPIList.dart';
import '../sharedPrefancePage/ShardPre.dart';
import 'mobile_api_foundation.dart';

class MssApprovalFilterOption {
  const MssApprovalFilterOption({
    required this.code,
    required this.label,
    this.id,
    this.familyCode,
  });

  final String code;
  final String label;
  final Object? id;
  final String? familyCode;

  factory MssApprovalFilterOption.fromJson(Map<String, dynamic> json) {
    return MssApprovalFilterOption(
      code: (json['code'] ?? json['id'] ?? '').toString(),
      label: (json['label'] ?? json['name'] ?? json['code'] ?? '').toString(),
      id: json['id'],
      familyCode: json['familyCode']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'code': code,
    'label': label,
    if (id != null) 'id': id,
    if (familyCode != null) 'familyCode': familyCode,
  };
}

class MssApprovalFilterCatalog {
  const MssApprovalFilterCatalog({
    required this.requestTypes,
    required this.stages,
    required this.branches,
    this.version,
  });

  final List<MssApprovalFilterOption> requestTypes;
  final List<MssApprovalFilterOption> stages;
  final List<MssApprovalFilterOption> branches;
  final String? version;

  factory MssApprovalFilterCatalog.fromJson(Map<String, dynamic> json) {
    List<MssApprovalFilterOption> options(String key) {
      final value = json[key];
      if (value is! List) return const [];
      return value
          .whereType<Map>()
          .map(
            (item) => MssApprovalFilterOption.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .where((item) => item.code.isNotEmpty && item.label.isNotEmpty)
          .toList();
    }

    return MssApprovalFilterCatalog(
      requestTypes: options('requestTypes'),
      stages: options('stages'),
      branches: options('branches'),
      version: json['version']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'requestTypes': requestTypes.map((item) => item.toJson()).toList(),
    'stages': stages.map((item) => item.toJson()).toList(),
    'branches': branches.map((item) => item.toJson()).toList(),
    if (version != null) 'version': version,
  };
}

class MobileMssApprovalFilterService {
  MobileMssApprovalFilterService._();

  static final MobileApiFoundation _api = MobileApiFoundation.instance;
  static final SessionManager _session = SessionManager();
  static final Map<String, Future<MssApprovalFilterCatalog>> _loads = {};

  static Future<MssApprovalFilterCatalog> load({
    required int organisationId,
    String moduleCode = 'TIME_ATTENDANCE',
    bool forceRefresh = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final profileId = await _session.getDefaultProfileId() ?? 0;
    final profileVersion =
        await _session.getProfileVersion() ?? 'unversioned';
    final normalizedModule = moduleCode.trim().toUpperCase();
    final scope = '$organisationId:$normalizedModule:$profileId:$profileVersion';
    final cacheKey = 'mssApprovalFilters:v2:$scope';

    if (!forceRefresh) {
      final cached = _cached(prefs.getString(cacheKey));
      if (cached != null) return cached;
    }

    final running = _loads[scope];
    if (running != null) return running;

    final load = (() async {
      final headers = await _api.authHeaders(requestId: _api.newRequestId());
      final response = await _api.get(
        ApiDetails.mobileMssApprovalFilters,
        queryParameters: {
          'organisationId': organisationId,
          'moduleCode': normalizedModule,
        },
        headers: headers,
        tag: 'MSS_APPROVAL_FILTERS',
      );
      if (response.statusCode != 200) {
        throw MobileApiException(
          'MSS_APPROVAL_FILTERS_FAILED',
          message: 'Unable to load approval filters',
          statusCode: response.statusCode,
        );
      }
      final decoded = json.decode(response.body);
      if (decoded is! Map) {
        throw const MobileApiException(
          'INVALID_MSS_APPROVAL_FILTER_RESPONSE',
          message: 'Invalid approval filter response',
        );
      }
      final data = Map<String, dynamic>.from(decoded['data'] as Map? ?? {});
      final catalog = MssApprovalFilterCatalog.fromJson(data);
      await prefs.setString(
        cacheKey,
        json.encode(<String, dynamic>{
          'cachedAt': DateTime.now().toUtc().toIso8601String(),
          'version': catalog.version,
          'data': catalog.toJson(),
        }),
      );
      return catalog;
    })();
    _loads[scope] = load;
    return load.whenComplete(() {
      if (identical(_loads[scope], load)) _loads.remove(scope);
    });
  }

  static MssApprovalFilterCatalog? _cached(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final decoded = json.decode(raw);
      if (decoded is! Map) return null;
      final data = decoded['data'];
      if (data is! Map) return null;
      return MssApprovalFilterCatalog.fromJson(
        Map<String, dynamic>.from(data),
      );
    } catch (_) {
      return null;
    }
  }
}
