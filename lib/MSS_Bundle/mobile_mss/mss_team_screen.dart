import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/mobile_mss_team_service.dart';
import '../../themes/empThemes.dart';
import '../../utils/ui_date_formatter.dart';

class MssTeamScreen extends StatefulWidget {
  const MssTeamScreen({super.key});

  @override
  State<MssTeamScreen> createState() => _MssTeamScreenState();
}

class _MssTeamScreenState extends State<MssTeamScreen> {
  final List<MssTeamEmployee> _employees = [];
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  MssTeamFilters _filters = const MssTeamFilters(
    branches: [],
    departments: [],
    designations: [],
    relations: [],
  );
  Map<String, int> _summary = const {};
  int? _branchId;
  int? _departmentId;
  int? _designationId;
  String? _relation;
  String _sortBy = 'employeeName';
  String _direction = 'ASC';
  int _page = 0;
  bool _last = true;
  bool _loading = true;
  bool _loadingMore = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load(reset: true);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load({required bool reset}) async {
    if (reset) {
      setState(() {
        _loading = true;
        _error = null;
      });
    } else {
      if (_last || _loadingMore) return;
      setState(() => _loadingMore = true);
    }
    try {
      final page = await MobileMssTeamService.employees(
        page: reset ? 0 : _page + 1,
        sortBy: _sortBy,
        direction: _direction,
        search:
            _searchController.text.trim().isEmpty
                ? null
                : _searchController.text.trim(),
        branchId: _branchId,
        departmentId: _departmentId,
        designationId: _designationId,
        relation: _relation,
      );
      if (!mounted) return;
      setState(() {
        if (reset) _employees.clear();
        _employees.addAll(page.items);
        _summary = page.summary;
        _filters = page.filters;
        _page = page.page;
        _last = page.last;
        _loading = false;
        _loadingMore = false;
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadingMore = false;
        _error = _message(error);
      });
    }
  }

