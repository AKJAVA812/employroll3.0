import 'dart:io';
import 'dart:typed_data';

import 'package:er_flutter_project/commanScreen/allAPIList.dart';
import 'package:er_flutter_project/services/mobile_api_foundation.dart';
import 'package:er_flutter_project/services/mobile_http_client.dart';
import 'package:er_flutter_project/sharedPrefancePage/ShardPre.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'modalClass/eDocModels.dart';

class EDocService {
  EDocService({SessionManager? sessionManager})
      : _session = sessionManager ?? SessionManager();

  final SessionManager _session;

  Future<EDocResponse> load() async {
    final employeeDetailsId = await _session.getEmployeeDetailsId() ?? await _session.getEmpId() ?? 0;
    if (employeeDetailsId <= 0) {
      throw const MobileApiException('EMPLOYEE_CONTEXT_REQUIRED', message: 'Employee details are not available. Please login again.');
    }
    final foundation = MobileApiFoundation.instance;
    final requestId = foundation.newRequestId();
    final response = await foundation.postJson(
      ApiDetails.mobileEmployeeDocuments,
      body: <String, Object?>{'employeeDetailsId': employeeDetailsId},
      headers: await foundation.authHeaders(requestId: requestId, json: true),
      tag: 'EMPLOYEE_DOCUMENTS',
    );
    final body = foundation.decodeMap(response.body);
    if (!foundation.isSuccess(response)) {
      throw MobileApiException(
        'EMPLOYEE_DOCUMENTS_FAILED',
        message: body['message']?.toString() ?? 'Unable to load employee documents.',
        statusCode: response.statusCode,
      );
    }
    return EDocResponse.fromJson(body);
  }
}

class EDocDownloadResult {
  const EDocDownloadResult({required this.fileName, required this.location});
  final String fileName;
  final String location;
}

class EDocDownloadService {
  static const MethodChannel _downloadsChannel = MethodChannel('com.erzone.employroll/media_store');

  Future<EDocDownloadResult> save(EDocDocument document) async {
    if (!document.canDownload || document.downloadUrl.isEmpty) {
      throw const FileSystemException('Document download is not available.');
    }
    final response = await MobileHttpClient.instance.get(Uri.parse(document.downloadUrl));
    if (response.statusCode < 200 || response.statusCode >= 300 || response.bodyBytes.isEmpty) {
      throw FileSystemException('Download failed with status ${response.statusCode}.');
    }

    final fileName = _fileName(document);
    if (Platform.isAndroid) {
      final android = await DeviceInfoPlugin().androidInfo;
      if (android.version.sdkInt < 29) {
        final storagePermission = await Permission.storage.request();
        if (!storagePermission.isGranted) {
          throw const FileSystemException('Storage permission is required to save this document.');
        }
      }
      await _downloadsChannel.invokeMethod<String>('save', <String, Object?>{
        'bytes': Uint8List.fromList(response.bodyBytes),
        'fileName': fileName,
        'mimeType': document.mimeType.isEmpty ? 'application/octet-stream' : document.mimeType,
        'collection': document.isImage ? 'PICTURES' : 'DOWNLOADS',
      });
      return EDocDownloadResult(
        fileName: fileName,
        location: document.isImage ? 'Gallery/EmployRoll' : 'Downloads/EmployRoll',
      );
    }

    if (document.isImage) {
      final photoPermission = await Permission.photos.request();
      if (!photoPermission.isGranted && !photoPermission.isLimited) {
        throw const FileSystemException('Photo permission is required to save this image.');
      }
      await ImageGallerySaverPlus.saveImage(Uint8List.fromList(response.bodyBytes), name: path.basenameWithoutExtension(fileName));
      return EDocDownloadResult(fileName: fileName, location: 'Gallery');
    }
    final directory = await getApplicationDocumentsDirectory();
    final file = File(path.join(directory.path, fileName));
    await file.writeAsBytes(response.bodyBytes, flush: true);
    return EDocDownloadResult(fileName: fileName, location: file.parent.path);
  }

  String _fileName(EDocDocument document) {
    final timestamp = DateFormat('HH-mm-ss').format(DateTime.now());
    final safeName = document.documentName
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    final extension = document.fileExtension.isNotEmpty
        ? document.fileExtension
        : path.extension(document.fileName).replaceFirst('.', '');
    return '${safeName.isEmpty ? 'Employee_Document' : safeName}_$timestamp${extension.isEmpty ? '' : '.$extension'}';
  }
}
