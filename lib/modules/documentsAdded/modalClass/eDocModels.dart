class EDocResponse {
  const EDocResponse({
    required this.employeeDetailsId,
    required this.documentTypes,
    required this.documents,
  });

  factory EDocResponse.fromJson(Map<String, dynamic> json) {
    final types = json['documentTypes'];
    final data = json['data'];
    return EDocResponse(
      employeeDetailsId: _asInt(json['employeeDetailsId']),
      documentTypes: types is List
          ? types.whereType<Map>().map((item) => EDocType.fromJson(Map<String, dynamic>.from(item))).toList()
          : <EDocType>[],
      documents: data is List
          ? data.whereType<Map>().map((item) => EDocDocument.fromJson(Map<String, dynamic>.from(item))).toList()
          : <EDocDocument>[],
    );
  }

  final int employeeDetailsId;
  final List<EDocType> documentTypes;
  final List<EDocDocument> documents;
}

class EDocType {
  const EDocType({required this.id, required this.code, required this.name, required this.count});

  factory EDocType.fromJson(Map<String, dynamic> json) => EDocType(
        id: _asInt(json['docTypeId']),
        code: _text(json['docTypeCode']),
        name: _text(json['label']).isNotEmpty ? _text(json['label']) : _text(json['documentType']),
        count: _asInt(json['documentCount']),
      );

  final int id;
  final String code;
  final String name;
  final int count;
}

class EDocDocument {
  const EDocDocument({
    required this.id,
    required this.docTypeId,
    required this.documentType,
    required this.documentName,
    required this.fileName,
    required this.fileExtension,
    required this.mimeType,
    required this.viewMode,
    required this.viewUrl,
    required this.downloadUrl,
    required this.canView,
    required this.canDownload,
    required this.letterPeriod,
    required this.status,
    required this.creationDate,
  });

  factory EDocDocument.fromJson(Map<String, dynamic> json) => EDocDocument(
        id: _asInt(json['id']),
        docTypeId: _asInt(json['docTypeId']),
        documentType: _text(json['documentType']),
        documentName: _text(json['documentName']).isNotEmpty
            ? _text(json['documentName'])
            : _text(json['documentType']),
        fileName: _text(json['fileName']),
        fileExtension: _text(json['fileExtension']).toLowerCase(),
        mimeType: _text(json['mimeType']),
        viewMode: _text(json['viewMode']).toUpperCase(),
        viewUrl: _text(json['viewUrl']).isNotEmpty ? _text(json['viewUrl']) : _text(json['letter']),
        downloadUrl: _text(json['downloadUrl']).isNotEmpty ? _text(json['downloadUrl']) : _text(json['letter']),
        canView: json['canView'] == true,
        canDownload: json['canDownload'] == true,
        letterPeriod: _text(json['letterPeriod']),
        status: _text(json['status']),
        creationDate: _text(json['creationDate']),
      );

  final int id;
  final int docTypeId;
  final String documentType;
  final String documentName;
  final String fileName;
  final String fileExtension;
  final String mimeType;
  final String viewMode;
  final String viewUrl;
  final String downloadUrl;
  final bool canView;
  final bool canDownload;
  final String letterPeriod;
  final String status;
  final String creationDate;

  bool get isPdf => viewMode == 'PDF' || mimeType == 'application/pdf' || fileExtension == 'pdf';
  bool get isImage => viewMode == 'IMAGE' || mimeType.startsWith('image/');
}

String _text(Object? value) => value?.toString().trim() ?? '';

int _asInt(Object? value) {
  if (value is num) return value.toInt();
  return int.tryParse(_text(value).replaceAll('.0', '')) ?? 0;
}
