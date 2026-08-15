import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/mobile_api_foundation.dart';
import '../../services/mobile_mss_lifecycle_service.dart';
import '../../themes/empThemes.dart';
import '../../utils/ui_date_formatter.dart';

class MssLifecycleScreen extends StatefulWidget {
  const MssLifecycleScreen({super.key, required this.module});
  final String module;

  @override
  State<MssLifecycleScreen> createState() => _MssLifecycleScreenState();
}

class _MssLifecycleScreenState extends State<MssLifecycleScreen> {
  final _search = TextEditingController();
  final List<Map<String, dynamic>> _items = [];
  Timer? _debounce;
  String _tab = 'PENDING';
  Map<String, int> _summary = const {};
  int _page = 0;
  bool _last = true;
  bool _loading = true;
  bool _more = false;
  String? _error;

  String get _title =>
      widget.module == 'INDUCTION' ? 'Induction approvals' : 'Exit approvals';

  @override
  void initState() {
    super.initState();
    _load(reset: true);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  Future<void> _load({required bool reset}) async {
    if (reset) {
      setState(() {
        _loading = true;
        _error = null;
      });
    } else {
      if (_last || _more) return;
      setState(() => _more = true);
    }
    try {
      final result =
          _tab == 'EMPLOYEES'
              ? await MobileMssLifecycleService.exitEmployees(
                page: reset ? 0 : _page + 1,
                search:
                    _search.text.trim().isEmpty ? null : _search.text.trim(),
              )
              : await MobileMssLifecycleService.list(
                module: widget.module,
                tab: _tab,
                page: reset ? 0 : _page + 1,
                search:
                    _search.text.trim().isEmpty ? null : _search.text.trim(),
              );
      if (!mounted) return;
      setState(() {
        if (reset) _items.clear();
        _items.addAll(result.items);
        _summary = result.summary;
        _page = reset ? 0 : _page + 1;
        _last = result.last;
        _loading = false;
        _more = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _more = false;
        _error = _message(error);
      });
    }
  }

  void _onSearch(String _) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 350),
      () => _load(reset: true),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xfff6f7fb),
    appBar: AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Mythemes.black,
      elevation: 0.5,
      title: Text(
        _title,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
      ),
      actions: [
        IconButton(
          tooltip: 'Refresh',
          onPressed: () => _load(reset: true),
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
    ),
    body: RefreshIndicator(
      onRefresh: () => _load(reset: true),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        children: [
          _Summary(summary: _summary),
          const SizedBox(height: 10),
          SegmentedButton<String>(
            segments: [
              const ButtonSegment(
                value: 'PENDING',
                label: Text('Pending'),
                icon: Icon(Icons.inbox_rounded),
              ),
              const ButtonSegment(
                value: 'ACTIONED',
                label: Text('Actioned'),
                icon: Icon(Icons.task_alt_rounded),
              ),
              if (widget.module == 'EXIT')
                const ButtonSegment(
                  value: 'EMPLOYEES',
                  label: Text('Employees'),
                  icon: Icon(Icons.people_alt_rounded),
                ),
            ],
            selected: {_tab},
            onSelectionChanged: (value) {
              setState(() => _tab = value.first);
              _load(reset: true);
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _search,
            onChanged: _onSearch,
            decoration: const InputDecoration(
              hintText: 'Search employee, candidate or request ID',
              prefixIcon: Icon(Icons.search_rounded),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          if (_loading)
            const Padding(
              padding: EdgeInsets.only(top: 70),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            _Message(
              message: _error!,
              icon: Icons.error_outline_rounded,
              onTap: () => _load(reset: true),
            )
          else if (_items.isEmpty)
            const _Message(
              message: 'No requests found for the active profile.',
              icon: Icons.inbox_outlined,
            )
          else ...[
            ..._items.map(
              (item) => _RequestTile(
                item: item,
                module: _tab == 'EMPLOYEES' ? 'EXIT_CASE' : widget.module,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => MssLifecycleDetailScreen(
                            module:
                                _tab == 'EMPLOYEES'
                                    ? 'EXIT_CASE'
                                    : widget.module,
                            item: item,
                          ),
                    ),
                  );
                  _load(reset: true);
                },
              ),
            ),
            if (!_last)
              TextButton.icon(
                onPressed: _more ? null : () => _load(reset: false),
                icon:
                    _more
                        ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.expand_more_rounded),
                label: Text(_more ? 'Loading' : 'Load more'),
              ),
          ],
        ],
      ),
    ),
  );
}

