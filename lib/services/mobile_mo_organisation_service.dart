import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../commanScreen/allAPIList.dart';
import '../mss_profiles/organisationListModal.dart';
import '../sharedPrefancePage/ShardPre.dart';
import 'mobile_http_client.dart';
import 'mobile_panel_service.dart';

class MobileMoOrganisationService {
  MobileMoOrganisationService._();

  static final SessionManager _shared = SessionManager();
  static Future<OrganisationListModal>? _activeLoad;
  static OrganisationListModal? _lastMoResult;
  static DateTime? _lastMoFetchAt;

  static Future<OrganisationListModal> loadForActivePanel() async {
    final activePanel = await _shared.getActivePanel();
    if (activePanel != MobilePanel.mssMo) {
      return _singleCurrentOrganisation();
    }

    final cached = _lastMoResult;
    final fetchedAt = _lastMoFetchAt;
    if (cached != null &&
        fetchedAt != null &&
        DateTime.now().difference(fetchedAt) < const Duration(seconds: 30)) {
      return cached;
    }

    final running = _activeLoad;
    if (running != null) return running;

    final load = _loadMssMoOrganisations();
    _activeLoad = load;
    return load.whenComplete(() {
      if (identical(_activeLoad, load)) {
        _activeLoad = null;
      }
    });
  }

  static Future<OrganisationListModal> _loadMssMoOrganisations() async {
    final organisationId = await _shared.getOrgId() ?? 0;
    final accessToken = await _shared.getAccessToken();
    final tokenType = await _shared.getTokenType() ?? 'Bearer';
    final sessionId = await _shared.getMobileSessionId();
    final url = Uri.parse(
      '${ApiDetails.server}${ApiDetails.mobileMssMoOrganisations}',
    );

    try {
      final response = await MobileHttpClient.instance.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if ((accessToken ?? '').isNotEmpty)
            'Authorization': '$tokenType $accessToken',
          if ((sessionId ?? '').isNotEmpty) 'X-Mobile-Session-Id': sessionId!,
        },
        body: json.encode({
          'activePanel': MobilePanel.mssMo,
          'profileType': MobilePanel.mssMo,
          'userPermission': 'MSS_MO_ADMIN',
          'organisationId': organisationId,
        }),
      );

      if (response.statusCode != 200 || response.body.isEmpty) {
        return _singleCurrentOrganisation();
      }

      final decoded = json.decode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return _singleCurrentOrganisation();
      }

      final modal = OrganisationListModal.fromJson(decoded);
      if ((modal.list ?? []).isEmpty) {
        return _singleCurrentOrganisation();
      }

      if ((modal.parentOrgId ?? 0) > 0) {
        await _shared.setMssMoParentOrgId(modal.parentOrgId!);
      }
      await _cacheAndSelectOrganisation(modal);
      _lastMoResult = modal;
      _lastMoFetchAt = DateTime.now();
      return modal;
    } catch (e) {
      return _singleCurrentOrganisation();
    }
  }

  static Future<OrganisationListModal> _singleCurrentOrganisation() async {
    final currentOrgId =
        (await _shared.getActiveOrgId()) ?? (await _shared.getOrgId()) ?? 0;
    final activeOrgName = await _shared.getActiveOrgName();
    final currentOrgName =
        (activeOrgName?.isNotEmpty ?? false)
            ? activeOrgName!
            : ((await _shared.getOrgName()) ?? '');
    final parentOrgId = await _shared.getMssMoParentOrgId();
    final modal = OrganisationListModal(
      parentOrgId: parentOrgId,
      list: [
        OrgList(
          id: currentOrgId.toString(),
          orgName: currentOrgName,
          displayName: currentOrgName,
          parentOrgId: parentOrgId,
        ),
      ],
    );
    await _cacheOrganisationList(modal);
    return modal;
  }

  static Future<void> selectOrganisation(OrgList organisation) async {
    final id = int.tryParse(organisation.id ?? '') ?? 0;
    final name =
        (organisation.displayName?.isNotEmpty ?? false)
            ? organisation.displayName!
            : (organisation.orgName ?? '');
    if (id > 0) {
      await _shared.setActiveOrgId(id);
    }
    if ((organisation.parentOrgId ?? 0) > 0) {
      await _shared.setMssMoParentOrgId(organisation.parentOrgId!);
    }
    await _shared.setActiveOrgName(name);
  }

  static Future<void> _cacheAndSelectOrganisation(
    OrganisationListModal modal,
  ) async {
    await _cacheOrganisationList(modal);
    final activeOrgId = await _shared.getActiveOrgId();
    final list = modal.list ?? [];
    final selected = list.firstWhere(
      (item) => item.id == activeOrgId?.toString(),
      orElse: () => list.first,
    );
    await selectOrganisation(selected);
  }

  static Future<void> _cacheOrganisationList(
    OrganisationListModal modal,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'orgList',
      json.encode((modal.list ?? []).map((item) => item.toJson()).toList()),
    );
  }
}
