import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../commanScreen/allAPIList.dart';
import 'mobile_api_foundation.dart';

class MobileMssContext {
  const MobileMssContext({
    required this.activePanel,
    required this.profileId,
    required this.profileType,
    required this.rootOrganisationId,
    required this.organisationId,
    required this.permissions,
    required this.contextVersion,
    this.permissionsVersion,
    this.profileVersion,
  });

  final String activePanel;
  final int profileId;
  final String profileType;
  final int rootOrganisationId;
  final int organisationId;
  final List<String> permissions;
  final String contextVersion;
  final String? permissionsVersion;
  final String? profileVersion;

  bool get isEss => activePanel == 'ESS';
  bool get isMssMo => activePanel == 'MSS_MO';

  factory MobileMssContext.fromJson(Map<String, dynamic> json) {
    return MobileMssContext(
      activePanel: (json['activePanel'] ?? 'ESS').toString().toUpperCase(),
      profileId: _intValue(json['profileId']),
      profileType: (json['profileType'] ?? json['activePanel'] ?? 'ESS')
          .toString()
          .toUpperCase(),
      rootOrganisationId: _intValue(json['rootOrganisationId']),
      organisationId: _intValue(json['organisationId']),
      permissions: (json['permissions'] as List? ?? const <Object>[])
          .where((item) => item != null)
          .map((item) => item.toString())
          .toList(),
      contextVersion: (json['contextVersion'] ?? '').toString(),
      permissionsVersion: json['permissionsVersion']?.toString(),
      profileVersion: json['profileVersion']?.toString(),
    );
  }

