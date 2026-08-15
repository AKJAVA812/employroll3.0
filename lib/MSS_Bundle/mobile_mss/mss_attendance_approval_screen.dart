import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';

import '../../services/mobile_mss_attendance_approval_service.dart';
import '../../themes/empThemes.dart';
import '../../utils/ui_date_formatter.dart';
import '../common/mss_approval_filter_panel.dart';

class MssAttendanceApprovalScreen extends StatefulWidget {
  const MssAttendanceApprovalScreen({super.key});

  @override
  State<MssAttendanceApprovalScreen> createState() =>
      _MssAttendanceApprovalScreenState();
}

class _MssAttendanceApprovalScreenState
    extends State<MssAttendanceApprovalScreen> {
  final List<MssAttendanceApprovalItem> _items = [];
  Timer? _searchDebounce;
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

  @override
  void initState() {
    super.initState();
    _load(reset: true);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  Future<void> _load({required bool reset}) async {
    if (reset) {
      setState(() {
        _loading = true;
        _error = null;
      });
    } else {
      if (_loadingMore || _last) return;
      setState(() => _loadingMore = true);
    }
    try {
      final result = await MobileMssAttendanceApprovalService.list(
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

  void _changeTab(String value) {
    if (_tab == value) return;
    setState(() => _tab = value);
    _load(reset: true);
  }

  void _applyFilters(MssApprovalFilterValue filters) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      _search = filters.search.isEmpty ? null : filters.search;
      _requestType = filters.requestType?.code;
      _stage = int.tryParse(filters.stage?.id?.toString() ?? '');
      _branch = filters.branch?.label;
      _load(reset: true);
    });
  }

  Future<void> _openDetail(MssAttendanceApprovalItem item) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder:
            (_) => MssAttendanceApprovalDetailScreen(requisitionId: item.id),
      ),
    );
    if (changed == true) await _load(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Mythemes.black,
        elevation: 0.5,
        titleSpacing: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attendance approvals',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            Text(
              'Team requisitions',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
            ),
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
              thumbColor: Mythemes.lightBluishColor,
              backgroundColor: Colors.white,
              children: {
                'pending': _tabLabel('Pending', _summary['pending'] ?? 0),
                'actioned': _tabLabel('Actioned', _summary['actioned'] ?? 0),
              },
              onValueChanged: (value) {
                if (value != null) _changeTab(value);
              },
            ),
            const SizedBox(height: 12),
            MssApprovalFilterPanel(
              total: _summary['total'] ?? 0,
              pending: _summary['pending'] ?? 0,
              approved: _summary['approved'] ?? 0,
              rejected: _summary['rejected'] ?? 0,
              requestFamilyCode: 'ATTENDANCE',
              onChanged: _applyFilters,
            ),
            if (_loading)
              const Padding(
                padding: EdgeInsets.only(top: 70),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              _ErrorState(message: _error!, onRetry: () => _load(reset: true))
            else if (_items.isEmpty)
              const _EmptyState()
            else ...[
              ..._items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _ApprovalRequestTile(
                    item: item,
                    onTap: () => _openDetail(item),
                  ),
                ),
              ),
              if (!_last)
                Center(
                  child: TextButton.icon(
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
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tabLabel(String label, int count) {
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

class MssAttendanceApprovalDetailScreen extends StatefulWidget {
  const MssAttendanceApprovalDetailScreen({
    super.key,
    required this.requisitionId,
  });

  final int requisitionId;

  @override
  State<MssAttendanceApprovalDetailScreen> createState() =>
      _MssAttendanceApprovalDetailScreenState();
}

class _MssAttendanceApprovalDetailScreenState
    extends State<MssAttendanceApprovalDetailScreen> {
  MssAttendanceApprovalDetail? _detail;
  bool _loading = true;
  bool _actioning = false;
  bool _downloading = false;
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
      final detail = await MobileMssAttendanceApprovalService.detail(
        widget.requisitionId,
      );
      if (!mounted) return;
      setState(() {
        _detail = detail;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = _message(error);
      });
    }
  }

  Future<void> _performAction(String action) async {
    final remarksRequired = action == 'REJECT' || action == 'SEND_BACK';
    var remarks = '';
    final confirmedRemarks = await showDialog<String>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(_actionLabel(action)),
            content: TextField(
              onChanged: (value) => remarks = value,
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: remarksRequired ? 'Remarks *' : 'Remarks',
                hintText: 'Add decision remarks',
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
                  if (remarksRequired && trimmedRemarks.isEmpty) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(content: Text('Remarks are required.')),
                    );
                    return;
                  }
                  Navigator.pop(dialogContext, trimmedRemarks);
                },
                child: const Text('Confirm'),
              ),
            ],
          ),
    );
    if (confirmedRemarks == null || !mounted) return;
    setState(() => _actioning = true);
    try {
      await MobileMssAttendanceApprovalService.action(
        requisitionId: widget.requisitionId,
        action: action,
        remarks: confirmedRemarks,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request ${_actionResultLabel(action)} successfully.'),
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

  Future<void> _download() async {
    setState(() => _downloading = true);
    try {
      final path = await MobileMssAttendanceApprovalService.downloadAttachment(
        widget.requisitionId,
      );
      await OpenFile.open(path);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_message(error))));
      }
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = _detail;
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Mythemes.black,
        elevation: 0.5,
        title: const Text(
          'Request review',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? _ErrorState(message: _error!, onRetry: _load)
              : detail == null
              ? const _EmptyState()
              : ListView(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 110),
                children: [
                  _DetailHeader(item: detail.item),
                  const SizedBox(height: 10),
                  _DetailSection(
                    title: 'Request details',
                    children: [
                      _DetailRow(
                        label: 'Request',
                        value: detail.item.requestCode,
                      ),
                      _DetailRow(label: 'Type', value: detail.item.requestType),
                      _DetailRow(
                        label: 'Requested for',
                        value: formatUiDate(detail.item.requestedFor),
                      ),
                      _DetailRow(label: 'Status', value: detail.item.status),
                      _DetailRow(
                        label: 'Stage',
                        value:
                            'L${detail.item.currentLevel} of ${detail.item.totalLevels}',
                      ),
                      _DetailRow(
                        label: 'Requested in',
                        value: _text(detail.data['requestedIn'], '-'),
                      ),
                      _DetailRow(
                        label: 'Requested out',
                        value: _text(detail.data['requestedOut'], '-'),
                      ),
                      _DetailRow(
                        label: 'Actual in/out',
                        value:
                            '${_text(detail.data['actualIn'], '-')} / ${_text(detail.data['actualOut'], '-')}',
                      ),
                      _DetailRow(
                        label: 'Reason',
                        value: _text(
                          detail.data['reason'],
                          detail.item.summary,
                        ),
                      ),
                    ],
                  ),
                  if (detail.attachments.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    _DetailSection(
                      title: 'Attachments',
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.attach_file_rounded),
                          title: Text(
                            _text(
                              detail.attachments.first['name'],
                              'Supporting document',
                            ),
                          ),
                          trailing: IconButton(
                            tooltip: 'Open attachment',
                            onPressed: _downloading ? null : _download,
                            icon:
                                _downloading
                                    ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Icon(Icons.download_rounded),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 10),
                  _DetailSection(
                    title: 'Approval history',
                    children:
                        detail.history.isEmpty
                            ? const [Text('No workflow history available.')]
                            : detail.history.map(_historyItem).toList(),
                  ),
                ],
              ),
      bottomNavigationBar:
          detail == null || detail.availableActions.isEmpty
              ? null
              : SafeArea(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child:
                      _actioning
                          ? const LinearProgressIndicator()
                          : Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.end,
                            children:
                                detail.availableActions
                                    .map(
                                      (action) => _ActionButton(
                                        action: action,
                                        onPressed: () => _performAction(action),
                                      ),
                                    )
                                    .toList(),
                          ),
                ),
              ),
    );
  }

  Widget _historyItem(Map<String, dynamic> stage) {
    final status = _text(stage['status'], 'WAITING').toUpperCase();
    final color =
        status.contains('APPROV')
            ? Mythemes.successColor
            : status.contains('REJECT') || status.contains('SENT_BACK')
            ? Mythemes.dangerColor
            : Mythemes.warningColor;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Text(
              'L${_int(stage['levelNo'])}',
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
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
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${_text(stage['approverName'], 'Approver')}  |  $status',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xff667085),
                  ),
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
}