  void _search(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) _load(reset: true);
    });
  }

  Future<void> _showFilters() async {
    var branchId = _branchId;
    var departmentId = _departmentId;
    var designationId = _designationId;
    var relation = _relation;
    final apply = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setModalState) => SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      16 + MediaQuery.viewInsetsOf(context).bottom,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Filter employees',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _OptionDropdown(
                          label: 'Branch',
                          value: branchId,
                          options: _filters.branches,
                          onChanged:
                              (value) => setModalState(() => branchId = value),
                        ),
                        const SizedBox(height: 10),
                        _OptionDropdown(
                          label: 'Department',
                          value: departmentId,
                          options: _filters.departments,
                          onChanged:
                              (value) =>
                                  setModalState(() => departmentId = value),
                        ),
                        const SizedBox(height: 10),
                        _OptionDropdown(
                          label: 'Designation',
                          value: designationId,
                          options: _filters.designations,
                          onChanged:
                              (value) =>
                                  setModalState(() => designationId = value),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String?>(
                          value: relation,
                          decoration: const InputDecoration(
                            labelText: 'Team relation',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('All relations'),
                            ),
                            ..._filters.relations.map(
                              (value) => DropdownMenuItem<String?>(
                                value: value,
                                child: Text(_label(value)),
                              ),
                            ),
                          ],
                          onChanged:
                              (value) => setModalState(() => relation = value),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                setModalState(() {
                                  branchId = null;
                                  departmentId = null;
                                  designationId = null;
                                  relation = null;
                                });
                              },
                              child: const Text('Clear'),
                            ),
                            const Spacer(),
                            FilledButton.icon(
                              onPressed: () => Navigator.pop(context, true),
                              icon: const Icon(Icons.check_rounded),
                              label: const Text('Apply'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
          ),
    );
    if (apply != true || !mounted) return;
    setState(() {
      _branchId = branchId;
      _departmentId = departmentId;
      _designationId = designationId;
      _relation = relation;
    });
    _load(reset: true);
  }

  int get _activeFilters =>
      [
        _branchId,
        _departmentId,
        _designationId,
        _relation,
      ].where((value) => value != null).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Mythemes.black,
        elevation: 0.5,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Team',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            Text('Active profile workforce', style: TextStyle(fontSize: 11)),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Sort employees',
            icon: const Icon(Icons.sort_rounded),
            onSelected: (value) {
              setState(() => _sortBy = value);
              _load(reset: true);
            },
            itemBuilder:
                (_) => const [
                  PopupMenuItem(
                    value: 'employeeName',
                    child: Text('Employee name'),
                  ),
                  PopupMenuItem(
                    value: 'employeeCode',
                    child: Text('Employee code'),
                  ),
                  PopupMenuItem(value: 'branch', child: Text('Branch')),
                  PopupMenuItem(value: 'department', child: Text('Department')),
                  PopupMenuItem(
                    value: 'designation',
                    child: Text('Designation'),
                  ),
                  PopupMenuItem(
                    value: 'dateOfJoining',
                    child: Text('Joining date'),
                  ),
                ],
          ),
          IconButton(
            tooltip: _direction == 'ASC' ? 'Ascending' : 'Descending',
            onPressed: () {
              setState(() => _direction = _direction == 'ASC' ? 'DESC' : 'ASC');
              _load(reset: true);
            },
            icon: Icon(
              _direction == 'ASC'
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _load(reset: true),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
          children: [
            _TeamSummary(summary: _summary),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _search,
                    decoration: const InputDecoration(
                      hintText: 'Search name, ID, branch or department',
                      prefixIcon: Icon(Icons.search_rounded),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Badge(
                  isLabelVisible: _activeFilters > 0,
                  label: Text('$_activeFilters'),
                  child: IconButton.filledTonal(
                    tooltip: 'Filter employees',
                    onPressed: _showFilters,
                    icon: const Icon(Icons.filter_list_rounded),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_loading)
              const Padding(
                padding: EdgeInsets.only(top: 55),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              _MessageState(
                message: _error!,
                icon: Icons.error_outline_rounded,
                action: () => _load(reset: true),
              )
            else if (_employees.isEmpty)
              const _MessageState(
                message: 'No employees are assigned to this profile.',
                icon: Icons.group_off_outlined,
              )
            else ...[
              ..._employees.map(
                (employee) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _EmployeeTile(
                    employee: employee,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => MssTeamEmployeeDetailScreen(
                                  employee: employee,
                                ),
                          ),
                        ),
                  ),
                ),
              ),
              if (!_last)
                TextButton.icon(
                  onPressed: _loadingMore ? null : () => _load(reset: false),
                  icon:
                      _loadingMore
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Icon(Icons.expand_more_rounded),
                  label: Text(_loadingMore ? 'Loading' : 'Load more'),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class MssTeamEmployeeDetailScreen extends StatefulWidget {
  const MssTeamEmployeeDetailScreen({super.key, required this.employee});

  final MssTeamEmployee employee;

  @override
  State<MssTeamEmployeeDetailScreen> createState() =>
      _MssTeamEmployeeDetailScreenState();
}

class _MssTeamEmployeeDetailScreenState
    extends State<MssTeamEmployeeDetailScreen> {
  Map<String, dynamic>? _detail;
  MssTeamAttendance? _attendance;
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);
  bool _loadingDetail = true;
  bool _loadingAttendance = true;
  String? _detailError;
  String? _attendanceError;

  @override
  void initState() {
    super.initState();
    _loadDetail();
    _loadAttendance();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _loadingDetail = true;
      _detailError = null;
    });
    try {
      final detail = await MobileMssTeamService.employee(widget.employee.id);
      if (!mounted) return;
      setState(() {
        _detail = detail;
        _loadingDetail = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loadingDetail = false;
        _detailError = _message(error);
      });
    }
  }

  Future<void> _loadAttendance() async {
    final requestedMonth = _month;
    setState(() {
      _loadingAttendance = true;
      _attendanceError = null;
    });
    final cached = await MobileMssTeamService.cachedAttendance(
      employeeDetailsId: widget.employee.id,
      month: requestedMonth,
    );
    if (!mounted || requestedMonth != _month) return;
    if (cached != null) {
      setState(() {
        _attendance = cached;
        _loadingAttendance = false;
      });
    }
    try {
      final attendance = await MobileMssTeamService.attendance(
        employeeDetailsId: widget.employee.id,
        month: requestedMonth,
      );
      if (!mounted || requestedMonth != _month) return;
      setState(() {
        _attendance = attendance;
        _loadingAttendance = false;
      });
    } catch (error) {
      if (!mounted || requestedMonth != _month) return;
      setState(() {
        if (cached == null) _attendance = null;
        _loadingAttendance = false;
        _attendanceError = cached == null ? _message(error) : null;
      });
    }
  }

  void _changeMonth(int delta) {
    final next = DateTime(_month.year, _month.month + delta);
    final now = DateTime.now();
    if (next.isAfter(DateTime(now.year, now.month))) return;
    setState(() => _month = next);
    _loadAttendance();
  }

  @override
  Widget build(BuildContext context) {
    final employee = MssTeamEmployee(_detail ?? widget.employee.data);
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Mythemes.black,
        elevation: 0.5,
        title: const Text(
          'Employee details',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([_loadDetail(), _loadAttendance()]);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
          children: [
            _EmployeeHeader(employee: employee),
            const SizedBox(height: 10),
            if (_loadingDetail)
              const LinearProgressIndicator()
            else if (_detailError != null)
              _InlineError(message: _detailError!, onRetry: _loadDetail)
            else
              _DetailSection(data: _detail ?? const {}),
            const SizedBox(height: 10),
            _AttendanceSection(
              month: _month,
              attendance: _attendance,
              loading: _loadingAttendance,
              error: _attendanceError,
              onPrevious: () => _changeMonth(-1),
              onNext: () => _changeMonth(1),
              onRetry: _loadAttendance,
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamSummary extends StatelessWidget {
  const _TeamSummary({required this.summary});
  final Map<String, int> summary;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xffe4e7ec)),
    ),
    child: Row(
      children: [
        _Metric(
          label: 'Team',
          value: summary['total'] ?? 0,
          color: Mythemes.lightBluishColor,
        ),
        _Metric(
          label: 'Direct',
          value: summary['direct'] ?? 0,
          color: Mythemes.successColor,
        ),
        _Metric(
          label: 'Dotted',
          value: summary['dotted'] ?? 0,
          color: Mythemes.alertColor,
        ),
        _Metric(
          label: 'Shared',
          value: summary['sharedServices'] ?? 0,
          color: Mythemes.warningColor,
        ),
      ],
    ),
  );
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final int value;
  final Color color;
  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Color(0xff667085)),
        ),
      ],
    ),
  );
}