  static int _intValue(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class MobileMssContextService {
  MobileMssContextService._();

  static final MobileApiFoundation _api = MobileApiFoundation.instance;

  static Future<MobileMssContext> synchronizeCurrent() async {
    final headers = await _api.authHeaders(requestId: _api.newRequestId());
    final response = await _api.get(
      ApiDetails.mobileMssContext,
      headers: headers,
      tag: 'MSS_CONTEXT_GET',
    );
    return _decodeAndApply(response.statusCode, response.body);
  }

  static Future<MobileMssContext> selectEss() {
    return _update(<String, Object?>{'activePanel': 'ESS'});
  }

  static Future<MobileMssContext> selectProfile({
    required int profileId,
    required String profileType,
    required int organisationId,
  }) {
    return _update(<String, Object?>{
      'activePanel': profileType,
      'profileId': profileId,
      'profileType': profileType,
      'organisationId': organisationId,
    });
  }

  static Future<MobileMssContext> selectOrganisation({
    required int organisationId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    return selectProfile(
      profileId: prefs.getInt('profileIdNew') ?? 0,
      profileType: prefs.getString('activePanel') ?? 'MSS',
      organisationId: organisationId,
    );
  }

  static Future<MobileMssContext> _update(Map<String, Object?> body) async {
    final headers = await _api.authHeaders(
      requestId: _api.newRequestId(),
      json: true,
    );
    final response = await _api.putJson(
      ApiDetails.mobileMssContext,
      body: body,
      headers: headers,
      tag: 'MSS_CONTEXT_UPDATE',
    );
    return _decodeAndApply(response.statusCode, response.body);
  }

  static Future<MobileMssContext> _decodeAndApply(
    int statusCode,
    String responseBody,
  ) async {
    Map<String, dynamic> decoded;
    try {
      final value = json.decode(responseBody);
      decoded = value is Map
          ? Map<String, dynamic>.from(value)
          : <String, dynamic>{};
    } catch (_) {
      decoded = <String, dynamic>{};
    }
    if (statusCode < 200 || statusCode >= 300) {
      final data = decoded['data'];
      final error = data is Map ? data['error'] : null;
      throw MobileApiException(
        error is Map ? (error['code'] ?? 'MSS_CONTEXT_FAILED').toString() : 'MSS_CONTEXT_FAILED',
        message: (decoded['message'] ?? 'Unable to update active panel').toString(),
        statusCode: statusCode,
      );
    }
    final data = decoded['data'];
    if (data is! Map) {
      throw const MobileApiException(
        'INVALID_MSS_CONTEXT_RESPONSE',
        message: 'Invalid active context response',
      );
    }
    final context = MobileMssContext.fromJson(Map<String, dynamic>.from(data));
    await _apply(context);
    return context;
  }

  static Future<void> _apply(MobileMssContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('activePanel', context.activePanel);
    await prefs.setString('defaultProfileType', context.profileType);
    await prefs.setInt('profileIdNew', context.profileId);
    await prefs.setInt('activeOrgId', context.organisationId);
    await prefs.setString('mobileMssContextVersion', context.contextVersion);
    await prefs.setString(
      'mobileMssActivePermissionsJson',
      json.encode(context.permissions),
    );
    if ((context.permissionsVersion ?? '').isNotEmpty) {
      await prefs.setString(
        'mobilePermissionsVersion',
        context.permissionsVersion!,
      );
    }
    if ((context.profileVersion ?? '').isNotEmpty) {
      await prefs.setString('mobileProfileVersion', context.profileVersion!);
    }
    await _refreshCachedProfile(prefs, context);
    await _syncOrganisationName(prefs, context);
    if (context.isEss) {
      await prefs.setString('userPanel', 'COMPANY_EMPLOYEE');
      await prefs.setString('profileNameNew', 'ESS');
      await prefs.remove('mssMoParentOrgId');
    } else {
      await prefs.setString(
        'userPanel',
        context.isMssMo ? 'MSS_MO_ADMIN' : 'MSS',
      );
    }
  }

  static Future<void> _refreshCachedProfile(
    SharedPreferences prefs,
    MobileMssContext context,
  ) async {
    if (context.isEss || context.profileId <= 0) return;
    final raw = prefs.getString('mobileBootstrapJson');
    if (raw == null || raw.trim().isEmpty) return;
    try {
      final decoded = json.decode(raw);
      if (decoded is! Map) return;
      final bootstrap = Map<String, dynamic>.from(decoded);
      final profiles = bootstrap['profiles'];
      if (profiles is! List) return;
      for (var index = 0; index < profiles.length; index++) {
        final value = profiles[index];
        if (value is! Map) continue;
        final profile = Map<String, dynamic>.from(value);
        if (MobileMssContext._intValue(profile['profileId']) !=
            context.profileId) {
          continue;
        }
        profile['permissions'] = context.permissions;
        profile['profilePermission'] = context.permissions;
        profile['permissionCount'] = context.permissions.length;
        profiles[index] = profile;
        break;
      }
      if ((context.profileVersion ?? '').isNotEmpty) {
        bootstrap['profileVersion'] = context.profileVersion;
      }
      await prefs.setString('mobileBootstrapJson', json.encode(bootstrap));
    } catch (_) {
      // The authoritative active permission list remains separately cached.
    }
  }

  static Future<void> _syncOrganisationName(
    SharedPreferences prefs,
    MobileMssContext context,
  ) async {
    if (!context.isMssMo) {
      await prefs.setString(
        'activeOrgName',
        prefs.getString('orgName') ?? '',
      );
      return;
    }
    final raw = prefs.getString('orgList');
    if (raw == null || raw.trim().isEmpty) return;
    try {
      final rows = json.decode(raw);
      if (rows is! List) return;
      for (final value in rows) {
        if (value is! Map) continue;
        final id = MobileMssContext._intValue(
          value['id'] ?? value['orgId'] ?? value['organisationId'],
        );
        if (id != context.organisationId) continue;
        final name =
            value['displayName'] ??
            value['orgName'] ??
            value['organisationName'];
        if (name != null) {
          await prefs.setString('activeOrgName', name.toString());
        }
        return;
      }
    } catch (_) {
      // Organisation list will refresh when the MSS MO dashboard opens.
    }
  }
}
