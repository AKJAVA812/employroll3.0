import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MobileEssPermissionState {
  final Set<String> securityGroupIds;
  final bool canPunchAttendance;
  final bool canWorkDone;
  final bool canViewCalendar;
  final bool canViewDashboard;
  final bool canAddAttendanceRequisition;
  final bool canTrackOnly;
  final bool canTrackWithAttendance;
  final bool requiresSelfie;
  final bool allowsWithoutSelfie;
  final bool hasSelfieConflict;

  const MobileEssPermissionState({
    required this.securityGroupIds,
    required this.canPunchAttendance,
    required this.canWorkDone,
    required this.canViewCalendar,
    required this.canViewDashboard,
    required this.canAddAttendanceRequisition,
    required this.canTrackOnly,
    required this.canTrackWithAttendance,
    required this.requiresSelfie,
    required this.allowsWithoutSelfie,
    required this.hasSelfieConflict,
  });

  bool get hasAnyMobileAccess =>
      canPunchAttendance ||
      canWorkDone ||
      canViewCalendar ||
      canViewDashboard ||
      canAddAttendanceRequisition ||
      canTrackOnly ||
      canTrackWithAttendance;

  bool get shouldRunBackgroundTracking =>
      canTrackOnly || canTrackWithAttendance;

  Map<String, dynamic> toLogJson() => <String, dynamic>{
    'securityGroupIds': securityGroupIds.toList()..sort(),
    'canPunchAttendance': canPunchAttendance,
    'canWorkDone': canWorkDone,
    'canViewCalendar': canViewCalendar,
    'canViewDashboard': canViewDashboard,
    'canAddAttendanceRequisition': canAddAttendanceRequisition,
    'canTrackOnly': canTrackOnly,
    'canTrackWithAttendance': canTrackWithAttendance,
    'requiresSelfie': requiresSelfie,
    'allowsWithoutSelfie': allowsWithoutSelfie,
    'hasSelfieConflict': hasSelfieConflict,
  };
}

class MobilePermissionService {
  MobilePermissionService._();

  static MobileEssPermissionState? _lastKnownState;

  static MobileEssPermissionState? get lastKnownState => _lastKnownState;

  static void clearLastKnownState() {
    _lastKnownState = null;
  }

  static const essMobileAttendance = 'ESS_MOBILE_ATTENDACE_VIEW';
  static const essMobileAttendanceCorrectSpelling =
      'ESS_MOBILE_ATTENDANCE_VIEW';
  static const essMobileWorkDone = 'ESS_MOBILE_WORK_DONE_VIEW';
  static const essMobileCalendar = 'ESS_MOBILE_CALENDAR_VIEW';
  static const essAttendanceDashboard = 'ESS_ATTENDANCE_DASHBOARD_VIEW';
  static const essMyDashboard = 'ESS_MY_DASHBOARD_VIEW';
  static const essMobileAttendanceRequisitionAdd =
      'ESS_MOBILE_ATT_REQUISITION_ADD';
  static const essMobileTracking = 'ESS_MOBILE_TRACKING_VIEW';
  static const essMobileAttSelfie = 'ESS_MOBILE_ATT_SELFIE_VIEW';
  static const essMobileAttWithoutSelfie = 'ESS_MOBILE_ATT_WITHOUT_SELFIE_VIEW';
  static const essMobileAttTracking = 'ESS_MOBILE_ATT_TRACKING_VIEW';

  static Future<MobileEssPermissionState> loadEssState() async {
    final ids = await loadSecurityGroupIds();
    final hasAttendance =
        ids.contains(essMobileAttendance) ||
        ids.contains(essMobileAttendanceCorrectSpelling);
    final hasWorkDone = ids.contains(essMobileWorkDone);
    final hasCalendar = ids.contains(essMobileCalendar);
    final hasDashboard =
        ids.contains(essAttendanceDashboard) || ids.contains(essMyDashboard);
    final hasAttendanceRequisitionAdd = ids.contains(
      essMobileAttendanceRequisitionAdd,
    );
    final hasTrackingOnly = ids.contains(essMobileTracking);
    final hasAttendanceTracking = ids.contains(essMobileAttTracking);
    final hasSelfie = ids.contains(essMobileAttSelfie);
    final hasWithoutSelfie = ids.contains(essMobileAttWithoutSelfie);
    final hasSelfieConflict = hasSelfie && hasWithoutSelfie;

    final state = MobileEssPermissionState(
      securityGroupIds: ids,
      canPunchAttendance:
          hasAttendance ||
          hasAttendanceTracking ||
          hasSelfie ||
          hasWithoutSelfie,
      canWorkDone: hasWorkDone,
      canViewCalendar: hasCalendar,
      canViewDashboard: hasDashboard,
      canAddAttendanceRequisition: hasAttendanceRequisitionAdd,
      canTrackOnly: hasTrackingOnly && !hasAttendance && !hasWorkDone,
      canTrackWithAttendance: hasAttendanceTracking,
      requiresSelfie: hasSelfie || hasSelfieConflict,
      allowsWithoutSelfie: hasWithoutSelfie && !hasSelfieConflict,
      hasSelfieConflict: hasSelfieConflict,
    );

    if (hasSelfieConflict) {
    }
    _lastKnownState = state;
    return state;
  }

  static Future<Set<String>> loadSecurityGroupIds() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = <String>{};
    final hasBootstrap = _readIdsFromJson(
      prefs.getString('mobileBootstrapJson'),
      ids,
    );
    if (!hasBootstrap) {
      _readIdsFromJson(prefs.getString('mobileLoginResponseJson'), ids);
    }
    return ids;
  }

  static bool _readIdsFromJson(String? rawJson, Set<String> ids) {
    if (rawJson == null || rawJson.trim().isEmpty) return false;
    try {
      _collectSecurityGroupIds(json.decode(rawJson), ids);
      return true;
    } catch (error) {
      return false;
    }
  }

  static void _collectSecurityGroupIds(dynamic value, Set<String> ids) {
    if (value is Map) {
      value.forEach((key, child) {
        final normalizedKey = key.toString().toLowerCase();
        if (normalizedKey == 'securitygroupids' ||
            normalizedKey == 'securitygroupid') {
          _addIds(child, ids);
        }
        _collectSecurityGroupIds(child, ids);
      });
      return;
    }

    if (value is List) {
      for (final item in value) {
        _collectSecurityGroupIds(item, ids);
      }
    }
  }

  static void _addIds(dynamic value, Set<String> ids) {
    if (value is List) {
      for (final item in value) {
        _addIds(item, ids);
      }
      return;
    }

    if (value is Map) {
      for (final key in const ['securityGroupId', 'groupId', 'id', 'code']) {
        final item = value[key];
        if (item != null) _addIds(item, ids);
      }
      return;
    }

    final id = value?.toString().trim().toUpperCase();
    if (id != null && id.isNotEmpty) ids.add(id);
  }
}