class _EmployeeTile extends StatelessWidget {
  const _EmployeeTile({required this.employee, required this.onTap});
  final MssTeamEmployee employee;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    child: ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: Mythemes.lightBluishColor.withOpacity(0.12),
        child: Text(
          employee.name[0].toUpperCase(),
          style: TextStyle(
            color: Mythemes.lightBluishColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      title: Text(
        employee.name,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            [
              employee.code,
              employee.designation,
            ].where((value) => value.isNotEmpty).join('  |  '),
            style: const TextStyle(fontSize: 10),
          ),
          Text(
            [
              employee.branch,
              employee.department,
            ].where((value) => value.isNotEmpty).join('  |  '),
            style: const TextStyle(fontSize: 10, color: Color(0xff667085)),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _label(employee.relation),
            style: TextStyle(fontSize: 9, color: Mythemes.alertColor),
          ),
          const Icon(Icons.chevron_right_rounded, size: 20),
        ],
      ),
    ),
  );
}

class _EmployeeHeader extends StatelessWidget {
  const _EmployeeHeader({required this.employee});
  final MssTeamEmployee employee;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Mythemes.lightBluishColor.withOpacity(0.12),
          child: Text(
            employee.name[0].toUpperCase(),
            style: const TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                employee.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                [
                  employee.code,
                  employee.designation,
                ].where((value) => value.isNotEmpty).join('  |  '),
              ),
              Text(
                _label(employee.relation),
                style: TextStyle(fontSize: 11, color: Mythemes.alertColor),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.data});
  final Map<String, dynamic> data;
  @override
  Widget build(BuildContext context) => _Section(
    title: 'Employment',
    child: Column(
      children: [
        _InfoRow(label: 'Branch', value: _text(data['branch'])),
        _InfoRow(label: 'Department', value: _text(data['department'])),
        _InfoRow(label: 'Designation', value: _text(data['designation'])),
        _InfoRow(
          label: 'Employment type',
          value: _text(data['employmentType']),
        ),
        _InfoRow(
          label: 'Date of joining',
          value: formatUiDate(data['dateOfJoining']),
        ),
        _InfoRow(label: 'Email', value: _text(data['email'])),
        _InfoRow(label: 'Contact', value: _text(data['contact'])),
        _InfoRow(
          label: 'Date of birth',
          value: formatUiDate(data['dateOfBirth']),
        ),
      ],
    ),
  );
}

