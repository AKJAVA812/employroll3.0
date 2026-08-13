import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:er_flutter_project/commanScreen/allAPIList.dart';
import 'package:er_flutter_project/services/mobile_api_foundation.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'package:er_flutter_project/sharedPrefancePage/ShardPre.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SalarySlipResponse {
  const SalarySlipResponse({
    required this.message,
    required this.slips,
  });

  final String message;
  final List<SalarySlipItem> slips;

  factory SalarySlipResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return SalarySlipResponse(
      message: json['message']?.toString() ?? '',
      slips: data is List
          ? (data
                .whereType<Map>()
                .map((item) => SalarySlipItem.fromJson(Map<String, dynamic>.from(item)))
                .where((item) => item.documentUrl.isNotEmpty)
                .toList()
              ..sort((a, b) => b.sortDate.compareTo(a.sortDate)))
          : <SalarySlipItem>[],
    );
  }
}

class SalarySlipItem {
  const SalarySlipItem({
    required this.id,
    required this.employeeName,
    required this.employeeCode,
    required this.payslipMonth,
    required this.payrollMonth,
    required this.status,
    required this.documentUrl,
    required this.documentKey,
    required this.generatedAt,
  });

  final int id;
  final String employeeName;
  final String employeeCode;
  final String payslipMonth;
  final String payrollMonth;
  final String status;
  final String documentUrl;
  final String documentKey;
  final String generatedAt;

  factory SalarySlipItem.fromJson(Map<String, dynamic> json) {
    final url = _cleanUrl(
      _firstText(json, const [
        'salarySlipPath',
        'letter',
        'salarySlipUrl',
        'downloadUrl',
        'viewUrl',
      ]),
    );
    return SalarySlipItem(
      id: _toInt(json['id']),
      employeeName: _firstText(json, const ['employeeName', 'name']),
      employeeCode: _firstText(json, const ['employeeCode', 'employeeId']),
      payslipMonth: _firstText(json, const ['payslipMonth', 'letterPeriod']),
      payrollMonth: _firstText(json, const ['payrollMonth']),
      status: _firstText(json, const ['status']),
      documentUrl: url,
      documentKey: _firstText(json, const ['documentKey', 'salarySlipKey', 'salaryKey']),
      generatedAt: _firstText(json, const ['pdfGeneratedAt', 'updationDate', 'creationDate']),
    );
  }

  String get title => payslipMonth.isNotEmpty ? payslipMonth : payrollMonth;
  bool get isActive => status.isEmpty || status.toUpperCase() == 'ACTIVE';
  DateTime get sortDate =>
      _parseDate(payrollMonth) ??
      _parseDate(generatedAt) ??
      _parseMonthYear(title) ??
      DateTime.fromMillisecondsSinceEpoch(0);

  static String _firstText(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key]?.toString().trim();
      if (value != null && value.isNotEmpty && value.toLowerCase() != 'null') {
        return value;
      }
    }
    return '';
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _cleanUrl(String value) {
    var cleaned = value.trim();
    while (cleaned.endsWith('"') || cleaned.endsWith("'")) {
      cleaned = cleaned.substring(0, cleaned.length - 1).trim();
    }
    while (cleaned.toLowerCase().endsWith('%22')) {
      cleaned = cleaned.substring(0, cleaned.length - 3).trim();
    }
    return cleaned;
  }

  static DateTime? _parseDate(String value) {
    if (value.isEmpty) return null;
    final normalized = value.trim();
    for (final format in const [
      'yyyy-MM-dd HH:mm:ss',
      'yyyy-MM-dd',
      'dd-MM-yyyy HH:mm:ss',
      'dd-MM-yyyy',
    ]) {
      try {
        return DateFormat(format).parseStrict(normalized);
      } catch (_) {}
    }
    return DateTime.tryParse(normalized);
  }

  static DateTime? _parseMonthYear(String value) {
    if (value.isEmpty) return null;
    for (final format in const ['MMM yyyy', 'MMMM yyyy', 'MMM-yy', 'MMMM-yy']) {
      try {
        return DateFormat(format).parseStrict(value.trim());
      } catch (_) {}
    }
    return null;
  }
}

