import 'package:flutter/material.dart';

import '../../commanScreen/routes.dart';
import '../../mss_profiles/organisationListModal.dart';
import '../../sharedPrefancePage/ShardPre.dart';
import '../../services/mobile_mo_organisation_service.dart';
import '../../services/mobile_mss_dashboard_service.dart';
import '../../services/mobile_mss_team_service.dart';
import '../../services/mobile_panel_service.dart';
import '../../themes/empThemes.dart';

class MssTeamDashboardScreen extends StatefulWidget {
  const MssTeamDashboardScreen({
    super.key,
    this.onViewSelf,
    this.onViewRequests,
  });

  final VoidCallback? onViewSelf;
  final VoidCallback? onViewRequests;

  @override
  State<MssTeamDashboardScreen> createState() => _MssTeamDashboardScreenState();
}

class _MssTeamDashboardScreenState extends State<MssTeamDashboardScreen> {
  final SessionManager _shared = SessionManager();
  String _employeeName = 'Employee';
  String _orgName = 'Organisation';
  String _userPanel = 'MSS';
  String _profileName = '';
  String? _selectedOrgId;
  List<OrgList> _orgList = [];
  bool _isMoPanel = false;
  bool _hasEssPanel = true;
  bool _loadingOrgs = false;
  bool _loadingDashboard = false;
  String? _dashboardError;
  int _attendanceCount = 0;
  int _leaveCount = 0;
  int _odCount = 0;
  int _wfhCount = 0;
  int _compOffCount = 0;
  int _inductionCount = 0;
  int _exitCount = 0;

  int get _totalPending =>
      _attendanceCount +
      _leaveCount +
      _odCount +
      _wfhCount +
      _compOffCount +
      _inductionCount +
      _exitCount;
  String get _attendanceRoute => _isMoPanel
      ? MyRoutings.mssMoAttPendingRequestRoRoute
      : MyRoutings.mssAttPendingRequestRoRoute;
  String get _leaveRoute => _isMoPanel
      ? MyRoutings.mssMoPendingLeaveRequestRoute
      : MyRoutings.mssPendingLeaveRequestRoute;
  String get _odRoute => _isMoPanel
      ? MyRoutings.mssMoPendingOdRequisitionRoute
      : MyRoutings.mssPendingOdRequisitionRoute;
  String get _wfhRoute => MyRoutings.mssWfhApprovalRoute;
  String get _compOffRoute => MyRoutings.mssCompOffApprovalRoute;
  String get _claimRoute => _isMoPanel
      ? MyRoutings.mssMoClaimItemRoute
      : MyRoutings.mssClaimItemRoute;

  @override
  void initState() {
    super.initState();
    MobileMssDashboardService.refreshSignal.addListener(_refreshDashboard);
    _loadData();
  }

  @override
  void dispose() {
    MobileMssDashboardService.refreshSignal.removeListener(_refreshDashboard);
    super.dispose();
  }

  void _refreshDashboard() {
    _loadData();
  }

