import 'package:er_flutter_project/commanScreen/punchInOutScreen.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:er_flutter_project/ess/myAllReports.dart';
import 'package:er_flutter_project/modules/payroll/salarySlip/salarySlipService.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/attendanceRequisition/getAttendanceDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:intl/intl.dart';

class SalarySlipDownload extends StatefulWidget {
  const SalarySlipDownload({super.key});

  @override
  State<SalarySlipDownload> createState() => _SalarySlipDownloadState();
}

class _SalarySlipDownloadState extends State<SalarySlipDownload> {
  final SalarySlipService _service = SalarySlipService();
  final SalarySlipDownloadService _downloadService = SalarySlipDownloadService();
  final Set<int> _downloading = <int>{};

  SalarySlipResponse? _response;
  SalarySlipItem? _selectedSlip;
  bool _loading = true;
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
      final response = await _service.load();
      if (!mounted) return;
      setState(() {
        _response = response;
        _selectedSlip = response.slips.isEmpty ? null : response.slips.first;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString().replaceFirst(RegExp(r'^[^:]+:\s*'), '');
        _loading = false;
      });
    }
  }

  Future<void> _download(SalarySlipItem slip) async {
    if (_downloading.contains(slip.id)) return;
    setState(() => _downloading.add(slip.id));
    try {
      final result = await _downloadService.save(slip);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${result.fileName} saved in ${result.location}.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString().replaceFirst('FileSystemException: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _downloading.remove(slip.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salary Slip'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Refresh',
            onPressed: _loading ? null : _load,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _bottomNavigation(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return _errorState();

    final slips = _response?.slips ?? <SalarySlipItem>[];
    if (slips.isEmpty) {
      return RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const <Widget>[
            SizedBox(height: 180),
            Icon(Icons.receipt_long_outlined, size: 46, color: Colors.grey),
            SizedBox(height: 12),
            Center(child: Text('Salary slip not released.')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 154,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              scrollDirection: Axis.horizontal,
              itemCount: slips.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) => _slipCard(slips[index]),
            ),
          ),
          Expanded(child: _preview()),
        ],
      ),
    );
  }

  Widget _errorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.error_outline, size: 42, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _load,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slipCard(SalarySlipItem slip) {
    final selected = identical(_selectedSlip, slip) || _selectedSlip?.id == slip.id;
    final downloading = _downloading.contains(slip.id);
    return InkWell(
      onTap: () => setState(() => _selectedSlip = slip),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEAF6FF) : Colors.white,
          border: Border.all(color: selected ? Colors.lightBlue : const Color(0xFFE1E5EA)),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const <BoxShadow>[
            BoxShadow(color: Color(0x22000000), blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    slip.title.isEmpty ? 'Salary Slip' : slip.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              <String>[slip.employeeCode, slip.status]
                  .where((value) => value.trim().isNotEmpty)
                  .join('  |  '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
            ),
            const Spacer(),
            Row(
              children: <Widget>[
                Text(
                  _generatedText(slip.generatedAt),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'View',
                  onPressed: () => setState(() => _selectedSlip = slip),
                  icon: const Icon(Icons.visibility_outlined, size: 20),
                ),
                downloading
                    ? const SizedBox(
                        width: 40,
                        height: 40,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        tooltip: 'Download',
                        onPressed: slip.isActive ? () => _download(slip) : null,
                        icon: const Icon(Icons.download_outlined, size: 22),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _preview() {
    final slip = _selectedSlip;
    if (slip == null || slip.documentUrl.isEmpty) {
      return const Center(child: Text('Select salary slip to preview.'));
    }
    return PDF().cachedFromUrl(
      slip.documentUrl,
      placeholder: (progress) => Center(child: Text('$progress %')),
      errorWidget: (error) => Center(child: Text(error.toString(), textAlign: TextAlign.center)),
    );
  }

  String _generatedText(String value) {
    if (value.isEmpty) return '';
    try {
      final parsed = DateFormat('yyyy-MM-dd HH:mm:ss').parse(value);
      return DateFormat('dd MMM yy').format(parsed);
    } catch (_) {
      return value;
    }
  }

  Widget _bottomNavigation() => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) Navigator.push(context, MaterialPageRoute(builder: (_) => PunchInOUtActivity(selectedIndex: 0)));
          if (index == 1) Navigator.push(context, MaterialPageRoute(builder: (_) => PunchInOUtActivity(selectedIndex: 1)));
          if (index == 2) Navigator.push(context, MaterialPageRoute(builder: (_) => GetAttendanceDet(showAppBar: true)));
          if (index == 3) Navigator.push(context, MaterialPageRoute(builder: (_) => MyAllReportsPage(showAppBar: true)));
          if (index == 4) Navigator.pushNamed(context, MyRoutings.essDashboardNavigateRoute);
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.manage_accounts_outlined), label: 'Workflow'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.app_badge_fill), label: 'My Requests'),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.doc_chart), label: 'My Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        ],
      );
}