class SalarySlipService {
  SalarySlipService({SessionManager? sessionManager})
      : _session = sessionManager ?? SessionManager();

  final SessionManager _session;

  Future<SalarySlipResponse> load() async {
    final organisationId = await _session.getOrgId() ?? 0;
    final employeeDetailsId =
        await _session.getEmployeeDetailsId() ?? await _session.getEmpId() ?? 0;
    if (organisationId <= 0 || employeeDetailsId <= 0) {
      throw const MobileApiException(
        'PAYROLL_CONTEXT_REQUIRED',
        message: 'Employee payroll context is not available. Please login again.',
      );
    }

    final foundation = MobileApiFoundation.instance;
    final requestId = foundation.newRequestId();
    final response = await foundation.postJson(
      ApiDetails.mobileSalarySlips,
      body: <String, Object?>{
        'organisationId': organisationId,
        'employeeDetailsId': employeeDetailsId,
      },
      headers: await foundation.authHeaders(requestId: requestId, json: true),
      tag: 'SALARY_SLIPS',
    );
    final body = foundation.decodeMap(response.body);
    if (!foundation.isSuccess(response)) {
      throw MobileApiException(
        'SALARY_SLIPS_FAILED',
        message: body['message']?.toString() ?? 'Unable to load salary slips.',
        statusCode: response.statusCode,
      );
    }
    return SalarySlipResponse.fromJson(body);
  }
}

class SalarySlipDownloadResult {
  const SalarySlipDownloadResult({required this.fileName, required this.location});

  final String fileName;
  final String location;
}

class SalarySlipDownloadService {
  static const MethodChannel _downloadsChannel =
      MethodChannel('com.erzone.employroll/media_store');

  Future<SalarySlipDownloadResult> save(SalarySlipItem slip) async {
    if (slip.documentUrl.isEmpty) {
      throw const FileSystemException('Salary slip download is not available.');
    }
    final response = await MobileHttpClient.instance.get(Uri.parse(slip.documentUrl));
    if (response.statusCode < 200 || response.statusCode >= 300 || response.bodyBytes.isEmpty) {
      throw FileSystemException('Download failed with status ${response.statusCode}.');
    }

    final fileName = _fileName(slip);
    if (Platform.isAndroid) {
      final android = await DeviceInfoPlugin().androidInfo;
      if (android.version.sdkInt < 29) {
        final storagePermission = await Permission.storage.request();
        if (!storagePermission.isGranted) {
          throw const FileSystemException('Storage permission is required to save salary slip.');
        }
      }
      await _downloadsChannel.invokeMethod<String>('save', <String, Object?>{
        'bytes': Uint8List.fromList(response.bodyBytes),
        'fileName': fileName,
        'mimeType': 'application/pdf',
        'collection': 'DOWNLOADS',
      });
      return SalarySlipDownloadResult(fileName: fileName, location: 'Downloads/EmployRoll');
    }

    final directory = await getApplicationDocumentsDirectory();
    final file = File(path.join(directory.path, fileName));
    await file.writeAsBytes(response.bodyBytes, flush: true);
    return SalarySlipDownloadResult(fileName: fileName, location: file.parent.path);
  }

  String _fileName(SalarySlipItem slip) {
    final timestamp = DateFormat('HH-mm-ss').format(DateTime.now());
    final month = (slip.title.isEmpty ? 'Salary_Slip' : slip.title)
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    final employee = slip.employeeCode
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
        .replaceAll(RegExp(r'\s+'), '_');
    final name = <String>[employee, month, timestamp]
        .where((part) => part.trim().isNotEmpty)
        .join('_');
    return '${name.isEmpty ? 'Salary_Slip_$timestamp' : name}.pdf';
  }
}