class _AttendanceSection extends StatelessWidget {
  const _AttendanceSection({
    required this.month,
    required this.attendance,
    required this.loading,
    required this.error,
    required this.onPrevious,
    required this.onNext,
    required this.onRetry,
  });
  final DateTime month;
  final MssTeamAttendance? attendance;
  final bool loading;
  final String? error;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final summary = attendance?.summary ?? const <String, dynamic>{};
    final days = _attendanceDaysForMonth(month, attendance?.days ?? const []);
    return _Section(
      title: 'Attendance summary',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Previous month',
            onPressed: onPrevious,
            icon: const Icon(Icons.chevron_left_rounded),
          ),
          Text(
            _monthLabel(month),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          IconButton(
            tooltip: 'Next month',
            onPressed: onNext,
            icon: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
      child:
          loading
              ? const LinearProgressIndicator()
              : error != null
              ? _InlineError(message: error!, onRetry: onRetry)
              : Column(
                children: [
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1.65,
                    children: [
                      _AttendanceMetric(
                        label: 'Present',
                        value: _number(summary['present']),
                        color: Mythemes.successColor,
                      ),
                      _AttendanceMetric(
                        label: 'Absent',
                        value: _number(summary['absent']),
                        color: Mythemes.dangerColorOne,
                      ),
                      _AttendanceMetric(
                        label: 'Leave',
                        value: _number(summary['leave']),
                        color: Mythemes.alertColor,
                      ),
                      _AttendanceMetric(
                        label: 'Half day',
                        value: _number(summary['halfDay']),
                        color: Mythemes.warningColor,
                      ),
                      _AttendanceMetric(
                        label: 'Late',
                        value: _number(summary['late']),
                        color: const Color(0xfff79009),
                      ),
                      _AttendanceMetric(
                        label: 'Mispunch',
                        value: _number(summary['mispunch']),
                        color: Mythemes.stepColor,
                      ),
                      _AttendanceMetric(
                        label: 'Week off',
                        value: _number(summary['weekOff']),
                        color: const Color(0xff667085),
                      ),
                      _AttendanceMetric(
                        label: 'Holiday',
                        value: _number(summary['holiday']),
                        color: const Color(0xff7f56d9),
                      ),
                      _AttendanceMetric(
                        label: 'Payable',
                        value: _number(summary['payableDays']),
                        color: Mythemes.lightBluishColor,
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _AttendanceTable(days: days),
                ],
              ),
    );
  }
}

class _AttendanceMetric extends StatelessWidget {
  const _AttendanceMetric({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 9),
          ),
        ],
      ),
    ),
  );
}

class _AttendanceTable extends StatelessWidget {
  const _AttendanceTable({required this.days});

  final List<Map<String, dynamic>> days;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const _AttendanceTableRow(
        date: 'Date',
        inTime: 'In',
        outTime: 'Out',
        status: 'Status',
        header: true,
      ),
      const Divider(height: 1),
      SizedBox(
        height: 290,
        child: Scrollbar(
          child: ListView.separated(
            primary: false,
            padding: EdgeInsets.zero,
            itemCount: days.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final day = days[index];
              return _AttendanceTableRow(
                date: formatUiDate(day['attendanceDate']),
                inTime: _attendanceTime(day, 'punchIn', 'firstPunch'),
                outTime: _attendanceTime(day, 'punchOut', 'lastPunch'),
                status: _text(
                  day['statusName'],
                  _text(day['statusCode'], '-'),
                ),
              );
            },
          ),
        ),
      ),
    ],
  );
}

class _AttendanceTableRow extends StatelessWidget {
  const _AttendanceTableRow({
    required this.date,
    required this.inTime,
    required this.outTime,
    required this.status,
    this.header = false,
  });

