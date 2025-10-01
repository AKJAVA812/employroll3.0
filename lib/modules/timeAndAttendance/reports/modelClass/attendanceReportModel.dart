class AttendanceReportModel {
  List<Data>? data;

  AttendanceReportModel({this.data});

  AttendanceReportModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
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

  Data(
      {this.departmentName,
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
        this.empCode});

  Data.fromJson(Map<String, dynamic> json) {
    departmentName = json['departmentName'];
    empId = json['empId'];
    employeeName = json['employeeName'];
    workingHrs = json['workingHrs'];
    branchName = json['branchName'];
    isShortLeave = json['isShortLeave'];
    isOdReq = json['isOdReq'];
    branch = json['branch'];
    inTime = json['inTime'];
    updatedWorkingHour = json['updatedWorkingHour'];
    relaxationHour = json['relaxationHour'];
    logId = json['logId'];
    attendanceDate = json['attendanceDate'];
    shiftWorkingHour = json['shiftWorkingHour'];
    outTime = json['outTime'];
    applicationDate = json['applicationDate'];
    status = json['status'];
    empCode = json['empCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['departmentName'] = this.departmentName;
    data['empId'] = this.empId;
    data['employeeName'] = this.employeeName;
    data['workingHrs'] = this.workingHrs;
    data['branchName'] = this.branchName;
    data['isShortLeave'] = this.isShortLeave;
    data['isOdReq'] = this.isOdReq;
    data['branch'] = this.branch;
    data['inTime'] = this.inTime;
    data['updatedWorkingHour'] = this.updatedWorkingHour;
    data['relaxationHour'] = this.relaxationHour;
    data['logId'] = this.logId;
    data['attendanceDate'] = this.attendanceDate;
    data['shiftWorkingHour'] = this.shiftWorkingHour;
    data['outTime'] = this.outTime;
    data['applicationDate'] = this.applicationDate;
    data['status'] = this.status;
    data['empCode'] = this.empCode;
    return data;
  }
}