class _ApprovalRequestTile extends StatelessWidget {
  const _ApprovalRequestTile({required this.item, required this.onTap});

  final MssAttendanceApprovalItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Mythemes.lightBluishColor.withOpacity(0.12),
                child: Text(
                  item.employeeName.isEmpty
                      ? 'E'
                      : item.employeeName[0].toUpperCase(),
                  style: TextStyle(
                    color: Mythemes.lightBluishColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.employeeName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        _StatusLabel(status: item.status),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      [
                        item.employeeCode,
                        item.department,
                        item.branch,
                      ].where((value) => value.isNotEmpty).join('  |  '),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xff667085),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.requestType.replaceAll('_', ' '),
                            style: TextStyle(
                              fontSize: 11,
                              color: Mythemes.successColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          'L${item.currentLevel}/${item.totalLevels}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (item.hasAttachment) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.attach_file_rounded, size: 15),
                        ],
                      ],
                    ),
                    if (item.requestedFor.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        formatUiDate(item.requestedFor),
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right_rounded, color: Color(0xff98a2b3)),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.item});

  final MssAttendanceApprovalItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Mythemes.lightBluishColor.withOpacity(0.12),
            child: Text(item.employeeName[0].toUpperCase()),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.employeeName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  [
                    item.employeeCode,
                    item.department,
                    item.branch,
                  ].where((value) => value.isNotEmpty).join('  |  '),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xff667085),
                  ),
                ),
              ],
            ),
          ),
          _StatusLabel(status: item.status),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
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
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
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
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.action, required this.onPressed});

  final String action;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final destructive = action == 'REJECT';
    final primary = action == 'APPROVE' || action == 'FORWARD';
    final icon = switch (action) {
      'APPROVE' => Icons.check_rounded,
      'REJECT' => Icons.close_rounded,
      'SEND_BACK' => Icons.undo_rounded,
      _ => Icons.forward_rounded,
    };
    if (primary) {
      return FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(_actionLabel(action)),
      );
    }
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 18,
        color: destructive ? Mythemes.dangerColor : null,
      ),
      label: Text(
        _actionLabel(action),
        style: TextStyle(color: destructive ? Mythemes.dangerColor : null),
      ),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color =
        status.contains('APPROV')
            ? Mythemes.successColor
            : status.contains('REJECT') || status.contains('DISAPPROV')
            ? Mythemes.dangerColor
            : Mythemes.warningColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 9,
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 55),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 36,
            color: Mythemes.dangerColor,
          ),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 42, color: Color(0xff98a2b3)),
          SizedBox(height: 8),
          Text('No attendance requests found.'),
        ],
      ),
    );
  }
}

String _actionLabel(String action) => switch (action) {
  'APPROVE' => 'Approve',
  'REJECT' => 'Reject',
  'SEND_BACK' => 'Send back',
  'FORWARD' => 'Forward',
  _ => action,
};

String _actionResultLabel(String action) => switch (action) {
  'APPROVE' => 'approved',
  'REJECT' => 'rejected',
  'SEND_BACK' => 'sent back',
  'FORWARD' => 'forwarded',
  _ => 'updated',
};

String _message(Object error) {
  final value = error.toString();
  final separator = value.indexOf(': ');
  return separator == -1 ? value : value.substring(separator + 2);
}

int _int(dynamic value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String _text(dynamic value, String fallback) {
  final text = value?.toString().trim() ?? '';
  return text.isEmpty ? fallback : text;
}