  Future<void> _loadData() async {
    if (mounted) {
      setState(() {
        _loadingDashboard = true;
        _dashboardError = null;
      });
    }
    final employeeName = await _shared.getempName();
    final activePanel = await _shared.getActivePanel();
    final hasEssPanel = await _shared.getHasEssPanel() ?? false;
    final isMoPanel = activePanel == MobilePanel.mssMo;
    OrganisationListModal? orgModal;
    if (isMoPanel) {
      if (mounted) {
        setState(() {
          _loadingOrgs = true;
        });
      }
      try {
        orgModal = await MobileMoOrganisationService.loadForActivePanel();
      } catch (_) {
        if (!mounted) return;
        setState(() {
          _loadingOrgs = false;
          _loadingDashboard = false;
          _dashboardError = 'Unable to load organisation context.';
        });
        return;
      }
    }
    final activeOrgName = await _shared.getActiveOrgName();
    final activeOrgId = await _shared.getActiveOrgId();
    final orgName = activeOrgName ?? await _shared.getOrgName();
    final defaultProfileType = await _shared.getDefaultProfileType();
    final profileId = await _shared.getDefaultProfileId() ?? 0;
    final profileType = activePanel ?? defaultProfileType;
    final profileName = await _shared.getDefaultProfileName();
    final employeeNameText = (employeeName ?? '').toString();
    final orgNameText = (orgName ?? '').toString();
    final userPanelText = (profileType ?? '').toString();
    final profileNameText = (profileName ?? '').toString();
    MssDashboardSummary? dashboard;
    Object? dashboardError;
    if ((activeOrgId ?? 0) > 0 && profileId > 0) {
      try {
        dashboard = await MobileMssDashboardService.load(
          organisationId: activeOrgId!,
          profileId: profileId,
          profileType: profileType ?? MobilePanel.mss,
        );
      } catch (error) {
        dashboardError = error;
      }
    }
    if (!mounted) return;
    setState(() {
      _employeeName =
          employeeNameText.isNotEmpty ? employeeNameText : 'Employee';
      _orgName = orgNameText.isNotEmpty ? orgNameText : 'Organisation';
      _userPanel = userPanelText.isNotEmpty ? userPanelText : 'MSS';
      _profileName = profileNameText;
      _selectedOrgId = activeOrgId?.toString();
      _orgList = orgModal?.list ?? [];
      _isMoPanel = isMoPanel;
      _hasEssPanel = hasEssPanel;
      _loadingOrgs = false;
      _loadingDashboard = false;
      _dashboardError = dashboardError == null
          ? null
          : 'Unable to load approval counts.';
      _attendanceCount = dashboard?.count('ATTENDANCE') ?? 0;
      _leaveCount = dashboard?.count('LEAVE') ?? 0;
      _odCount = dashboard?.count('OD') ?? 0;
      _wfhCount = dashboard?.count('WFH') ?? 0;
      _compOffCount = dashboard?.count('COMP_OFF') ?? 0;
      _inductionCount = dashboard?.count('INDUCTION') ?? 0;
      _exitCount = dashboard?.count('EXIT') ?? 0;
    });
  }

