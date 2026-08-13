import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'eDocService.dart';
import 'modalClass/eDocModels.dart';

class DownloadLetters extends StatefulWidget {
  const DownloadLetters(this.docId, this.docName, {this.document, super.key});

  final Object docId;
  final Object docName;
  final EDocDocument? document;

  @override
  State<DownloadLetters> createState() => _DownloadLettersState();
}

class _DownloadLettersState extends State<DownloadLetters> {
  final EDocDownloadService _downloadService = EDocDownloadService();
  bool _downloading = false;

  Future<void> _download() async {
    final document = widget.document;
    if (document == null || _downloading) return;
    setState(() => _downloading = true);
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
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final document = widget.document;
    return Scaffold(
      appBar: AppBar(
        title: Text(document?.documentName ?? widget.docName.toString(), overflow: TextOverflow.ellipsis),
        actions: <Widget>[
          if (_downloading)
            const SizedBox(width: 48, child: Padding(padding: EdgeInsets.all(14), child: CircularProgressIndicator(strokeWidth: 2)))
          else
            IconButton(tooltip: 'Download', onPressed: document?.canDownload == true ? _download : null, icon: const Icon(Icons.download_outlined)),
        ],
      ),
      body: document == null ? const Center(child: Text('Document is not available.')) : _preview(document),
    );
  }

  Widget _preview(EDocDocument document) {
    if (document.isPdf) {
      return SfPdfViewer.network(
        document.viewUrl,
        canShowPaginationDialog: true,
        canShowScrollHead: true,
        onDocumentLoadFailed: (details) => _showError(details.description),
      );
    }
    if (document.isImage) {
      return Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 5,
          child: Image.network(
            document.viewUrl,
            fit: BoxFit.contain,
            loadingBuilder: (_, child, progress) => progress == null ? child : const Center(child: CircularProgressIndicator()),
            errorBuilder: (_, __, ___) => const Center(child: Text('Unable to load image.', style: TextStyle(color: Colors.white))),
          ),
        ),
      );
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          const Icon(Icons.description_outlined, size: 64, color: Colors.teal),
          const SizedBox(height: 12),
          Text(document.fileName, textAlign: TextAlign.center),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () => launchUrl(Uri.parse(document.viewUrl), mode: LaunchMode.externalApplication),
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open Document'),
          ),
        ]),
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
