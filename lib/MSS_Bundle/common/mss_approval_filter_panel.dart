import 'package:flutter/material.dart';

import '../../services/mobile_mss_approval_filter_service.dart';
import '../../sharedPrefancePage/ShardPre.dart';
import '../../themes/empThemes.dart';

class MssApprovalFilterValue {
  const MssApprovalFilterValue({
    this.search = '',
    this.requestType,
    this.stage,
    this.branch,
  });

  final String search;
  final MssApprovalFilterOption? requestType;
  final MssApprovalFilterOption? stage;
  final MssApprovalFilterOption? branch;
}

class MssApprovalFilterPanel extends StatefulWidget {
  const MssApprovalFilterPanel({
    super.key,
    required this.total,
    required this.onChanged,
    this.organisationId,
    this.pending,
    this.approved = 0,
    this.rejected = 0,
    this.moduleCode = 'TIME_ATTENDANCE',
    this.requestFamilyCode,
    this.allowedRequestTypeCodes,
  });

  final int? organisationId;
  final String moduleCode;
  final String? requestFamilyCode;
  final Set<String>? allowedRequestTypeCodes;
  final int total;
  final int? pending;
  final int approved;
  final int rejected;
  final ValueChanged<MssApprovalFilterValue> onChanged;

  @override
  State<MssApprovalFilterPanel> createState() =>
      _MssApprovalFilterPanelState();
}

class _MssApprovalFilterPanelState extends State<MssApprovalFilterPanel> {
  final _searchController = TextEditingController();
  MssApprovalFilterCatalog? _catalog;
  MssApprovalFilterOption? _requestType;
  MssApprovalFilterOption? _stage;
  MssApprovalFilterOption? _branch;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant MssApprovalFilterPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.organisationId != widget.organisationId ||
        oldWidget.moduleCode != widget.moduleCode) {
      _requestType = null;
      _stage = null;
      _branch = null;
      _load();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final shared = SessionManager();
    final organisationId =
        widget.organisationId ??
        await shared.getActiveOrgId() ??
        await shared.getOrgId() ??
        0;
    if (organisationId <= 0) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final catalog = await MobileMssApprovalFilterService.load(
        organisationId: organisationId,
        moduleCode: widget.moduleCode,
      );
      if (mounted) setState(() => _catalog = catalog);
    } catch (_) {
      if (mounted) _catalog = null;
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _emit() {
    widget.onChanged(
      MssApprovalFilterValue(
        search: _searchController.text.trim(),
        requestType: _requestType,
        stage: _stage,
        branch: _branch,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalog = _catalog;
    final requestTypes = (catalog?.requestTypes ?? const <MssApprovalFilterOption>[])
        .where(
          (item) =>
              widget.requestFamilyCode == null ||
              item.familyCode == widget.requestFamilyCode,
        )
        .where(
          (item) =>
              widget.allowedRequestTypeCodes == null ||
              widget.allowedRequestTypeCodes!.contains(item.code.toUpperCase()),
        )
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          childAspectRatio: .92,
          children: [
            _metric('Total', widget.total, const Color(0xff64748b)),
            _metric(
              'Pending',
              widget.pending ?? widget.total,
              const Color(0xffe89a22),
            ),
            _metric('Approved', widget.approved, const Color(0xff36a657)),
            _metric('Rejected', widget.rejected, const Color(0xffd83b34)),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _searchController,
          onChanged: (_) => _emit(),
          decoration: InputDecoration(
            hintText: 'Search employee, ID or department',
            prefixIcon: const Icon(Icons.search, size: 20),
            suffixIcon:
                _searchController.text.isEmpty
                    ? null
                    : IconButton(
                      tooltip: 'Clear search',
                      icon: const Icon(Icons.close, size: 19),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                        _emit();
                      },
                    ),
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (_loading)
          const LinearProgressIndicator(minHeight: 2)
        else
          Row(
            children: [
              Expanded(
                child: _dropdown(
                  hint: 'Type',
                  value: _requestType,
                  items: requestTypes,
                  onChanged: (value) {
                    setState(() => _requestType = value);
                    _emit();
                  },
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _dropdown(
                  hint: 'Stage',
                  value: _stage,
                  items: catalog?.stages ?? const [],
                  onChanged: (value) {
                    setState(() => _stage = value);
                    _emit();
                  },
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _dropdown(
                  hint: 'Branch',
                  value: _branch,
                  items: catalog?.branches ?? const [],
                  onChanged: (value) {
                    setState(() => _branch = value);
                    _emit();
                  },
                ),
              ),
            ],
          ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _metric(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: color, width: 3)),
        boxShadow: const [
          BoxShadow(color: Color(0x12000000), blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '$value',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color),
            ),
          ),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(label, style: const TextStyle(fontSize: 10, color: Color(0xff667085))),
          ),
        ],
      ),
    );
  }

  Widget _dropdown({
    required String hint,
    required MssApprovalFilterOption? value,
    required List<MssApprovalFilterOption> items,
    required ValueChanged<MssApprovalFilterOption?> onChanged,
  }) {
    return DropdownButtonFormField<MssApprovalFilterOption>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: hint,
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: [
        DropdownMenuItem(value: null, child: Text('All $hint')),
        ...items.map(
          (item) => DropdownMenuItem(
            value: item,
            child: Text(item.label, overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
      onChanged: onChanged,
      icon: const Icon(Icons.keyboard_arrow_down, size: 18),
      style: TextStyle(fontSize: 11, color: Mythemes.black),
    );
  }
}
