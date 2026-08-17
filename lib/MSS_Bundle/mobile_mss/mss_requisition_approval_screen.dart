import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/mobile_mss_requisition_service.dart';
import '../../themes/empThemes.dart';
import '../../utils/ui_date_formatter.dart';
import '../common/mss_approval_filter_panel.dart';

class MssRequisitionApprovalScreen extends StatefulWidget {
  const MssRequisitionApprovalScreen({super.key, required this.module});

  final String module;

  @override
  State<MssRequisitionApprovalScreen> createState() =>
      _MssRequisitionApprovalScreenState();
}

class _MssRequisitionApprovalScreenState
    extends State<MssRequisitionApprovalScreen> {
  final List<MssRequisitionItem> _items = [];
  Timer? _debounce;
  String _tab = 'pending';
  String _sortBy = 'submittedAt';
  String _direction = 'DESC';
  String? _search;
  String? _requestType;
  int? _stage;
  String? _branch;
  Map<String, int> _summary = const {};
  int _page = 0;
  bool _last = true;
  bool _loading = true;
  bool _loadingMore = false;
  String? _error;

  String get _module => widget.module.toUpperCase();

  @override
  void initState() {
    super.initState();
    _load(reset: true);
  }

  @override
  void dispose() {
    _debounce?.cancel();
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
      final result = await MobileMssRequisitionService.list(
        module: _module,
        tab: _tab,
        page: reset ? 0 : _page + 1,
        sortBy: _sortBy,
        direction: _direction,
        search: _search,
        requestType: _requestType,
        stage: _stage,
        branch: _branch,
      );
      if (!mounted) return;
      setState(() {
        if (reset) _items.clear();
        _items.addAll(result.items);
        _summary = result.summary;
        _page = result.page;
        _last = result.last;
        _loading = false;
        _loadingMore = false;
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

  void _changeTab(String? tab) {
    if (tab == null || tab == _tab) return;
    setState(() => _tab = tab);
    _load(reset: true);
  }

  void _filters(MssApprovalFilterValue value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _search = value.search.isEmpty ? null : value.search;
      _requestType = value.requestType?.code;
      _stage = int.tryParse(value.stage?.id?.toString() ?? '');
      _branch = value.branch?.label;
      _load(reset: true);
    });
  }

  Future<void> _open(MssRequisitionItem item) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => MssRequisitionDetailScreen(requestId: item.requestId),
      ),
    );
    if (changed == true) await _load(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    final config = _ModuleConfig.of(_module);
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Mythemes.black,
        elevation: 0.5,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${config.label} approvals',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const Text('Team requisitions', style: TextStyle(fontSize: 11)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => _load(reset: true),
            icon: const Icon(Icons.refresh_rounded),
          ),
          PopupMenuButton<String>(
            tooltip: 'Sort requests',
            icon: const Icon(Icons.sort_rounded),
            onSelected: (value) {
              setState(() => _sortBy = value);
              _load(reset: true);
            },
            itemBuilder:
                (_) => const [
                  PopupMenuItem(
                    value: 'submittedAt',
                    child: Text('Submitted date'),
                  ),
                  PopupMenuItem(
                    value: 'employeeName',
                    child: Text('Employee name'),
                  ),
                  PopupMenuItem(
                    value: 'requestType',
                    child: Text('Request type'),
                  ),
                  PopupMenuItem(
                    value: 'currentLevel',
                    child: Text('Approval stage'),
                  ),
                ],
          ),
          IconButton(
            tooltip: _direction == 'DESC' ? 'Descending' : 'Ascending',
            onPressed: () {
              setState(
                () => _direction = _direction == 'DESC' ? 'ASC' : 'DESC',
              );
              _load(reset: true);
            },
            icon: Icon(
              _direction == 'DESC'
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _load(reset: true),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
          children: [
            CupertinoSlidingSegmentedControl<String>(
              groupValue: _tab,
              thumbColor: config.color,
              backgroundColor: Colors.white,
              children: {
                'pending': _tabText('Pending', _summary['pending'] ?? 0),
                'actioned': _tabText('Actioned', _summary['actioned'] ?? 0),
              },
              onValueChanged: _changeTab,
            ),
            const SizedBox(height: 12),
            MssApprovalFilterPanel(
              total: _summary['total'] ?? 0,
              pending: _summary['pending'] ?? 0,
              approved: _summary['approved'] ?? 0,
              rejected: _summary['rejected'] ?? 0,
              requestFamilyCode: config.familyCode,
              allowedRequestTypeCodes: config.requestTypes,
              onChanged: _filters,
            ),
            if (_loading)
              const Padding(
                padding: EdgeInsets.only(top: 60),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              _MessageState(
                icon: Icons.error_outline_rounded,
                message: _error!,
                action: () => _load(reset: true),
              )
            else if (_items.isEmpty)
              const _MessageState(
                icon: Icons.inbox_outlined,
                message: 'No requisitions found.',
              )
            else ...[
              ..._items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _RequestTile(
                    item: item,
                    color: config.color,
                    onTap: () => _open(item),
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

  Widget _tabText(String label, int count) {
    final selected = _tab == label.toLowerCase();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
      child: Text(
        '$label  $count',
        style: TextStyle(
          color: selected ? Colors.white : Mythemes.black,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class MssRequisitionDetailScreen extends StatefulWidget {
  const MssRequisitionDetailScreen({super.key, required this.requestId});

  final String requestId;

  @override
  State<MssRequisitionDetailScreen> createState() =>
      _MssRequisitionDetailScreenState();
}

class _MssRequisitionDetailScreenState
    extends State<MssRequisitionDetailScreen> {
  MssRequisitionDetail? _detail;
  bool _loading = true;
  bool _actioning = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final detail = await MobileMssRequisitionService.detail(widget.requestId);
      if (!mounted) return;
      setState(() {
        _detail = detail;
        _loading = false;
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = _message(error);
      });
    }
  }

  Future<void> _decision(String decision) async {
    final required = decision == 'REJECT' || decision == 'SEND_BACK';
    var remarks = '';
    final confirmedRemarks = await showDialog<String>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(_decisionLabel(decision)),
            content: TextField(
              onChanged: (value) => remarks = value,
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: required ? 'Remarks *' : 'Remarks',
                border: const OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  final trimmedRemarks = remarks.trim();
                  if (required && trimmedRemarks.isEmpty) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(content: Text('Remarks are required.')),
                    );
                    return;
                  }
                  Navigator.pop(dialogContext, trimmedRemarks);
                },
                style: FilledButton.styleFrom(
                  backgroundColor:
                      decision == 'APPROVE'
                          ? Mythemes.successColor
                          : Mythemes.dangerColor,
                  foregroundColor: Colors.white,
                ),
                child: Text(_decisionLabel(decision)),
              ),
            ],
          ),
    );
    if (confirmedRemarks == null || !mounted) return;
    setState(() => _actioning = true);
    try {
      await MobileMssRequisitionService.decision(
        requestId: widget.requestId,
        decision: decision,
        remarks: confirmedRemarks,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Request ${_decisionResultLabel(decision)} successfully.',
          ),
        ),
      );
      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;
      setState(() => _actioning = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_message(error))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = _detail;
    final visibleDecisions =
        detail?.availableDecisions
            .map((decision) => decision.toUpperCase())
            .where((decision) => decision == 'APPROVE' || decision == 'REJECT')
            .toSet()
            .toList() ??
        const <String>[];
    final config = _ModuleConfig.of(
      detail?.item.module ?? widget.requestId.split(':').first,
    );
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Mythemes.black,
        elevation: 0.5,
        title: Text(
          '${config.label} review',
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? _MessageState(
                icon: Icons.error_outline_rounded,
                message: _error!,
                action: _load,
              )
              : detail == null
              ? const _MessageState(
                icon: Icons.inbox_outlined,
                message: 'Request not found.',
              )
              : ListView(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 105),
                children: [
                  _Section(
                    title: detail.item.employeeName,
                    children: [
                      _Row(
                        label: 'Employee ID',
                        value: detail.item.employeeCode,
                      ),
                      _Row(label: 'Department', value: detail.item.department),
                      _Row(label: 'Branch', value: detail.item.branch),
                      _Row(label: 'Request', value: detail.item.requestCode),
                      _Row(
                        label: 'Type',
                        value: detail.item.requestType.replaceAll('_', ' '),
                      ),
                      _Row(
                        label: 'Requested for',
                        value: formatUiDate(detail.item.requestedFor),
                      ),
                      _Row(label: 'Status', value: detail.item.status),
                      _Row(
                        label: 'Stage',
                        value:
                            'L${detail.item.currentLevel} of ${detail.item.totalLevels}',
                      ),
                      _Row(
                        label: 'Leave type',
                        value: _text(detail.data['leaveTypeName'], ''),
                      ),
                      _Row(
                        label: 'Days',
                        value: _text(detail.data['days'], ''),
                      ),
                      _Row(
                        label: 'Reason',
                        value: _text(
                          detail.data['reason'],
                          detail.item.summary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _Section(
                    title: 'Approval history',
                    children:
                        detail.history.isEmpty
                            ? const [Text('No workflow history available.')]
                            : detail.history.map(_HistoryRow.new).toList(),
                  ),
                ],
              ),
      bottomNavigationBar:
          detail == null || visibleDecisions.isEmpty
              ? null
              : SafeArea(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(10),
                  child:
                      _actioning
                          ? const LinearProgressIndicator()
                          : Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.end,
                            children:
                                visibleDecisions
                                    .map(
                                      (decision) => _DecisionButton(
                                        decision: decision,
                                        onPressed: () => _decision(decision),
                                      ),
                                    )
                                    .toList(),
                          ),
                ),
              ),
    );
  }
}

class _RequestTile extends StatelessWidget {
  const _RequestTile({
    required this.item,
    required this.color,
    required this.onTap,
  });
  final MssRequisitionItem item;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.12),
          child: Text(
            item.employeeName[0].toUpperCase(),
            style: TextStyle(color: color),
          ),
        ),
        title: Text(
          item.employeeName,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              [
                item.employeeCode,
                item.department,
                item.branch,
              ].where((value) => value.isNotEmpty).join('  |  '),
              style: const TextStyle(fontSize: 10),
            ),
            const SizedBox(height: 4),
            Text(
              '${item.requestType.replaceAll('_', ' ')}  |  L${item.currentLevel}/${item.totalLevels}',
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<Widget> children;
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
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const Divider(height: 20),
        ...children,
      ],
    ),
  );
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});
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
            width: 105,
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

