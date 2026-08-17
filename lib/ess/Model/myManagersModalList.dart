String? _text(Object? value) => value?.toString();

int? _integer(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}

List<Map<String, dynamic>> _rows(Object? value) {
  if (value is! List) return const <Map<String, dynamic>>[];
  return value
      .whereType<Map>()
      .map(
        (row) => row.map<String, dynamic>(
          (key, itemValue) => MapEntry(key.toString(), itemValue),
        ),
      )
      .toList();
}

String _relationshipType(Map<String, dynamic> row) {
  final value = (row['relationshipType'] ??
          row['reportieeType'] ??
          row['reportieType'] ??
          row['reportingType'] ??
          '')
      .toString()
      .trim()
      .toUpperCase()
      .replaceAll(RegExp(r'[\s-]+'), '_');
  if (value == 'SHARED' || value == 'SHARED_SERVICE') {
    return 'SHARED_SERVICES';
  }
  return value;
}

List<Map<String, dynamic>> _rowsForType(
  List<Map<String, dynamic>> allRows,
  List<Map<String, dynamic>> responseRows,
  String type,
) {
  final matches = allRows
      .where((row) => _relationshipType(row) == type)
      .toList();
  return matches.isNotEmpty ? matches : responseRows;
}

class MyManagersModalList {
  List<DottedEmpList>? dottedEmpList;
  List<SharedEmpList>? sharedEmpList;
  List<ListData>? listData;
  List<DirectEmpList>? directEmpList;
  List<DesignatedEmpList>? designatedEmpList;

  MyManagersModalList(
      {this.dottedEmpList,
        this.sharedEmpList,
        this.listData,
        this.directEmpList,
        this.designatedEmpList});