  final String date;
  final String inTime;
  final String outTime;
  final String status;
  final bool header;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: header ? 10 : 9.5,
      fontWeight: header ? FontWeight.w700 : FontWeight.w400,
      color: header ? const Color(0xff475467) : const Color(0xff344054),
    );
    return SizedBox(
      height: header ? 30 : 34,
      child: Row(
        children: [
          Expanded(flex: 28, child: Text(date, style: style)),
          Expanded(flex: 17, child: Text(inTime, style: style)),
          Expanded(flex: 17, child: Text(outTime, style: style)),
          Expanded(
            flex: 38,
            child: Text(
              status,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.trailing});
  final String title;
  final Widget child;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        const Divider(height: 18),
        child,
      ],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 112,
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, color: Color(0xff667085)),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}

class _OptionDropdown extends StatelessWidget {
  const _OptionDropdown({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });
  final String label;
  final int? value;
  final List<MssTeamOption> options;
  final ValueChanged<int?> onChanged;
  @override
  Widget build(BuildContext context) => DropdownButtonFormField<int?>(
    value: value,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
    items: [
      DropdownMenuItem<int?>(
        value: null,
        child: Text('All ${label.toLowerCase()}s'),
      ),
      ...options.map(
        (option) =>
            DropdownMenuItem<int?>(value: option.id, child: Text(option.label)),
      ),
    ],
    onChanged: onChanged,
  );
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Icon(
        Icons.error_outline_rounded,
        size: 20,
        color: Color(0xffd92d20),
      ),
      const SizedBox(width: 8),
      Expanded(child: Text(message, style: const TextStyle(fontSize: 11))),
      IconButton(
        tooltip: 'Retry',
        onPressed: onRetry,
        icon: const Icon(Icons.refresh_rounded),
      ),
    ],
  );
}

class _MessageState extends StatelessWidget {
  const _MessageState({required this.message, required this.icon, this.action});
  final String message;
  final IconData icon;
  final VoidCallback? action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 55),
    child: Column(
      children: [
        Icon(icon, size: 40, color: const Color(0xff98a2b3)),
        const SizedBox(height: 8),
        Text(message, textAlign: TextAlign.center),
        if (action != null)
          TextButton.icon(
            onPressed: action,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
      ],
    ),
  );
}

String _label(String value) => value
    .replaceAll('_', ' ')
    .toLowerCase()
    .split(' ')
    .map(
      (part) =>
          part.isEmpty ? part : '${part[0].toUpperCase()}${part.substring(1)}',
    )
    .join(' ');

String _monthLabel(DateTime value) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[value.month - 1]} ${value.year}';
}

List<Map<String, dynamic>> _attendanceDaysForMonth(
  DateTime month,
  List<Map<String, dynamic>> source,
) {
  final rowsByDate = <String, Map<String, dynamic>>{};
  for (final row in source) {
    final date = DateTime.tryParse(_text(row['attendanceDate']));
    if (date != null) {
      rowsByDate[_dateKey(date)] = row;
    }
  }

  final lastDay = DateTime(month.year, month.month + 1, 0).day;
  return List.generate(lastDay, (index) {
    final date = DateTime(month.year, month.month, index + 1);
    return rowsByDate[_dateKey(date)] ??
        <String, dynamic>{'attendanceDate': _dateKey(date)};
  });
}

String _dateKey(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}

String _attendanceTime(
  Map<String, dynamic> day,
  String directKey,
  String punchKey,
) {
  var value = _text(day[directKey]);
  final punch = day[punchKey];
  if (value.isEmpty && punch is Map) {
    value = _text(punch['time']);
  }
  if (value.isEmpty) {
    final fallbackKeys = directKey == 'punchIn'
        ? const ['firstInTime', 'inTime']
        : const ['lastOutTime', 'outTime'];
    for (final key in fallbackKeys) {
      value = _text(day[key]);
      if (value.isNotEmpty) break;
    }
  }
  if (value.isEmpty) return '--:--';

  final match = RegExp(r'(\d{1,2}:\d{2})').firstMatch(value);
  return match?.group(1) ?? value;
}

String _number(dynamic value) {
  if (value is num)
    return value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);
  return value?.toString() ?? '0';
}

String _text(dynamic value, [String fallback = '']) {
  final text = value?.toString().trim() ?? '';
  return text.isEmpty ? fallback : text;
}

String _message(Object error) {
  final value = error.toString();
  final separator = value.indexOf(': ');
  return separator < 0 ? value : value.substring(separator + 2);
}
