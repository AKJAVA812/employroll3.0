import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../commanScreen/allAPIList.dart';
import '../mss_profiles/organisationListModal.dart';
import '../sharedPrefancePage/ShardPre.dart';
import 'mobile_api_foundation.dart';
import 'mobile_mss_context_service.dart';
import 'mobile_mss_dashboard_service.dart';
import 'mobile_panel_service.dart';

class MobileMoOrganisationService {
  MobileMoOrganisationService._();

  static final SessionManager _shared = SessionManager();
  static final MobileApiFoundation _api = MobileApiFoundation.instance;
  static Future<OrganisationListModal>? _activeLoad;
  static OrganisationListModal? _lastMoResult;
  static bool _networkLoaded = false;
  static int? _lastProfileId;

  static Future<OrganisationListModal> loadForActivePanel() async {
    final activePanel = await _shared.getActivePanel();
    if (activePanel != MobilePanel.mssMo) {
      return _singleCurrentOrganisation();
    }

    final profileId = await _shared.getDefaultProfileId() ?? 0;
    if (_lastProfileId != profileId) {
      _lastProfileId = profileId;
      _lastMoResult = null;
      _networkLoaded = false;
      _activeLoad = null;
    }

    final cached = _lastMoResult;
    if (cached != null) {
      return cached;
    }

    final persisted = await _cachedOrganisationList(profileId);
    if (persisted != null && (persisted.list ?? []).isNotEmpty) {
      _lastMoResult = persisted;
      _refreshInBackground();
      return persisted;
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
    final profileId = await _shared.getDefaultProfileId() ?? 0;
    _lastProfileId = profileId;
    try {
      final headers = await _api.authHeaders(
        requestId: _api.newRequestId(),
        json: true,
      );
      final response = await _api.postJson(
        ApiDetails.mobileMssMoOrganisations,
        headers: headers,
        tag: 'MSS_MO_ORGANISATIONS',
        body: <String, Object?>{
          'activePanel': MobilePanel.mssMo,
          'profileType': MobilePanel.mssMo,
          'profileId': profileId,
          'userPermission': 'MSS_MO_ADMIN',
          'organisationId': organisationId,
        },
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

      if ((await _shared.getDefaultProfileId() ?? 0) != profileId) {
        return _lastMoResult ?? modal;
      }

      if ((modal.parentOrgId ?? 0) > 0) {
        await _shared.setMssMoParentOrgId(modal.parentOrgId!);
      }
      await _cacheAndSelectOrganisation(modal);
      _lastMoResult = modal;
      _networkLoaded = true;
      return modal;
    } catch (e) {
      _networkLoaded = true;
      final cached = _lastMoResult;
      if (cached != null) return cached;
      return _singleCurrentOrganisation();
    }
  }

  static void _refreshInBackground() async {
    if (_networkLoaded || _activeLoad != null) return;
    final load = _loadMssMoOrganisations();
    _activeLoad = load;
    try {
      final before = jsonEncode(_lastMoResult?.toJson());
      final fresh = await load;
      if (before != jsonEncode(fresh.toJson())) {
        MobileMssDashboardService.invalidate();
      }
    } catch (_) {
      // The persisted organisation remains usable while refresh is unavailable.
    } finally {
      if (identical(_activeLoad, load)) _activeLoad = null;
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

  static Future<void> selectOrganisation(
    OrgList organisation, {
    bool notifyDashboard = true,
  }) async {
    final id = int.tryParse(organisation.id ?? '') ?? 0;
    final name =
        (organisation.displayName?.isNotEmpty ?? false)
            ? organisation.displayName!
            : (organisation.orgName ?? '');
    final currentId = await _shared.getActiveOrgId();
    if (id > 0 && currentId == id) {
      if ((organisation.parentOrgId ?? 0) > 0) {
        await _shared.setMssMoParentOrgId(organisation.parentOrgId!);
      }
      await _shared.setActiveOrgName(name);
      return;
    }
    if (id > 0) {
      await MobileMssContextService.selectOrganisation(organisationId: id);
      await _shared.setActiveOrgId(id);
    }
    if ((organisation.parentOrgId ?? 0) > 0) {
      await _shared.setMssMoParentOrgId(organisation.parentOrgId!);
    }
    await _shared.setActiveOrgName(name);
    if (notifyDashboard) MobileMssDashboardService.invalidate();
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
    await selectOrganisation(selected, notifyDashboard: false);
  }

  static Future<void> _cacheOrganisationList(
    OrganisationListModal modal,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final profileId = await _shared.getDefaultProfileId() ?? 0;
    await prefs.setString(
      'orgList',
      json.encode((modal.list ?? []).map((item) => item.toJson()).toList()),
    );
    if ((modal.parentOrgId ?? 0) > 0) {
      await prefs.setInt('mssMoParentOrgId', modal.parentOrgId!);
    }
    await prefs.setInt('mssMoOrgListProfileId', profileId);
  }

  static Future<OrganisationListModal?> _cachedOrganisationList(
    int profileId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('mssMoOrgListProfileId') != profileId) return null;
    final raw = prefs.getString('orgList');
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return null;
      return OrganisationListModal(
        parentOrgId: prefs.getInt('mssMoParentOrgId'),
        list: decoded
            .whereType<Map>()
            .map((item) => OrgList.fromJson(Map<String, dynamic>.from(item)))
            .toList(),
      );
    } catch (_) {
      await prefs.remove('orgList');
      return null;
    }
  }
}