  Future<void> _selectOrganisation(String? orgId) async {
    if (orgId == null || orgId == _selectedOrgId) return;
    final org = _orgList.firstWhere(
      (item) => item.id == orgId,
      orElse: () => OrgList(id: orgId, orgName: _orgName, displayName: _orgName),
    );
    try {
      if (mounted) {
        setState(() {
          _loadingDashboard = true;
          _dashboardError = null;
        });
      }
      await MobileMoOrganisationService.selectOrganisation(org);
      if (!mounted) return;
      setState(() {
        _selectedOrgId = orgId;
        _orgName = org.displayName?.isNotEmpty == true
            ? org.displayName!
            : (org.orgName ?? _orgName);
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loadingDashboard = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to change organisation.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final quickActions = <_DashboardAction>[
      _DashboardAction(
        icon: Icons.access_time_filled,
        label: 'Attendance',
        color: Mythemes.lightBluishColor,
        count: _attendanceCount,
        route: _attendanceRoute,
        order: 0,
      ),
      _DashboardAction(
        icon: Icons.calendar_month_rounded,
        label: 'Leave',
        color: Mythemes.successColor,
        count: _leaveCount,
        route: _leaveRoute,
        order: 1,
      ),
      _DashboardAction(
        icon: Icons.business_center,
        label: 'OD',
        color: Mythemes.alertColor,
        count: _odCount,
        route: _odRoute,
        order: 2,
      ),
      _DashboardAction(
        icon: Icons.home_work_rounded,
        label: 'WFH',
        color: Mythemes.stepColor,
        count: _wfhCount,
        route: _wfhRoute,
        order: 3,
      ),
      _DashboardAction(
        icon: Icons.event_repeat_rounded,
        label: 'Comp Off',
        color: Mythemes.warningColor,
        count: _compOffCount,
        route: _compOffRoute,
        order: 4,
      ),
      _DashboardAction(
        icon: Icons.people_alt,
        label: 'People',
        color: Mythemes.warningColor,
        count: -1,
        route: MyRoutings.mssTeamRoute,
        order: 5,
      ),
      _DashboardAction(
        icon: Icons.person_add_alt_1_rounded,
        label: 'Induction',
        color: Mythemes.successColor,
        count: _inductionCount,
        route: MyRoutings.mssInductionRoute,
        order: 6,
      ),
      _DashboardAction(
        icon: Icons.logout_rounded,
        label: 'Exit',
        color: Mythemes.dangerColorOne,
        count: _exitCount,
        route: MyRoutings.mssExitRoute,
        order: 7,
      ),
    ]..sort((first, second) {
      final byCount = second.count.compareTo(first.count);
      return byCount != 0 ? byCount : first.order.compareTo(second.order);
    });

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
        children: [
          _IdentityCard(
            employeeName: _employeeName,
            orgName: _orgName,
            userPanel: _userPanel,
            profileName: _profileName,
            orgList: _orgList,
            selectedOrgId: _selectedOrgId,
            isMoPanel: _isMoPanel,
            loadingOrgs: _loadingOrgs,
            onOrgChanged: _selectOrganisation,
          ),
          const SizedBox(height: 14),
          _ScopeSwitch(
            onViewSelf: widget.onViewSelf,
            canViewSelf: _hasEssPanel,
          ),
          const SizedBox(height: 14),
          if (_loadingDashboard) ...[
            const LinearProgressIndicator(minHeight: 2),
            const SizedBox(height: 12),
          ] else if (_dashboardError != null) ...[
            _DashboardError(message: _dashboardError!, onRetry: _loadData),
            const SizedBox(height: 12),
          ],
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.55,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              _StatCard(
                value: '$_totalPending',
                label: 'Pending approvals',
                color: Mythemes.lightBluishColor,
                isAccent: true,
              ),
              _StatCard(
                value: '$_attendanceCount',
                label: 'Attendance requests',
                color: Mythemes.stepColor,
                onTap: () => Navigator.pushNamed(context, _attendanceRoute),
              ),
              _StatCard(
                value: '$_leaveCount',
                label: 'Leave requests',
                color: Mythemes.successColor,
                onTap: () => Navigator.pushNamed(context, _leaveRoute),
              ),
              _StatCard(
                value: '$_odCount',
                label: 'OD requests',
                color: Mythemes.alertColor,
                onTap: () => Navigator.pushNamed(context, _odRoute),
              ),
              _StatCard(
                value: '$_wfhCount',
                label: 'WFH requests',
                color: Mythemes.stepColor,
                onTap: () => Navigator.pushNamed(context, _wfhRoute),
              ),
              _StatCard(
                value: '$_compOffCount',
                label: 'Comp Off requests',
                color: Mythemes.warningColor,
                onTap: () => Navigator.pushNamed(context, _compOffRoute),
              ),
              _StatCard(
                value: '$_inductionCount',
                label: 'Induction requests',
                color: Mythemes.successColor,
                onTap: () => Navigator.pushNamed(context, MyRoutings.mssInductionRoute),
              ),
              _StatCard(
                value: '$_exitCount',
                label: 'Exit requests',
                color: Mythemes.dangerColorOne,
                onTap: () => Navigator.pushNamed(context, MyRoutings.mssExitRoute),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _SectionTitle(
            title: 'Quick actions',
            action: TextButton(
              onPressed: widget.onViewRequests,
              child: Text(
                'View all',
                style: TextStyle(color: Mythemes.lightBluishColor),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 86,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: quickActions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final action = quickActions[index];
                return SizedBox(
                  width: 76,
                  child: _QuickAction(
                    icon: action.icon,
                    label: action.label,
                    color: action.color,
                    count: action.count < 0 ? null : action.count,
                    onTap: () => Navigator.pushNamed(context, action.route),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MssRequestsScreen extends StatefulWidget {
  const MssRequestsScreen({super.key});

  @override
  State<MssRequestsScreen> createState() => _MssRequestsScreenState();
}

class _MssRequestsScreenState extends State<MssRequestsScreen> {
  final SessionManager _shared = SessionManager();
  bool _isMoPanel = false;
  bool _loading = true;
  MssDashboardSummary? _summary;

  String get _attendanceRoute => _isMoPanel
      ? MyRoutings.mssMoAttPendingRequestRoRoute
      : MyRoutings.mssAttPendingRequestRoRoute;
  String get _leaveRoute => _isMoPanel
      ? MyRoutings.mssMoPendingLeaveRequestRoute
      : MyRoutings.mssPendingLeaveRequestRoute;
  String get _odRoute => _isMoPanel
      ? MyRoutings.mssMoPendingOdRequisitionRoute
      : MyRoutings.mssPendingOdRequisitionRoute;
  String get _wfhRoute => MyRoutings.mssWfhApprovalRoute;
  String get _compOffRoute => MyRoutings.mssCompOffApprovalRoute;
  String get _claimRoute => _isMoPanel
      ? MyRoutings.mssMoClaimItemRoute
      : MyRoutings.mssClaimItemRoute;

  @override
  void initState() {
    super.initState();
    MobileMssDashboardService.refreshSignal.addListener(_loadData);
    _loadData();
  }

  @override
  void dispose() {
    MobileMssDashboardService.refreshSignal.removeListener(_loadData);
    super.dispose();
  }

  Future<void> _loadData() async {
    final activePanel = await _shared.getActivePanel();
    final activeOrgId = await _shared.getActiveOrgId();
    final profileId = await _shared.getDefaultProfileId() ?? 0;
    final defaultProfileType = await _shared.getDefaultProfileType();
    MssDashboardSummary? summary;
    if ((activeOrgId ?? 0) > 0 && profileId > 0) {
      try {
        summary = await MobileMssDashboardService.load(
          organisationId: activeOrgId!,
          profileId: profileId,
          profileType: activePanel ?? defaultProfileType ?? MobilePanel.mss,
        );
      } catch (_) {
        summary = null;
      }
    }
    if (!mounted) return;
    setState(() {
      _isMoPanel = activePanel == MobilePanel.mssMo;
      _summary = summary;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
      children: [
        const _PageHeading(
          eyebrow: 'Approvals centre',
          title: 'Requests',
          subtitle: 'Act on pending attendance, leave, OD, claims and advances.',
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.12,
          children: [
            _ModuleGridCard(icon: Icons.access_time_filled, title: 'Attendance', color: Mythemes.lightBluishColor, count: _summary?.count('ATTENDANCE') ?? 0, loading: _loading, onTap: () => Navigator.pushNamed(context, _attendanceRoute)),
            _ModuleGridCard(icon: Icons.calendar_month_rounded, title: 'Leave', color: Mythemes.successColor, count: _summary?.count('LEAVE') ?? 0, loading: _loading, onTap: () => Navigator.pushNamed(context, _leaveRoute)),
            _ModuleGridCard(icon: Icons.business_center, title: 'On Duty', color: Mythemes.alertColor, count: _summary?.count('OD') ?? 0, loading: _loading, onTap: () => Navigator.pushNamed(context, _odRoute)),
            _ModuleGridCard(icon: Icons.home_work_rounded, title: 'WFH', color: Mythemes.stepColor, count: _summary?.count('WFH') ?? 0, loading: _loading, onTap: () => Navigator.pushNamed(context, _wfhRoute)),
            _ModuleGridCard(icon: Icons.event_repeat_rounded, title: 'Comp Off', color: Mythemes.warningColor, count: _summary?.count('COMP_OFF') ?? 0, loading: _loading, onTap: () => Navigator.pushNamed(context, _compOffRoute)),
            _ModuleGridCard(icon: Icons.payments, title: 'Claims', color: Mythemes.warningColor, onTap: () => Navigator.pushNamed(context, _claimRoute)),
            _ModuleGridCard(icon: Icons.account_balance_wallet, title: 'Loans & Advance', color: Mythemes.stepColor, onTap: () => Navigator.pushNamed(context, MyRoutings.loanApprovalPageRoute)),
          ],
        ),
      ],
    );
  }
}

class MssPeopleScreen extends StatefulWidget {
  const MssPeopleScreen({super.key});

  @override
  State<MssPeopleScreen> createState() => _MssPeopleScreenState();
}

class _MssPeopleScreenState extends State<MssPeopleScreen> {
  final SessionManager _shared = SessionManager();
  bool _loading = true;
  int _employeeCount = 0;
  int _inductionCount = 0;
  int _exitCount = 0;

  @override
  void initState() {
    super.initState();
    MobileMssDashboardService.refreshSignal.addListener(_loadCounts);
    MobileMssTeamService.countRefreshSignal.addListener(_loadCounts);
    _loadCounts();
  }

  @override
  void dispose() {
    MobileMssDashboardService.refreshSignal.removeListener(_loadCounts);
    MobileMssTeamService.countRefreshSignal.removeListener(_loadCounts);
    super.dispose();
  }

  Future<void> _loadCounts() async {
    final activePanel = await _shared.getActivePanel();
    final activeOrgId = await _shared.getActiveOrgId();
    final profileId = await _shared.getDefaultProfileId() ?? 0;
    final defaultProfileType = await _shared.getDefaultProfileType();
    MssDashboardSummary? summary;
    final dashboardFuture = (activeOrgId ?? 0) > 0 && profileId > 0
        ? MobileMssDashboardService.load(
            organisationId: activeOrgId!,
            profileId: profileId,
            profileType: activePanel ?? defaultProfileType ?? MobilePanel.mss,
          ).then<MssDashboardSummary?>((value) => value).catchError((_) => null)
        : Future<MssDashboardSummary?>.value(null);
    final teamFuture = MobileMssTeamService.employeeCount()
        .then<int?>((value) => value)
        .catchError((_) => null);
    final results = await Future.wait<Object?>([dashboardFuture, teamFuture]);
    summary = results[0] as MssDashboardSummary?;
    final employeeCount = results[1] as int?;
    if (!mounted) return;
    setState(() {
      _employeeCount = employeeCount ?? 0;
      _inductionCount = summary?.count('INDUCTION') ?? 0;
      _exitCount = summary?.count('EXIT') ?? 0;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
      children: [
        const _PageHeading(
          eyebrow: 'Workforce',
          title: 'People',
          subtitle: 'Team, induction and exit workflows.',
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.12,
          children: [
            _ModuleGridCard(icon: Icons.groups_rounded, title: 'Employees', subtitle: 'Total team members', color: Mythemes.lightBluishColor, count: _employeeCount, loading: _loading, onTap: () => Navigator.pushNamed(context, MyRoutings.mssTeamRoute)),
            _ModuleGridCard(icon: Icons.person_add_alt_1, title: 'Induction', color: Mythemes.successColor, count: _inductionCount, loading: _loading, onTap: () => Navigator.pushNamed(context, MyRoutings.mssInductionRoute)),
            _ModuleGridCard(icon: Icons.exit_to_app, title: 'Exit', color: Mythemes.dangerColorOne, count: _exitCount, loading: _loading, onTap: () => Navigator.pushNamed(context, MyRoutings.mssExitRoute)),
          ],
        ),
      ],
    );
  }
}

class _DashboardAction {
  const _DashboardAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.count,
    required this.route,
    required this.order,
  });

  final IconData icon;
  final String label;
  final Color color;
  final int count;
  final String route;
  final int order;
}

class _DashboardError extends StatelessWidget {
  const _DashboardError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Mythemes.dangerColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Mythemes.dangerColor.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Mythemes.dangerColor, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: const TextStyle(fontSize: 12))),
          IconButton(
            tooltip: 'Retry',
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 20),
          ),
        ],
      ),
    );
  }
}

class _IdentityCard extends StatelessWidget {
  const _IdentityCard({
    required this.employeeName,
    required this.orgName,
    required this.userPanel,
    required this.profileName,
    required this.orgList,
    required this.selectedOrgId,
    required this.isMoPanel,
    required this.loadingOrgs,
    required this.onOrgChanged,
  });

  final String employeeName;
  final String orgName;
  final String userPanel;
  final String profileName;
  final List<OrgList> orgList;
  final String? selectedOrgId;
  final bool isMoPanel;
  final bool loadingOrgs;
  final ValueChanged<String?> onOrgChanged;

  @override
  Widget build(BuildContext context) {
    final dropdownItems = orgList
        .where((item) => (item.id ?? '').isNotEmpty)
        .fold<Map<String, OrgList>>({}, (map, item) {
          map[item.id!] = item;
          return map;
        })
        .values
        .toList();
    final dropdownValue =
        dropdownItems.any((item) => item.id == selectedOrgId)
            ? selectedOrgId
            : null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Mythemes.lightBluishColor,
                child: Text(
                  _initials(orgName),
                  style: TextStyle(
                    color: Mythemes.whitish,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orgName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      profileName.isNotEmpty
                          ? profileName
                          : 'Good morning, $employeeName',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Mythemes.blackish, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Mythemes.lightBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  userPanel.toUpperCase() == 'MSS_MO' ? 'MSS MO' : 'MSS',
                  style: TextStyle(
                    color: Mythemes.lightBluishColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          if (isMoPanel) ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: dropdownValue,
              isExpanded: true,
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Mythemes.greyLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Mythemes.lightBluishColor),
                ),
              ),
              hint: Text(
                loadingOrgs ? 'Loading organisations' : orgName,
                overflow: TextOverflow.ellipsis,
              ),
              items: dropdownItems
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item.id,
                      child: Text(
                        (item.displayName?.isNotEmpty ?? false)
                            ? item.displayName!
                            : (item.orgName ?? ''),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: loadingOrgs ? null : onOrgChanged,
            ),
          ],
        ],
      ),
    );
  }
}

class _ScopeSwitch extends StatelessWidget {
  const _ScopeSwitch({this.onViewSelf, required this.canViewSelf});

