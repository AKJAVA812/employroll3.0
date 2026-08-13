class AttendanceReportModel {
  List<Data>? data;

  AttendanceReportModel({this.data});

  AttendanceReportModel.fromJson(Map<String, dynamic> json) {
    final rawRows = json['content'] ?? json['data'];
    data = <Data>[];
    if (rawRows is List) {
      for (final row in rawRows) {
        if (row is Map) {
          data!.add(Data.fromJson(Map<String, dynamic>.from(row)));
        }
      }
    }
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'data': data?.map((item) => item.toJson()).toList(),
  };
}

class Data {
  String? departmentName;
  dynamic empId;
  String? employeeName;
  String? workingHrs;
  String? branchName;
  dynamic isShortLeave;
  dynamic isOdReq;
  String? branch;
  String? inTime;
  String? updatedWorkingHour;
  String? relaxationHour;
  dynamic logId;
  String? attendanceDate;
  String? shiftWorkingHour;
  String? outTime;
  String? applicationDate;
  String? status;
  String? empCode;

  Data({
    this.departmentName,
    this.empId,
    this.employeeName,
    this.workingHrs,
    this.branchName,
    this.isShortLeave,
    this.isOdReq,
    this.branch,
    this.inTime,
    this.updatedWorkingHour,
    this.relaxationHour,
    this.logId,
    this.attendanceDate,
    this.shiftWorkingHour,
    this.outTime,
    this.applicationDate,
    this.status,
    this.empCode,
  });

  Data.fromJson(Map<String, dynamic> json) {
    final statusValue = _text(json['statusName'], _text(json['status']));
    final workedMinutes = _integer(json['workedMinutes']);
    departmentName = _text(json['department'], _text(json['departmentName']));
    empId = json['employeeDetailsId'] ?? json['empId'] ?? 0;
    employeeName = _text(json['employeeName']);
    workingHrs = _text(
      json['workingHrs'],
      workedMinutes == null ? '' : _duration(workedMinutes),
    );
    branchName = _text(json['branch'], _text(json['branchName']));
    isShortLeave = json['isShortLeave'] ??
        statusValue.toLowerCase().contains('short leave');
    isOdReq = json['isOdReq'] ??
        statusValue.toLowerCase().contains('out duty');
    branch = _text(json['branch'], branchName ?? '');
    inTime = _text(json['punchIn'], _text(json['inTime']));
    updatedWorkingHour = _text(json['updatedWorkingHour'], workingHrs ?? '');
    relaxationHour = _text(json['relaxationHour']);
    logId = json['processedAttendanceId'] ?? json['logId'] ?? 0;
    attendanceDate = _text(json['attendanceDate']);
    shiftWorkingHour = _text(
      json['shiftWorkingHour'],
      _scheduledDuration(json['scheduledIn'], json['scheduledOut']),
    );
    outTime = _text(json['punchOut'], _text(json['outTime']));
    applicationDate = _text(json['processedOn'], _text(json['applicationDate']));
    status = _title(statusValue.isEmpty ? 'Unknown' : statusValue);
    empCode = _text(json['employeeCode'], _text(json['empCode']));
  }

  static String _text(Object? value, [String fallback = '']) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty || text.toLowerCase() == 'null' ? fallback : text;
  }

  static int? _integer(Object? value) {
    if (value is num) return value.toInt();
    return int.tryParse(_text(value));
  }

  static String _duration(int minutes) {
    final safeMinutes = minutes < 0 ? 0 : minutes;
    return '${safeMinutes ~/ 60}h ${(safeMinutes % 60).toString().padLeft(2, '0')}m';
  }

  static String _scheduledDuration(Object? start, Object? end) {
    final startMinutes = _timeMinutes(_text(start));
    final endMinutes = _timeMinutes(_text(end));
    if (startMinutes == null || endMinutes == null) return '';
    var difference = endMinutes - startMinutes;
    if (difference < 0) difference += 24 * 60;
    return _duration(difference);
  }

  static int? _timeMinutes(String value) {
    final match = RegExp(r'^(\d{1,2}):(\d{2})').firstMatch(value);
    if (match == null) return null;
    final hour = int.tryParse(match.group(1)!);
    final minute = int.tryParse(match.group(2)!);
    if (hour == null || minute == null) return null;
    return hour * 60 + minute;
  }

  static String _title(String value) {
    return value
        .replaceAll('_', ' ')
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'departmentName': departmentName,
    'empId': empId,
    'employeeName': employeeName,
    'workingHrs': workingHrs,
    'branchName': branchName,
    'isShortLeave': isShortLeave,
    'isOdReq': isOdReq,
    'branch': branch,
    'inTime': inTime,
    'updatedWorkingHour': updatedWorkingHour,
    'relaxationHour': relaxationHour,
    'logId': logId,
    'attendanceDate': attendanceDate,
    'shiftWorkingHour': shiftWorkingHour,
    'outTime': outTime,
    'applicationDate': applicationDate,
    'status': status,
    'empCode': empCode,
  };
}
