
class EssDashboarrdModel {
  CountData? countData;

  EssDashboarrdModel({this.countData});

  EssDashboarrdModel.fromJson(Map<String, dynamic> json) {
    final derivedCountData = _countDataFromCalendarSource(json);
    countData =
        json['countData'] != null
            ? CountData.fromJson(json['countData'])
            : derivedCountData;
    if (_shouldUseCalendarCountData(countData, derivedCountData)) {
      countData = derivedCountData;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (countData != null) {
      data['countData'] = countData!.toJson();
    }
    return data;
  }
}

bool _shouldUseCalendarCountData(CountData? parsed, CountData? derived) {
  if (derived == null) return false;
  if (parsed == null) return true;
  return (parsed.totalList?.isEmpty ?? true) &&
      (derived.totalList?.isNotEmpty ?? false);
}

CountData? _countDataFromCalendarSource(Map<String, dynamic> json) {
  final rows = _calendarRows(json);
  if (rows.isEmpty) return null;
  final employee = _asMap(json['employee']);

  final presentRows = _rowsFor(rows, 'present', employee);
  final absentRows = _rowsFor(rows, 'absent', employee);
  final lateRows = _rowsFor(rows, 'late in', employee);
  final mispunchRows = _rowsFor(rows, 'mispunch', employee);
  final earlyGoRows = _rowsFor(rows, 'early go', employee);
  final shortLeaveRows = _rowsFor(rows, 'short leave', employee);
  final halfDayRows = _rowsFor(rows, 'half day', employee);
  final totalRows = rows.map((row) => _legacyAttendanceRow(row, employee)).toList();

  return CountData.fromJson(<String, dynamic>{
    'presentList': presentRows,
    'absentList': absentRows,
    'lateList': lateRows,
    'mispunchList': mispunchRows,
    'earlyGoList': earlyGoRows,
    'shortLeaveList': shortLeaveRows,
    'halfDayList': halfDayRows,
    'totalList': totalRows,
    'data': <Map<String, dynamic>>[],
    'totalAtt': presentRows.length,
    'absentCount': absentRows.length,
    'late': lateRows.length,
    'mispunch': mispunchRows.length,
    'earlygo': earlyGoRows.length,
    'shortlev': shortLeaveRows.length,
    'halfday': halfDayRows.length,
    'totalDays': rows.length,
    'paidDaysCount': presentRows.length,
  });
}

List<Map<String, dynamic>> _calendarRows(Map<String, dynamic> json) {
  final direct = _asMapList(json['calendar']);
  if (direct.isNotEmpty) return direct;
  final data = _asMapList(json['data']);
  if (data.isNotEmpty) return data;
  final calendarBody = json['calendarBody'];
  if (calendarBody is Map) {
    final calendarBodyData = _asMapList(calendarBody['data']);
    if (calendarBodyData.isNotEmpty) return calendarBodyData;
    final calendarBodyCalendar = _asMapList(calendarBody['calendar']);
    if (calendarBodyCalendar.isNotEmpty) return calendarBodyCalendar;
  }
  final r3Calendar = json['r3Calendar'];
  if (r3Calendar is Map) {
    final r3Data = _asMapList(r3Calendar['data']);
    if (r3Data.isNotEmpty) return r3Data;
    final r3CalendarRows = _asMapList(r3Calendar['calendar']);
    if (r3CalendarRows.isNotEmpty) return r3CalendarRows;
  }
  return <Map<String, dynamic>>[];
}

List<Map<String, dynamic>> _asMapList(Object? value) {
  if (value is! List) return <Map<String, dynamic>>[];
  return value
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}

Map<String, dynamic> _asMap(Object? value) {
  return value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};
}

List<Map<String, dynamic>> _rowsFor(
  List<Map<String, dynamic>> rows,
  String status,
  Map<String, dynamic> employee,
) {
  return rows
      .where((row) => _canonicalStatus(row) == status)
      .map((row) => _legacyAttendanceRow(row, employee))
      .toList();
}