  final VoidCallback? onViewSelf;
  final bool canViewSelf;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Mythemes.whitish,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Mythemes.greyLight),
      ),
      child: Row(
        children: [
          if (canViewSelf)
            Expanded(
              child: _Pill(
                label: 'Self',
                selected: false,
                onTap:
                    onViewSelf ??
                    () => Navigator.pushNamed(
                      context,
                      MyRoutings.essDashboardNavigateRoute,
                    ),
              ),
            ),
          Expanded(child: _Pill(label: 'Team', selected: true, onTap: () {})),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: selected ? Mythemes.lightBluishColor : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Mythemes.whitish : Mythemes.blackish,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
    this.isAccent = false,
    this.onTap,
  });

  final String value;
  final String label;
  final Color color;
  final bool isAccent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: _cardDecoration(color: isAccent ? color : Mythemes.whitish),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                color: isAccent ? Mythemes.whitish : color,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isAccent ? Mythemes.whitish : Mythemes.blackish,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.count,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 9),
        decoration: _cardDecoration(radius: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: color, size: 24),
                if (count != null && count! > 0)
                  Positioned(
                    right: -13,
                    top: -10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: Mythemes.dangerColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$count',
                        style: TextStyle(
                          color: Mythemes.whitish,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 7),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}

class _ApprovalTile extends StatelessWidget {
  const _ApprovalTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final int count;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(13),
        decoration: _cardDecoration(),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Mythemes.blackish, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (count > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: Mythemes.dangerColor.withOpacity(.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: Mythemes.dangerColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: _cardDecoration(),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Mythemes.blackish, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Mythemes.greyish),
          ],
        ),
      ),
    );
  }
}

class _ModuleGridCard extends StatelessWidget {
  const _ModuleGridCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
    this.count,
    this.loading = false,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  final int? count;
  final bool loading;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: _cardDecoration(radius: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 23),
                ),
                if (count != null)
                  loading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: color,
                          ),
                        )
                      : Text(
                          '$count',
                          style: TextStyle(
                            color: count! > 0 ? Mythemes.dangerColor : color,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
              ],
            ),
            const Spacer(),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle ?? (count == null ? 'Open module' : 'Pending requests'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Mythemes.greyish, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageHeading extends StatelessWidget {
  const _PageHeading({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  final String eyebrow;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: TextStyle(
            color: Mythemes.greyish,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(subtitle, style: TextStyle(color: Mythemes.blackish, fontSize: 12)),
      ],
    );
  }
}

BoxDecoration _cardDecoration({Color? color, double radius = 12}) {
  return BoxDecoration(
    color: color ?? Mythemes.whitish,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: Mythemes.greyLight),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(.04),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
    ],
  );
}

String _initials(String value) {
  final parts = value.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
  if (parts.isEmpty) return 'ER';
  if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
  return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
}
