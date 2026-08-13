import 'dart:convert';

import '../commanScreen/allAPIList.dart';
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
}

class MssApprovalFilterCatalog {
  const MssApprovalFilterCatalog({
    required this.requestTypes,
    required this.stages,
    required this.branches,
  });

  final List<MssApprovalFilterOption> requestTypes;
  final List<MssApprovalFilterOption> stages;
  final List<MssApprovalFilterOption> branches;

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
    );
  }
}

class MobileMssApprovalFilterService {
  MobileMssApprovalFilterService._();

  static final MobileApiFoundation _api = MobileApiFoundation.instance;
  static final Map<String, Future<MssApprovalFilterCatalog>> _loads = {};

  static Future<MssApprovalFilterCatalog> load({
    required int organisationId,
    String moduleCode = 'TIME_ATTENDANCE',
  }) {
    final key = '$organisationId:$moduleCode';
    return _loads.putIfAbsent(key, () async {
      final headers = await _api.authHeaders(requestId: _api.newRequestId());
      final response = await _api.get(
        ApiDetails.mobileMssApprovalFilters,
        queryParameters: {
          'organisationId': organisationId,
          'moduleCode': moduleCode,
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
      return MssApprovalFilterCatalog.fromJson(data);
    }).whenComplete(() => _loads.remove(key));
  }
}