Map<String, dynamic> _legacyAttendanceRow(
  Map<String, dynamic> row,
  Map<String, dynamic> employee,
) {
  final status = _text(row['attendanceStatus'] ?? row['status']);
  final displayStatus = _text(row['status'] ?? row['attendanceStatus']);
  final workHours = row['workHours'];
  final workingMinutes = row['workingMinutes'];
  final department = _text(employee['department']);
  final designation = _text(employee['designation']);
  final deptText =
      [department, designation].where((value) => value.trim().isNotEmpty).join(' - ');
  return <String, dynamic>{
    'empId': _text(row['employeeId'] ?? row['employeeDetailsId']),
    'logDate': _text(row['logDate'] ?? row['date'] ?? row['attendanceDate']),
    'inTime': _timeText(row['firstInTime']),
    'outTime': _timeText(row['lastOutTime']),
    'workingHours':
        workHours == null || _text(workHours).isEmpty
            ? _timeText(workingMinutes)
            : _timeText(workHours),
    'status': displayStatus.isEmpty ? status : displayStatus,
    'statusCode': status,
    'lateTime': _text(row['lateMinutes']),
    'earlyTime': '',
    'shortStatus': '',
    'dept': _text(row['dept'] ?? row['department']).isEmpty
        ? deptText
        : _text(row['dept'] ?? row['department']),
    'branch': _text(row['branch']).isEmpty
        ? _text(employee['branch'])
        : _text(row['branch']),
    'empName': _text(row['empName'] ?? row['employeeName']).isEmpty
        ? _text(employee['employeeName'])
        : _text(row['empName'] ?? row['employeeName']),
  };
}

String _canonicalStatus(Map<String, dynamic> row) {
  final status = _text(row['attendanceStatus'] ?? row['status'] ?? row['statusCode'])
      .trim()
      .toLowerCase()
      .replaceAll('-', ' ')
      .replaceAll('_', ' ')
      .replaceAll(RegExp(r'\s+'), ' ');
  switch (status) {
    case 'late':
      return 'late in';
    case 'early':
      return 'early go';
    case 'missing':
      return 'mispunch';
    case 'half':
      return 'half day';
    case 'short':
      return 'short leave';
    default:
      return status;
  }
}

String _text(Object? value) => value == null ? '' : value.toString();

String _timeText(Object? value) {
  final text = _text(value).trim();
  if (text.isEmpty || text.toLowerCase() == 'null') return '--:--';
  return text;
}

String _normaliseAttendanceStatus(String? value) {
  return (value ?? '')
      .trim()
      .toLowerCase()
      .replaceAll('-', ' ')
      .replaceAll('_', ' ')
      .replaceAll(RegExp(r'\s+'), ' ');
}

bool isAttendanceCardStatus(String? status, String? statusCode) {
  final displayStatus = _normaliseAttendanceStatus(status);
  if (displayStatus.contains('present') ||
      displayStatus.contains('week off') ||
      displayStatus.contains('weekly off') ||
      displayStatus.contains('leave') ||
      displayStatus.contains('holiday')) {
    return true;
  }

  // Keeps older dashboard payloads working when only a status code is present.
  final code = _normaliseAttendanceStatus(statusCode);
  return const {'p', 'pp', 'wo', 'w/o', 'l', 'h'}.contains(code);
}

int attendanceCardCount(CountData? countData) {
  if (countData == null) return 0;

  final datedRows = <String>{};
  var undatedRows = 0;

  void addRow(String? employeeId, String? logDate) {
    final date = (logDate ?? '').trim();
    if (date.isEmpty) {
      undatedRows++;
      return;
    }
    datedRows.add('${employeeId ?? ''}|$date');
  }

  for (final row in countData.presentList ?? <PresentList>[]) {
    addRow(row.empId, row.logDate);
  }
  for (final row in countData.totalList ?? <TotalList>[]) {
    if (isAttendanceCardStatus(row.status, row.statusCode)) {
      addRow(row.empId, row.logDate);
    }
  }

  final count = datedRows.length + undatedRows;
  return count == 0 ? (countData.totalAtt ?? 0) : count;
}