  MyManagersModalList.fromJson(Map<String, dynamic> json) {
    final allRows = _rows(json['listData'] ?? json['data']);
    final dottedRows = _rows(json['dottedEmpList']);
    final sharedRows = _rows(json['sharedEmpList']);
    final directRows = _rows(json['directEmpList']);
    final designatedRows = _rows(json['designatedEmpList']);

    listData = allRows.map((row) => ListData.fromJson(row)).toList();
    dottedEmpList = _rowsForType(allRows, dottedRows, 'DOTTED')
        .map((row) => DottedEmpList.fromJson(row))
        .toList();
    sharedEmpList = _rowsForType(allRows, sharedRows, 'SHARED_SERVICES')
        .map((row) => SharedEmpList.fromJson(row))
        .toList();
    directEmpList = _rowsForType(allRows, directRows, 'DIRECT')
        .map((row) => DirectEmpList.fromJson(row))
        .toList();
    designatedEmpList = _rowsForType(
      allRows,
      designatedRows,
      'DESIGNATED',
    )
        .map((row) => DesignatedEmpList.fromJson(row))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (dottedEmpList != null) {
      data['dottedEmpList'] =
          dottedEmpList!.map((v) => v.toJson()).toList();
    }
    if (sharedEmpList != null) {
      data['sharedEmpList'] =
          sharedEmpList!.map((v) => v.toJson()).toList();
    }
    if (listData != null) {
      data['listData'] = listData!.map((v) => v.toJson()).toList();
    }
    if (directEmpList != null) {
      data['directEmpList'] =
          directEmpList!.map((v) => v.toJson()).toList();
    }
    if (designatedEmpList != null) {
      data['designatedEmpList'] =
          designatedEmpList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SharedEmpList {
  String? profileName;
  int? reportingOfficerId;
  String? reportingOfficerName;
  String? reportieeStatus;
  String? reportieeType;
  String? emailId;
  int? empDetId;

  SharedEmpList(
      {this.profileName,
        this.reportingOfficerId,
        this.reportingOfficerName,
        this.reportieeStatus,
        this.reportieeType,
        this.emailId,
        this.empDetId});

  SharedEmpList.fromJson(Map<String, dynamic> json) {
    profileName = _text(json['profileName']);
    reportingOfficerId = _integer(json['reportingOfficerId']);
    reportingOfficerName = _text(json['reportingOfficerName']);
    reportieeStatus = _text(json['reportieeStatus']);
    reportieeType = _text(
      json['reportieeType'] ?? json['relationshipType'] ?? json['reportieType'],
    );
    emailId = _text(json['emailId']);
    empDetId = _integer(json['empDetId']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profileName'] = profileName;
    data['reportingOfficerId'] = reportingOfficerId;
    data['reportingOfficerName'] = reportingOfficerName;
    data['reportieeStatus'] = reportieeStatus;
    data['reportieeType'] = reportieeType;
    data['emailId'] = emailId;
    data['empDetId'] = empDetId;
    return data;
  }
}

class DottedEmpList {
  String? profileName;
  int? reportingOfficerId;
  String? reportingOfficerName;
  String? reportieeStatus;
  String? reportieeType;
  String? emailId;
  int? empDetId;

  DottedEmpList(
      {this.profileName,
        this.reportingOfficerId,
        this.reportingOfficerName,
        this.reportieeStatus,
        this.reportieeType,
        this.emailId,
        this.empDetId});

  DottedEmpList.fromJson(Map<String, dynamic> json) {
    profileName = _text(json['profileName']);
    reportingOfficerId = _integer(json['reportingOfficerId']);
    reportingOfficerName = _text(json['reportingOfficerName']);
    reportieeStatus = _text(json['reportieeStatus']);
    reportieeType = _text(
      json['reportieeType'] ?? json['relationshipType'] ?? json['reportieType'],
    );
    emailId = _text(json['emailId']);
    empDetId = _integer(json['empDetId']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profileName'] = profileName;
    data['reportingOfficerId'] = reportingOfficerId;
    data['reportingOfficerName'] = reportingOfficerName;
    data['reportieeStatus'] = reportieeStatus;
    data['reportieeType'] = reportieeType;
    data['emailId'] = emailId;
    data['empDetId'] = empDetId;
    return data;
  }
}

class ListData {
  String? profileName;
  int? reportingOfficerId;
  String? reportingOfficerName;
  String? reportieeStatus;
  String? reportieeType;
  String? emailId;
  int? empDetId;

  ListData(
      {this.profileName,
        this.reportingOfficerId,
        this.reportingOfficerName,
        this.reportieeStatus,
        this.reportieeType,
        this.emailId,
        this.empDetId});

  ListData.fromJson(Map<String, dynamic> json) {
    profileName = _text(json['profileName']);
    reportingOfficerId = _integer(json['reportingOfficerId']);
    reportingOfficerName = _text(json['reportingOfficerName']);
    reportieeStatus = _text(json['reportieeStatus']);
    reportieeType = _text(
      json['reportieeType'] ?? json['relationshipType'] ?? json['reportieType'],
    );
    emailId = _text(json['emailId']);
    empDetId = _integer(json['empDetId']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profileName'] = profileName;
    data['reportingOfficerId'] = reportingOfficerId;
    data['reportingOfficerName'] = reportingOfficerName;
    data['reportieeStatus'] = reportieeStatus;
    data['reportieeType'] = reportieeType;
    data['emailId'] = emailId;
    data['empDetId'] = empDetId;
    return data;
  }
}

class DirectEmpList {
  String? profileName;
  int? reportingOfficerId;
  String? reportingOfficerName;
  String? reportieeStatus;
  String? reportieeType;
  String? emailId;
  int? empDetId;

  DirectEmpList(
      {this.profileName,
        this.reportingOfficerId,
        this.reportingOfficerName,
        this.reportieeStatus,
        this.reportieeType,
        this.emailId,
        this.empDetId});

  DirectEmpList.fromJson(Map<String, dynamic> json) {
    profileName = _text(json['profileName']);
    reportingOfficerId = _integer(json['reportingOfficerId']);
    reportingOfficerName = _text(json['reportingOfficerName']);
    reportieeStatus = _text(json['reportieeStatus']);
    reportieeType = _text(
      json['reportieeType'] ?? json['relationshipType'] ?? json['reportieType'],
    );
    emailId = _text(json['emailId']);
    empDetId = _integer(json['empDetId']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profileName'] = profileName;
    data['reportingOfficerId'] = reportingOfficerId;
    data['reportingOfficerName'] = reportingOfficerName;
    data['reportieeStatus'] = reportieeStatus;
    data['reportieeType'] = reportieeType;
    data['emailId'] = emailId;
    data['empDetId'] = empDetId;
    return data;
  }
}

class DesignatedEmpList {
  String? profileName;
  int? reportingOfficerId;
  String? reportingOfficerName;
  String? reportieeStatus;
  String? reportieeType;
  String? emailId;
  int? empDetId;

  DesignatedEmpList(
      {this.profileName,
        this.reportingOfficerId,
        this.reportingOfficerName,
        this.reportieeStatus,
        this.reportieeType,
        this.emailId,
        this.empDetId});

  DesignatedEmpList.fromJson(Map<String, dynamic> json) {
    profileName = _text(json['profileName']);
    reportingOfficerId = _integer(json['reportingOfficerId']);
    reportingOfficerName = _text(json['reportingOfficerName']);
    reportieeStatus = _text(json['reportieeStatus']);
    reportieeType = _text(
      json['reportieeType'] ?? json['relationshipType'] ?? json['reportieType'],
    );
    emailId = _text(json['emailId']);
    empDetId = _integer(json['empDetId']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profileName'] = profileName;
    data['reportingOfficerId'] = reportingOfficerId;
    data['reportingOfficerName'] = reportingOfficerName;
    data['reportieeStatus'] = reportieeStatus;
    data['reportieeType'] = reportieeType;
    data['emailId'] = emailId;
    data['empDetId'] = empDetId;
    return data;
  }
}