class MssLifecycleDetailScreen extends StatefulWidget {
  const MssLifecycleDetailScreen({
    super.key,
    required this.module,
    required this.item,
  });
  final String module;
  final Map<String, dynamic> item;

  @override
  State<MssLifecycleDetailScreen> createState() =>
      _MssLifecycleDetailScreenState();
}

class _MssLifecycleDetailScreenState extends State<MssLifecycleDetailScreen> {
  Map<String, dynamic>? _data;
  bool _loading = true;
  bool _acting = false;
  String? _error;

  int get _id => _number(widget.item['requestId'] ?? widget.item['id']);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data =
          widget.module == 'EXIT_CASE'
              ? await MobileMssLifecycleService.exitEmployeeDetail(_id)
              : await MobileMssLifecycleService.detail(widget.module, _id);
      if (mounted)
        setState(() {
          _data = data;
          _loading = false;
          _error = null;
        });
    } catch (error) {
      if (mounted)
        setState(() {
          _loading = false;
          _error = _message(error);
        });
    }
  }

  Future<void> _decide(String decision) async {
    final remarks = await _remarks(decision);
    if (remarks == null || !mounted) return;
    setState(() => _acting = true);
    try {
      await MobileMssLifecycleService.decide(
        module: widget.module,
        requestId: _id,
        decision: decision,
        remarks: remarks,
      );
      if (!mounted) return;
      final result = decision == 'APPROVE' ? 'approved' : 'rejected';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Request $result successfully.')));
      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;
      setState(() => _acting = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_message(error))));
    }
  }

  Future<String?> _remarks(String decision) async {
    var remarks = '';
    return showDialog<String>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(
              decision == 'APPROVE' ? 'Approve request' : 'Reject request',
            ),
            content: TextField(
              onChanged: (value) => remarks = value,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                labelText:
                    decision == 'REJECT' ? 'Remarks (required)' : 'Remarks',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  final text = remarks.trim();
                  if (decision == 'REJECT' && text.isEmpty) return;
                  Navigator.pop(dialogContext, text);
                },
                child: Text(decision == 'APPROVE' ? 'Approve' : 'Reject'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wrapper = _data ?? const <String, dynamic>{};
    final request = _map(wrapper['request']);
    final history =
        (wrapper['history'] as List? ?? const []).whereType<Map>().toList();
    final canAct =
        widget.module != 'EXIT_CASE' &&
        (request['canAct'] == true || widget.item['canAct'] == true);
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Mythemes.black,
        title: const Text('Request details'),
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? _Message(
                message: _error!,
                icon: Icons.error_outline_rounded,
                onTap: _load,
              )
              : ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  _DetailCard(data: request),
                  const SizedBox(height: 10),
                  if (history.isNotEmpty) _History(rows: history),
                  if (canAct) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _acting ? null : () => _decide('REJECT'),
                            icon: const Icon(Icons.close_rounded),
                            label: const Text('Reject'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed:
                                _acting ? null : () => _decide('APPROVE'),
                            icon: const Icon(Icons.check_rounded),
                            label: const Text('Approve'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.summary});
  final Map<String, int> summary;
  @override
  Widget build(BuildContext context) {
    final employeeOnly =
        !summary.containsKey('pending') && summary.containsKey('total');
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffe4e7ec)),
      ),
      child:
          employeeOnly
              ? _metric(
                'Exit employees',
                summary['total'] ?? 0,
                Mythemes.lightBluishColor,
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _metric(
                    'Pending',
                    summary['pending'] ?? 0,
                    Mythemes.lightBluishColor,
                  ),
                  _metric(
                    'Approved',
                    summary['approved'] ?? 0,
                    Mythemes.successColor,
                  ),
                  _metric('Rejected', summary['rejected'] ?? 0, Colors.red),
                ],
              ),
    );
  }

  Widget _metric(String label, int value, Color color) => Column(
    children: [
      Text(
        '$value',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
      Text(label, style: const TextStyle(fontSize: 11)),
    ],
  );
}