class CountData {
  List<PresentList>? presentList;
  List<LateList>? lateList;
  List<Data>? data;
  int? halfday;
  List<EarlyGoList>? earlyGoList;
  List<AbsentList>? absentList;
  List<HalfDayList>? halfDayList;
  int? totalAtt;
  int? absentCount;
  List<ShortLeaveList>? shortLeaveList;
  List<TotalList>? totalList;
  int? late;
  int? shortlev;
  int? totalDays;
  List<MispunchList>? mispunchList;
  int? mispunch;
  int? earlygo;
  int? paidDaysCount;

  CountData(
      {this.presentList,
        this.lateList,
        this.data,
        this.halfday,
        this.earlyGoList,
        this.absentList,
        this.halfDayList,
        this.totalAtt,
        this.absentCount,
        this.shortLeaveList,
        this.totalList,
        this.late,
        this.shortlev,
        this.totalDays,
        this.mispunchList,
        this.mispunch,
        this.earlygo,
        this.paidDaysCount});

  CountData.fromJson(Map<String, dynamic> json) {
    if (json['presentList'] != null) {
      presentList = <PresentList>[];
      json['presentList'].forEach((v) {
        presentList!.add(PresentList.fromJson(v));
      });
    }
    if (json['lateList'] != null) {
      lateList = <LateList>[];
      json['lateList'].forEach((v) {
        lateList!.add(LateList.fromJson(v));
      });
    }
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    halfday = json['halfday'];
    if (json['earlyGoList'] != null) {
      earlyGoList = <EarlyGoList>[];
      json['earlyGoList'].forEach((v) {
        earlyGoList!.add(EarlyGoList.fromJson(v));
      });
    }
    if (json['absentList'] != null) {
      absentList = <AbsentList>[];
      json['absentList'].forEach((v) {
        absentList!.add(AbsentList.fromJson(v));
      });
    }
    if (json['halfDayList'] != null) {
      halfDayList = <HalfDayList>[];
      json['halfDayList'].forEach((v) {
        halfDayList!.add(HalfDayList.fromJson(v));
      });
    }
    totalAtt = json['totalAtt'];
    absentCount = json['absentCount'];
    if (json['shortLeaveList'] != null) {
      shortLeaveList = <ShortLeaveList>[];
      json['shortLeaveList'].forEach((v) {
        shortLeaveList!.add(ShortLeaveList.fromJson(v));
      });
    }
    if (json['totalList'] != null) {
      totalList = <TotalList>[];
      json['totalList'].forEach((v) {
        totalList!.add(TotalList.fromJson(v));
      });
    }
    late = json['late'];
    shortlev = json['shortlev'];
    totalDays = json['totalDays'];
    if (json['mispunchList'] != null) {
      mispunchList = <MispunchList>[];
      json['mispunchList'].forEach((v) {
        mispunchList!.add(MispunchList.fromJson(v));
      });
    }
    mispunch = json['mispunch'];
    earlygo = json['earlygo'];
    paidDaysCount = json['paidDaysCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (presentList != null) {
      data['presentList'] = presentList!.map((v) => v.toJson()).toList();
    }
    if (lateList != null) {
      data['lateList'] = lateList!.map((v) => v.toJson()).toList();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['halfday'] = halfday;
    if (earlyGoList != null) {
      data['earlyGoList'] = earlyGoList!.map((v) => v.toJson()).toList();
    }
    if (absentList != null) {
      data['absentList'] = absentList!.map((v) => v.toJson()).toList();
    }
    if (halfDayList != null) {
      data['halfDayList'] = halfDayList!.map((v) => v.toJson()).toList();
    }
    data['totalAtt'] = totalAtt;
    data['absentCount'] = absentCount;
    if (shortLeaveList != null) {
      data['shortLeaveList'] =
          shortLeaveList!.map((v) => v.toJson()).toList();
    }
    if (totalList != null) {
      data['totalList'] = totalList!.map((v) => v.toJson()).toList();
    }
    data['late'] = late;
    data['shortlev'] = shortlev;
    data['totalDays'] = totalDays;
    if (mispunchList != null) {
      data['mispunchList'] = mispunchList!.map((v) => v.toJson()).toList();
    }
    data['mispunch'] = mispunch;
    data['earlygo'] = earlygo;
    data['paidDaysCount'] = paidDaysCount;
    return data;
  }
}

class Data {
  String? empId;
  String? empName;
  String? dept;
  String? branch;

