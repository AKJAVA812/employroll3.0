import 'package:er_flutter_project/commanScreen/punchInOutScreen.dart';
import 'package:er_flutter_project/commanScreen/routes.dart';
import 'package:er_flutter_project/ess/myAllReports.dart';
import 'package:er_flutter_project/modules/payroll/salarySlip/salarySlipService.dart';
import 'package:er_flutter_project/modules/timeAndAttendance/reports/attendanceRequisition/getAttendanceDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'downloadLetter.dart';
import 'eDocService.dart';
import 'modalClass/eDocModels.dart';

class DocumentsAdded extends StatefulWidget {
  const DocumentsAdded({super.key});

  @override
  State<DocumentsAdded> createState() => _DocumentsAddedState();
}

class _DocumentsAddedState extends State<DocumentsAdded> {
  final EDocService _service = EDocService();
  final EDocDownloadService _downloadService = EDocDownloadService();
  final SalarySlipService _salarySlipService = SalarySlipService();
  final SalarySlipDownloadService _salaryDownloadService = SalarySlipDownloadService();
  final TextEditingController _searchController = TextEditingController();

  EDocResponse? _response;
  SalarySlipResponse? _salarySlipResponse;
  String? _error;
  String? _salarySlipError;
  bool _loading = true;
  String _query = '';
  final Set<int> _downloading = <int>{};
  final Set<String> _salaryDownloading = <String>{};

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final response = await _service.load();
      SalarySlipResponse? salarySlipResponse;
      String? salarySlipError;
      try {
        salarySlipResponse = await _salarySlipService.load();
      } catch (error) {
        salarySlipError = error.toString().replaceFirst(RegExp(r'^[^:]+:\s*'), '');
      }
      if (!mounted) return;
      setState(() {
        _response = response;
        _salarySlipResponse = salarySlipResponse;
        _salarySlipError = salarySlipError;
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

  List<EDocDocument> _documentsFor(int? typeId) {
    final documents = _response?.documents ?? <EDocDocument>[];
    return documents.where((document) {
      final matchesType = typeId == null || document.docTypeId == typeId;
      final text = '${document.documentName} ${document.documentType} ${document.letterPeriod}'.toLowerCase();
      return matchesType && text.contains(_query.toLowerCase());
    }).toList();
  }

  List<SalarySlipItem> _salarySlips() {
    final slips = _salarySlipResponse?.slips ?? <SalarySlipItem>[];
    if (_query.isEmpty) return slips;
    final query = _query.toLowerCase();
    return slips.where((slip) {
      final text = '${slip.title} ${slip.employeeCode} ${slip.employeeName} ${slip.generatedAt}'.toLowerCase();
      return text.contains(query);
    }).toList();
  }

  Future<void> _download(EDocDocument document) async {
    if (_downloading.contains(document.id)) return;
    setState(() => _downloading.add(document.id));
    try {
      final result = await _downloadService.save(document);
      if (!mounted) return;
      final time = DateFormat('HH:mm:ss').format(DateTime.now());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${result.fileName} saved in ${result.location} at $time.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString().replaceFirst('FileSystemException: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _downloading.remove(document.id));
    }
  }

  void _view(EDocDocument document) {
    if (!document.canView || document.viewUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Document preview is not available.')));
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => DownloadLetters(document.id, document.documentName, document: document),
    ));
  }

  Future<void> _downloadSalarySlip(SalarySlipItem slip) async {
    final key = _salarySlipKey(slip);
    if (_salaryDownloading.contains(key)) return;
    setState(() => _salaryDownloading.add(key));
    try {
      final result = await _salaryDownloadService.save(slip);
      if (!mounted) return;
      final time = DateFormat('HH:mm:ss').format(DateTime.now());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${result.fileName} saved in ${result.location} at $time.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString().replaceFirst('FileSystemException: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _salaryDownloading.remove(key));
    }
  }

  void _viewSalarySlip(SalarySlipItem slip) {
    if (slip.documentUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Salary slip preview is not available.')));
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => _SalarySlipPreviewPage(slip: slip)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Doc'),
        actions: <Widget>[
          IconButton(tooltip: 'Refresh', onPressed: _loading ? null : _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _bottomNavigation(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            const Icon(Icons.error_outline, size: 40, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(onPressed: _load, icon: const Icon(Icons.refresh), label: const Text('Retry')),
          ]),
        ),
      );
    }

    final types = _response?.documentTypes ?? <EDocType>[];
    final tabIds = <int?>[null, ...types.map((type) => type.id)];
    final salarySlips = _salarySlips();
    return DefaultTabController(
      key: ValueKey<String>('${tabIds.join(',')}:${salarySlips.length}:${_salarySlipError ?? ''}'),
      length: tabIds.length + 1,
      child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value.trim()),
            decoration: InputDecoration(
              hintText: 'Search documents',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                      icon: const Icon(Icons.close),
                    ),
              border: const OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: <Widget>[
            Tab(text: 'All (${_response?.documents.length ?? 0})'),
            ...types.map((type) => Tab(text: '${type.name} (${type.count})')),
            Tab(text: 'Salary Slip (${salarySlips.length})'),
          ],
        ),
        Expanded(
          child: TabBarView(children: <Widget>[
            ...tabIds.map((typeId) => _documentList(_documentsFor(typeId))),
            _salarySlipList(salarySlips),
          ]),
        ),
      ]),
    );
  }

  Widget _documentList(List<EDocDocument> documents) {
    if (documents.isEmpty) return const Center(child: Text('No documents available.'));
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: documents.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final document = documents[index];
          final downloading = _downloading.contains(document.id);
          return Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            child: ListTile(
              onTap: () => _view(document),
              leading: Icon(document.isPdf ? Icons.picture_as_pdf : document.isImage ? Icons.image_outlined : Icons.description_outlined,
                  color: document.isPdf ? Colors.redAccent : document.isImage ? Colors.blue : Colors.teal),
              title: Text(document.documentName, maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: Text(
                <String>[document.fileExtension.toUpperCase(), document.letterPeriod, document.creationDate]
                    .where((value) => value.isNotEmpty).join('  |  '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                IconButton(tooltip: 'View', onPressed: document.canView ? () => _view(document) : null, icon: const Icon(Icons.visibility_outlined)),
                downloading
                    ? const SizedBox(width: 40, height: 40, child: Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator(strokeWidth: 2)))
                    : IconButton(tooltip: 'Download', onPressed: document.canDownload ? () => _download(document) : null, icon: const Icon(Icons.download_outlined)),
              ]),
            ),
          );
        },
      ),
    );
  }

  Widget _salarySlipList(List<SalarySlipItem> slips) {
    if (_salarySlipError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            const Icon(Icons.error_outline, size: 40, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(_salarySlipError!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(onPressed: _load, icon: const Icon(Icons.refresh), label: const Text('Retry')),
          ]),
        ),
      );
    }
    if (slips.isEmpty) return const Center(child: Text('No salary slips available.'));
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: slips.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final slip = slips[index];
          final key = _salarySlipKey(slip);
          final downloading = _salaryDownloading.contains(key);
          return Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            child: ListTile(
              onTap: () => _viewSalarySlip(slip),
              leading: const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
              title: Text(
                slip.title.isEmpty ? 'Salary Slip' : slip.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                <String>['PDF', slip.employeeCode, slip.generatedAt].where((value) => value.isNotEmpty).join('  |  '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                IconButton(tooltip: 'View', onPressed: () => _viewSalarySlip(slip), icon: const Icon(Icons.visibility_outlined)),
                downloading
                    ? const SizedBox(width: 40, height: 40, child: Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator(strokeWidth: 2)))
                    : IconButton(tooltip: 'Download', onPressed: slip.documentUrl.isNotEmpty ? () => _downloadSalarySlip(slip) : null, icon: const Icon(Icons.download_outlined)),
              ]),
            ),
          );
        },
      ),
    );
  }

  String _salarySlipKey(SalarySlipItem slip) =>
      '${slip.id}:${slip.documentKey}:${slip.documentUrl}';

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

