class MonthAttendanceModel {
  List<Data>? data;

  MonthAttendanceModel({this.data});

  MonthAttendanceModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? departmentName;
  String? inTime;
  int? empId;
  String? employeeName;
  String? workingHrs;
  String? empCode;
  String? branchName;
  String? logId;
  String? attendanceDate;
  String? outTime;
  String? applicationDate;
  String? status;

  Data(
      {this.departmentName,
        this.inTime,
        this.empId,
        this.employeeName,
        this.workingHrs,
        this.empCode,
        this.branchName,
        this.logId,
        this.attendanceDate,
        this.outTime,
        this.applicationDate,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    departmentName = json['departmentName'];
    inTime = json['inTime'];
    empId = json['empId'];
    employeeName = json['employeeName'];
    workingHrs = json['workingHrs'];
    empCode = json['empCode'];
    branchName = json['branchName'];
    logId = json['logId'];
    attendanceDate = json['attendanceDate'];
    outTime = json['outTime'];
    applicationDate = json['applicationDate'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['departmentName'] = this.departmentName;
    data['inTime'] = this.inTime;
    data['empId'] = this.empId;
    data['employeeName'] = this.employeeName;
    data['workingHrs'] = this.workingHrs;
    data['empCode'] = this.empCode;
    data['branchName'] = this.branchName;
    data['logId'] = this.logId;
    data['attendanceDate'] = this.attendanceDate;
    data['outTime'] = this.outTime;
    data['applicationDate'] = this.applicationDate;
    data['status'] = this.status;
    return data;
  }
}