class _HistoryRow extends StatelessWidget {
  const _HistoryRow(this.stage);
  final Map<String, dynamic> stage;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 14,
          child: Text(
            'L${_int(stage['levelNo'])}',
            style: const TextStyle(fontSize: 9),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _text(stage['profileName'], 'Approval stage'),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${_text(stage['approverName'], 'Approver')}  |  ${_text(stage['status'], 'WAITING')}',
                style: const TextStyle(fontSize: 10, color: Color(0xff667085)),
              ),
              if (_text(stage['remarks'], '').isNotEmpty)
                Text(
                  _text(stage['remarks'], ''),
                  style: const TextStyle(fontSize: 11),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _DecisionButton extends StatelessWidget {
  const _DecisionButton({required this.decision, required this.onPressed});
  final String decision;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    final approve = decision == 'APPROVE';
    final color = approve ? Mythemes.successColor : Mythemes.dangerColor;
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      icon: Icon(approve ? Icons.check_rounded : Icons.close_rounded),
      label: Text(_decisionLabel(decision)),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({required this.icon, required this.message, this.action});
  final IconData icon;
  final String message;
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
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
      ],
    ),
  );
}

class _ModuleConfig {
  const _ModuleConfig(
    this.label,
    this.familyCode,
    this.requestTypes,
    this.color,
  );
  final String label;
  final String familyCode;
  final Set<String> requestTypes;
  final Color color;

