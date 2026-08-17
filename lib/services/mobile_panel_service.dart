import 'package:shared_preferences/shared_preferences.dart';

import '../mss_profiles/profileListModal.dart';
import '../singUP/model/loginModel.dart';
import 'mobile_mss_context_service.dart';
import 'mobile_mss_dashboard_service.dart';

class MobilePanel {
  static const ess = 'ESS';
  static const mss = 'MSS';
  static const mssMo = 'MSS_MO';

  static bool isManager(String? value) => value == mss || value == mssMo;

  static String fromProfileType(String? value) {
    final normalized = (value ?? '').toUpperCase();
    return normalized == mssMo ? mssMo : mss;
  }

  static String userPermissionFor(String? panel) {
    return panel == mssMo ? 'MSS_MO_ADMIN' : mss;
  }
}

class MobilePanelService {
  MobilePanelService._();

  static Future<void> bootstrapFromLogin(LoginModel loginModel) async {
    final prefs = await SharedPreferences.getInstance();
    final profiles = loginModel.profiles;
    final essIds = loginModel.essPermissions?.securityGroupIds ?? <String>[];
    final hasEss = essIds.isNotEmpty;
    final hasMss = profiles.any(
      (profile) => profile.profileType?.toString().toUpperCase() == 'MSS',
    );
    final hasMssMo = profiles.any(
      (profile) => profile.profileType?.toString().toUpperCase() == 'MSS_MO',
    );

    await prefs.setBool('hasEssPanel', hasEss);
    await prefs.setBool('hasMssPanel', hasMss);
    await prefs.setBool('hasMssMoPanel', hasMssMo);

    final orgId = loginModel.data?.orgId ?? loginModel.user?.orgId ?? 0;
    final orgName = loginModel.data?.orgName ?? loginModel.user?.orgName ?? '';
    await prefs.setInt('activeOrgId', orgId);
    await prefs.setString('activeOrgName', orgName);
    await prefs.remove('mssMoParentOrgId');
    await prefs.remove('orgList');

    if (hasEss) {
      await _setEssSelection(prefs);
      await _synchronizeSafely();
      return;
    }

    if (profiles.isNotEmpty) {
      final firstProfile = profiles.first;
      final profileType = firstProfile.profileType?.toString() ?? 'MSS';
      final panel = MobilePanel.fromProfileType(profileType);
      await prefs.setString('activePanel', panel);
      await prefs.setString('userPanel', MobilePanel.userPermissionFor(panel));
      await prefs.setInt(
        'profileIdNew',
        _intValue(firstProfile.profileId) ?? 0,
      );
      await prefs.setString(
        'profileNameNew',
        firstProfile.profileName?.toString() ?? '',
      );
      await prefs.setString('defaultProfileType', profileType);
      await _synchronizeSafely();
      return;
    }

    await _setEssSelection(prefs);
    await _synchronizeSafely();
  }

  static Future<void> activateEss() async {
    await MobileMssContextService.selectEss();
    final prefs = await SharedPreferences.getInstance();
    await _setEssSelection(prefs);
    await _resetActiveOrgToLoginOrg(prefs);
    MobileMssDashboardService.invalidate();
  }

  static Future<void> _setEssSelection(SharedPreferences prefs) async {
    await prefs.setString('activePanel', MobilePanel.ess);
    await prefs.setString('userPanel', 'COMPANY_EMPLOYEE');
    await prefs.setInt('profileIdNew', 0);
    await prefs.setString('profileNameNew', 'ESS');
    await prefs.setString('defaultProfileType', MobilePanel.ess);
  }

  static Future<void> activateProfile(ProfileData profile) async {
    final prefs = await SharedPreferences.getInstance();
    final panel = MobilePanel.fromProfileType(profile.profileType);
    final rootOrganisationId = prefs.getInt('orgId') ?? 0;
    final selectedOrganisationId = panel == MobilePanel.mssMo
        ? (prefs.getInt('activeOrgId') ?? rootOrganisationId)
        : rootOrganisationId;
    await MobileMssContextService.selectProfile(
      profileId: profile.profileId ?? 0,
      profileType: panel,
      organisationId: selectedOrganisationId,
    );
    await prefs.setString('activePanel', panel);
    await prefs.setString('userPanel', MobilePanel.userPermissionFor(panel));
    await prefs.setInt('profileIdNew', profile.profileId ?? 0);
    await prefs.setString('profileNameNew', profile.profileName ?? '');
    await prefs.setString('defaultProfileType', profile.profileType ?? 'MSS');
    if (panel != MobilePanel.mssMo) {
      await _resetActiveOrgToLoginOrg(prefs);
    }
    MobileMssDashboardService.invalidate();
  }

  static Future<void> _resetActiveOrgToLoginOrg(SharedPreferences prefs) async {
    await prefs.setInt('activeOrgId', prefs.getInt('orgId') ?? 0);
    await prefs.setString('activeOrgName', prefs.getString('orgName') ?? '');
    await prefs.remove('mssMoParentOrgId');
  }

  static int? _intValue(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static Future<void> _synchronizeSafely() async {
    try {
      await MobileMssContextService.synchronizeCurrent();
    } catch (error) {
    }
  }
}
