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
  String? inTime;
  String? departmentName;
  int? empId;
  String? employeeName;
  String? workingHrs;
  String? branchName;
  var logId;
  String? attendanceDate;
  String? outTime;
  String? applicationDate;
  String? status;

  Data(
      {
        this.inTime,
        this.departmentName,
        this.empId,
        this.employeeName,
        this.workingHrs,
        this.branchName,
        this.logId,
        this.attendanceDate,
        this.outTime,
        this.applicationDate,
        this.status
      });

  Data.fromJson(Map<String, dynamic> json) {
    inTime = json['inTime'];
    departmentName = json['departmentName'];
    empId = json['empId'];
    employeeName = json['employeeName'];
    workingHrs = json['workingHrs'];
    branchName = json['branchName'];
    logId = json['logId'];
    attendanceDate = json['attendanceDate'];
    outTime = json['outTime'];
    applicationDate = json['applicationDate'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inTime'] = this.inTime;
    data['departmentName'] = this.departmentName;
    data['empId'] = this.empId;
    data['employeeName'] = this.employeeName;
    data['workingHrs'] = this.workingHrs;
    data['branchName'] = this.branchName;
    data['logId'] = this.logId;
    data['attendanceDate'] = this.attendanceDate;
    data['outTime'] = this.outTime;
    data['applicationDate'] = this.applicationDate;
    data['status'] = this.status;
    return data;
  }
}