  static _ModuleConfig of(String module) => switch (module.toUpperCase()) {
    'LEAVE' => _ModuleConfig('Leave', 'LEAVE', const {
      'LEAVE_APPLICATION',
      'PARENTAL_LEAVE_ENTITLEMENT',
      'LEAVE_REVERSAL',
    }, Mythemes.successColor),
    'OD' => _ModuleConfig('On Duty', 'OD', const {
      'OD_REQUEST',
    }, Mythemes.alertColor),
    'WFH' => _ModuleConfig('Work From Home', 'ATTENDANCE', const {
      'WORK_FROM_HOME',
    }, Mythemes.stepColor),
    _ => _ModuleConfig('Comp Off', 'LEAVE', const {
      'COMP_OFF',
    }, Mythemes.warningColor),
  };
}

String _decisionLabel(String decision) => switch (decision) {
  'APPROVE' => 'Approve',
  'REJECT' => 'Reject',
  'SEND_BACK' => 'Send back',
  'FORWARD' => 'Forward',
  _ => decision,
};

String _decisionResultLabel(String decision) => switch (decision) {
  'APPROVE' => 'approved',
  'REJECT' => 'rejected',
  'SEND_BACK' => 'sent back',
  'FORWARD' => 'forwarded',
  _ => 'updated',
};

String _message(Object error) {
  final value = error.toString();
  final separator = value.indexOf(': ');
  return separator < 0 ? value : value.substring(separator + 2);
}

int _int(dynamic value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String _text(dynamic value, String fallback) {
  final text = value?.toString().trim() ?? '';
  return text.isEmpty ? fallback : text;
}