class _SalarySlipPreviewPage extends StatefulWidget {
  const _SalarySlipPreviewPage({required this.slip});

  final SalarySlipItem slip;

  @override
  State<_SalarySlipPreviewPage> createState() => _SalarySlipPreviewPageState();
}

class _SalarySlipPreviewPageState extends State<_SalarySlipPreviewPage> {
  final SalarySlipDownloadService _downloadService = SalarySlipDownloadService();
  bool _downloading = false;

  Future<void> _download() async {
    if (_downloading) return;
    setState(() => _downloading = true);
    try {
      final result = await _downloadService.save(widget.slip);
      if (!mounted) return;
      final time = DateFormat('HH:mm:ss').format(DateTime.now());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${result.fileName} saved in ${result.location} at $time.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString().replaceFirst('FileSystemException: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.slip.title.isEmpty ? 'Salary Slip' : widget.slip.title, overflow: TextOverflow.ellipsis),
        actions: <Widget>[
          if (_downloading)
            const SizedBox(width: 48, child: Padding(padding: EdgeInsets.all(14), child: CircularProgressIndicator(strokeWidth: 2)))
          else
            IconButton(tooltip: 'Download', onPressed: _download, icon: const Icon(Icons.download_outlined)),
        ],
      ),
      body: SfPdfViewer.network(
        widget.slip.documentUrl,
        canShowPaginationDialog: true,
        canShowScrollHead: true,
        onDocumentLoadFailed: (details) => _showError(details.description),
      ),
    );
  }

  void _showError(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    });
  }
}