  Data({this.empId, this.empName, this.dept, this.branch});

  Data.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    empName = json['empName'];
    dept = json['dept'];
    branch = json['branch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empId'] = empId;
    data['empName'] = empName;
    data['dept'] = dept;
    data['branch'] = branch;
    return data;
  }
}

class AbsentList {
  String? empId;
  String? outPunchType;
  String? logDate;
  String? lateTime;
  String? earlyTime;
  String? inPunchType;
  String? shortStatus;
  String? dept;
  String? type;
  String? branch;
  String? inTime;
  String? empName;
  String? workingHours;
  String? outTime;
  String? status;
  String? statusCode;

  AbsentList(
      {this.empId,
        this.outPunchType,
        this.logDate,
        this.lateTime,
        this.earlyTime,
        this.inPunchType,
        this.shortStatus,
        this.dept,
        this.type,
        this.branch,
        this.inTime,
        this.empName,
        this.workingHours,
        this.outTime,
        this.status,
        this.statusCode});

  AbsentList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    outPunchType = json['outPunchType'];
    logDate = json['logDate'];
    lateTime = json['lateTime'];
    earlyTime = json['earlyTime'];
    inPunchType = json['inPunchType'];
    shortStatus = json['shortStatus'];
    dept = json['dept'];
    type = json['type'];
    branch = json['branch'];
    inTime = json['inTime'];
    empName = json['empName'];
    workingHours = json['workingHours'];
    outTime = json['outTime'];
    status = json['status'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empId'] = empId;
    data['outPunchType'] = outPunchType;
    data['logDate'] = logDate;
    data['lateTime'] = lateTime;
    data['earlyTime'] = earlyTime;
    data['inPunchType'] = inPunchType;
    data['shortStatus'] = shortStatus;
    data['dept'] = dept;
    data['type'] = type;
    data['branch'] = branch;
    data['inTime'] = inTime;
    data['empName'] = empName;
    data['workingHours'] = workingHours;
    data['outTime'] = outTime;
    data['status'] = status;
    data['statusCode'] = statusCode;
    return data;
  }
}

class PresentList {
  String? empId;
  String? outPunchType;
  String? logDate;
  String? lateTime;
  String? earlyTime;
  String? inPunchType;
  String? shortStatus;
  String? dept;
  String? type;
  String? branch;
  String? inTime;
  String? empName;
  String? workingHours;
  String? outTime;
  String? status;
  String? statusCode;

  PresentList(
      {this.empId,
        this.outPunchType,
        this.logDate,
        this.lateTime,
        this.earlyTime,
        this.inPunchType,
        this.shortStatus,
        this.dept,
        this.type,
        this.branch,
        this.inTime,
        this.empName,
        this.workingHours,
        this.outTime,
        this.status,
        this.statusCode});