class _RequestTile extends StatelessWidget {
  const _RequestTile({
    required this.item,
    required this.module,
    required this.onTap,
  });
  final Map<String, dynamic> item;
  final String module;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final name = _text(
      item[module == 'INDUCTION'
          ? 'candidateName'
          : module == 'EXIT_CASE'
          ? 'employeeName'
          : 'empName'],
      'Unknown',
    );
    final code = _text(
      item[module == 'INDUCTION'
          ? 'candidateCode'
          : module == 'EXIT_CASE'
          ? 'employeeCode'
          : 'empCode'],
      '',
    );
    final status = _text(item['approvalStatus'] ?? item['status'], 'Pending');
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Mythemes.lightBluishColor.withOpacity(.12),
          child: Icon(
            module == 'INDUCTION'
                ? Icons.person_add_alt_1_rounded
                : Icons.logout_rounded,
            color: Mythemes.lightBluishColor,
          ),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(
          [
            code,
            status.replaceAll('_', ' '),
          ].where((e) => e.isNotEmpty).join(' | '),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.data});
  final Map<String, dynamic> data;
  @override
  Widget build(BuildContext context) {
    final hidden = {'offer', 'history', 'decisions', 'approvalChain', 'canAct'};
    final rows =
        data.entries
            .where(
              (entry) =>
                  !hidden.contains(entry.key) &&
                  entry.value != null &&
                  entry.value.toString().isNotEmpty,
            )
            .toList();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffe4e7ec)),
      ),
      child: Column(
        children:
            rows
                .map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            _label(entry.key),
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _detailValue(entry.key, entry.value),
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}

class _History extends StatelessWidget {
  const _History({required this.rows});
  final List<Map> rows;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xffe4e7ec)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Approval history',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        ...rows.map(
          (row) => ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            leading: const Icon(Icons.history_rounded),
            title: Text(
              _text(
                row['approverName'] ?? row['actorName'] ?? row['actor'],
                'Approval level ${row['level'] ?? ''}',
              ),
            ),
            subtitle: Text(_text(row['remarks'], 'No remarks')),
            trailing: Text(_text(row['status'] ?? row['decision'], '')),
          ),
        ),
      ],
    ),
  );
}

class _Message extends StatelessWidget {
  const _Message({required this.message, required this.icon, this.onTap});
  final String message;
  final IconData icon;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 70),
    child: Column(
      children: [
        Icon(icon, size: 38, color: Colors.black38),
        const SizedBox(height: 8),
        Text(message, textAlign: TextAlign.center),
        if (onTap != null)
          TextButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
      ],
    ),
  );
}

Map<String, dynamic> _map(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};
int _number(dynamic value) =>
    value is num
        ? value.toInt()
        : int.tryParse(value?.toString().replaceAll(RegExp(r'\D'), '') ?? '') ??
            0;
String _text(dynamic value, String fallback) {
  final text = value?.toString().trim() ?? '';
  return text.isEmpty ? fallback : text;
}

String _detailValue(String key, dynamic value) {
  final normalizedKey = key.toLowerCase();
  return normalizedKey.contains('date') || normalizedKey == 'dob'
      ? formatUiDate(value)
      : value.toString();
}

String _label(String value) =>
    value
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}')
        .replaceAll('_', ' ')
        .trim();
String _message(Object error) =>
    error is MobileApiException && error.message != null
        ? error.message!
        : 'Unable to complete the request.';