  PresentList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    outPunchType = json['outPunchType'];
    logDate = json['logDate'];
    lateTime = json['lateTime'];
    earlyTime = json['earlyTime'];
    inPunchType = json['inPunchType'];
    shortStatus = json['shortStatus'];
    dept = json['dept'];
    type = json['type'];
    branch = json['branch'];
    inTime = json['inTime'];
    empName = json['empName'];
    workingHours = json['workingHours'];
    outTime = json['outTime'];
    status = json['status'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empId'] = empId;
    data['outPunchType'] = outPunchType;
    data['logDate'] = logDate;
    data['lateTime'] = lateTime;
    data['earlyTime'] = earlyTime;
    data['inPunchType'] = inPunchType;
    data['shortStatus'] = shortStatus;
    data['dept'] = dept;
    data['type'] = type;
    data['branch'] = branch;
    data['inTime'] = inTime;
    data['empName'] = empName;
    data['workingHours'] = workingHours;
    data['outTime'] = outTime;
    data['status'] = status;
    data['statusCode'] = statusCode;
    return data;
  }
}

class LateList {
  String? empId;
  String? outPunchType;
  String? logDate;
  String? lateTime;
  String? earlyTime;
  String? inPunchType;
  String? shortStatus;
  String? dept;
  String? type;
  String? branch;
  String? inTime;
  String? empName;
  String? workingHours;
  String? outTime;
  String? status;
  String? statusCode;

  LateList(
      {this.empId,
        this.outPunchType,
        this.logDate,
        this.lateTime,
        this.earlyTime,
        this.inPunchType,
        this.shortStatus,
        this.dept,
        this.type,
        this.branch,
        this.inTime,
        this.empName,
        this.workingHours,
        this.outTime,
        this.status,
        this.statusCode});

  LateList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    outPunchType = json['outPunchType'];
    logDate = json['logDate'];
    lateTime = json['lateTime'];
    earlyTime = json['earlyTime'];
    inPunchType = json['inPunchType'];
    shortStatus = json['shortStatus'];
    dept = json['dept'];
    type = json['type'];
    branch = json['branch'];
    inTime = json['inTime'];
    empName = json['empName'];
    workingHours = json['workingHours'];
    outTime = json['outTime'];
    status = json['status'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empId'] = empId;
    data['outPunchType'] = outPunchType;
    data['logDate'] = logDate;
    data['lateTime'] = lateTime;
    data['earlyTime'] = earlyTime;
    data['inPunchType'] = inPunchType;
    data['shortStatus'] = shortStatus;
    data['dept'] = dept;
    data['type'] = type;
    data['branch'] = branch;
    data['inTime'] = inTime;
    data['empName'] = empName;
    data['workingHours'] = workingHours;
    data['outTime'] = outTime;
    data['status'] = status;
    data['statusCode'] = statusCode;
    return data;
  }
}

class MispunchList {
  String? empId;
  String? outPunchType;
  String? logDate;
  String? lateTime;
  String? earlyTime;
  String? inPunchType;
  String? shortStatus;
  String? dept;
  String? type;
  String? branch;
  String? inTime;
  String? empName;
  String? workingHours;
  String? outTime;
  String? status;
  String? statusCode;

  MispunchList(
      {this.empId,
        this.outPunchType,
        this.logDate,
        this.lateTime,
        this.earlyTime,
        this.inPunchType,
        this.shortStatus,
        this.dept,
        this.type,
        this.branch,
        this.inTime,
        this.empName,
        this.workingHours,
        this.outTime,
        this.status,
        this.statusCode});

  MispunchList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    outPunchType = json['outPunchType'];
    logDate = json['logDate'];
    lateTime = json['lateTime'];
    earlyTime = json['earlyTime'];
    inPunchType = json['inPunchType'];
    shortStatus = json['shortStatus'];
    dept = json['dept'];
    type = json['type'];
    branch = json['branch'];
    inTime = json['inTime'];
    empName = json['empName'];
    workingHours = json['workingHours'];
    outTime = json['outTime'];
    status = json['status'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empId'] = empId;
    data['outPunchType'] = outPunchType;
    data['logDate'] = logDate;
    data['lateTime'] = lateTime;
    data['earlyTime'] = earlyTime;
    data['inPunchType'] = inPunchType;
    data['shortStatus'] = shortStatus;
    data['dept'] = dept;
    data['type'] = type;
    data['branch'] = branch;
    data['inTime'] = inTime;
    data['empName'] = empName;
    data['workingHours'] = workingHours;
    data['outTime'] = outTime;
    data['status'] = status;
    data['statusCode'] = statusCode;
    return data;
  }
}

class EarlyGoList {
  String? empId;
  String? outPunchType;
  String? logDate;
  String? lateTime;
  String? earlyTime;
  String? inPunchType;
  String? shortStatus;
  String? dept;
  String? type;
  String? branch;
  String? inTime;
  String? empName;
  String? workingHours;
  String? outTime;
  String? status;
  String? statusCode;

  EarlyGoList(
      {this.empId,
        this.outPunchType,
        this.logDate,
        this.lateTime,
        this.earlyTime,
        this.inPunchType,
        this.shortStatus,
        this.dept,
        this.type,
        this.branch,
        this.inTime,
        this.empName,
        this.workingHours,
        this.outTime,
        this.status,
        this.statusCode});

  EarlyGoList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    outPunchType = json['outPunchType'];
    logDate = json['logDate'];
    lateTime = json['lateTime'];
    earlyTime = json['earlyTime'];
    inPunchType = json['inPunchType'];
    shortStatus = json['shortStatus'];
    dept = json['dept'];
    type = json['type'];
    branch = json['branch'];
    inTime = json['inTime'];
    empName = json['empName'];
    workingHours = json['workingHours'];
    outTime = json['outTime'];
    status = json['status'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empId'] = empId;
    data['outPunchType'] = outPunchType;
    data['logDate'] = logDate;
    data['lateTime'] = lateTime;
    data['earlyTime'] = earlyTime;
    data['inPunchType'] = inPunchType;
    data['shortStatus'] = shortStatus;
    data['dept'] = dept;
    data['type'] = type;
    data['branch'] = branch;
    data['inTime'] = inTime;
    data['empName'] = empName;
    data['workingHours'] = workingHours;
    data['outTime'] = outTime;
    data['status'] = status;
    data['statusCode'] = statusCode;
    return data;
  }
}

class HalfDayList {
  String? empId;
  String? outPunchType;
  String? logDate;
  String? lateTime;
  String? earlyTime;
  String? inPunchType;
  String? shortStatus;
  String? dept;
  String? type;
  String? branch;
  String? inTime;
  String? empName;
  String? workingHours;
  String? outTime;
  String? status;
  String? statusCode;

  HalfDayList(
      {this.empId,
        this.outPunchType,
        this.logDate,
        this.lateTime,
        this.earlyTime,
        this.inPunchType,
        this.shortStatus,
        this.dept,
        this.type,
        this.branch,
        this.inTime,
        this.empName,
        this.workingHours,
        this.outTime,
        this.status,
        this.statusCode});

  HalfDayList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    outPunchType = json['outPunchType'];
    logDate = json['logDate'];
    lateTime = json['lateTime'];
    earlyTime = json['earlyTime'];
    inPunchType = json['inPunchType'];
    shortStatus = json['shortStatus'];
    dept = json['dept'];
    type = json['type'];
    branch = json['branch'];
    inTime = json['inTime'];
    empName = json['empName'];
    workingHours = json['workingHours'];
    outTime = json['outTime'];
    status = json['status'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empId'] = empId;
    data['outPunchType'] = outPunchType;
    data['logDate'] = logDate;
    data['lateTime'] = lateTime;
    data['earlyTime'] = earlyTime;
    data['inPunchType'] = inPunchType;
    data['shortStatus'] = shortStatus;
    data['dept'] = dept;
    data['type'] = type;
    data['branch'] = branch;
    data['inTime'] = inTime;
    data['empName'] = empName;
    data['workingHours'] = workingHours;
    data['outTime'] = outTime;
    data['status'] = status;
    data['statusCode'] = statusCode;
    return data;
  }
}

class ShortLeaveList {
  String? empId;
  String? outPunchType;
  String? logDate;
  String? lateTime;
  String? earlyTime;
  String? inPunchType;
  String? shortStatus;
  String? dept;
  String? type;
  String? branch;
  String? inTime;
  String? empName;
  String? workingHours;
  String? outTime;
  String? status;
  String? statusCode;

  ShortLeaveList(
      {this.empId,
        this.outPunchType,
        this.logDate,
        this.lateTime,
        this.earlyTime,
        this.inPunchType,
        this.shortStatus,
        this.dept,
        this.type,
        this.branch,
        this.inTime,
        this.empName,
        this.workingHours,
        this.outTime,
        this.status,
        this.statusCode});

  ShortLeaveList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    outPunchType = json['outPunchType'];
    logDate = json['logDate'];
    lateTime = json['lateTime'];
    earlyTime = json['earlyTime'];
    inPunchType = json['inPunchType'];
    shortStatus = json['shortStatus'];
    dept = json['dept'];
    type = json['type'];
    branch = json['branch'];
    inTime = json['inTime'];
    empName = json['empName'];
    workingHours = json['workingHours'];
    outTime = json['outTime'];
    status = json['status'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empId'] = empId;
    data['outPunchType'] = outPunchType;
    data['logDate'] = logDate;
    data['lateTime'] = lateTime;
    data['earlyTime'] = earlyTime;
    data['inPunchType'] = inPunchType;
    data['shortStatus'] = shortStatus;
    data['dept'] = dept;
    data['type'] = type;
    data['branch'] = branch;
    data['inTime'] = inTime;
    data['empName'] = empName;
    data['workingHours'] = workingHours;
    data['outTime'] = outTime;
    data['status'] = status;
    data['statusCode'] = statusCode;
    return data;
  }
}

class TotalList {
  String? empId;
  String? outPunchType;
  String? logDate;
  String? lateTime;
  String? earlyTime;
  String? inPunchType;
  String? shortStatus;
  String? dept;
  String? type;
  String? branch;
  String? inTime;
  String? empName;
  dynamic workingHours;
  String? outTime;
  String? status;
  String? statusCode;

  TotalList(
      {this.empId,
        this.outPunchType,
        this.logDate,
        this.lateTime,
        this.earlyTime,
        this.inPunchType,
        this.shortStatus,
        this.dept,
        this.type,
        this.branch,
        this.inTime,
        this.empName,
        this.workingHours,
        this.outTime,
        this.status,
        this.statusCode});

  TotalList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    outPunchType = json['outPunchType'];
    logDate = json['logDate'];
    lateTime = json['lateTime'];
    earlyTime = json['earlyTime'];
    inPunchType = json['inPunchType'];
    shortStatus = json['shortStatus'];
    dept = json['dept'];
    type = json['type'];
    branch = json['branch'];
    inTime = json['inTime'];
    empName = json['empName'];
    workingHours = json['workingHours'];
    outTime = json['outTime'];
    status = json['status'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empId'] = empId;
    data['outPunchType'] = outPunchType;
    data['logDate'] = logDate;
    data['lateTime'] = lateTime;
    data['earlyTime'] = earlyTime;
    data['inPunchType'] = inPunchType;
    data['shortStatus'] = shortStatus;
    data['dept'] = dept;
    data['type'] = type;
    data['branch'] = branch;
    data['inTime'] = inTime;
    data['empName'] = empName;
    data['workingHours'] = workingHours;
    data['outTime'] = outTime;
    data['status'] = status;
    data['statusCode'] = statusCode;
    return data;
  }
}
