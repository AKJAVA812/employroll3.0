class SelfRequisitionModel {
  List<Data>? data;

  SelfRequisitionModel({this.data});

  SelfRequisitionModel.fromJson(Map<String, dynamic> json) {
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
  String? empId;
  String? employeeName;
  String? inTimeRemark;
  bool? attendanceRequisionType;
  bool? compOffRequistionType;
  String? outTimeRemark;
  String? creationDate;
  int? reqId;
  String? inTime;
  String? reqDate;
  bool? nightRequistionType;
  int? empDetailsId;
  String? outTime;
  bool? shortLeaveRequistionType;
  String? status;

  Data(
      {this.empId,
        this.employeeName,
        this.inTimeRemark,
        this.attendanceRequisionType,
        this.compOffRequistionType,
        this.outTimeRemark,
        this.creationDate,
        this.reqId,
        this.inTime,
        this.reqDate,
        this.nightRequistionType,
        this.empDetailsId,
        this.outTime,
        this.shortLeaveRequistionType,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    employeeName = json['employeeName'];
    inTimeRemark = json['inTimeRemark'];
    attendanceRequisionType = json['attendanceRequisionType'];
    compOffRequistionType = json['compOffRequistionType'];
    outTimeRemark = json['outTimeRemark'];
    creationDate = json['creationDate'];
    reqId = json['reqId'];
    inTime = json['inTime'];
    reqDate = json['reqDate'];
    nightRequistionType = json['nightRequistionType'];
    empDetailsId = json['empDetailsId'];
    outTime = json['outTime'];
    shortLeaveRequistionType = json['shortLeaveRequistionType'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['employeeName'] = this.employeeName;
    data['inTimeRemark'] = this.inTimeRemark;
    data['attendanceRequisionType'] = this.attendanceRequisionType;
    data['compOffRequistionType'] = this.compOffRequistionType;
    data['outTimeRemark'] = this.outTimeRemark;
    data['creationDate'] = this.creationDate;
    data['reqId'] = this.reqId;
    data['inTime'] = this.inTime;
    data['reqDate'] = this.reqDate;
    data['nightRequistionType'] = this.nightRequistionType;
    data['empDetailsId'] = this.empDetailsId;
    data['outTime'] = this.outTime;
    data['shortLeaveRequistionType'] = this.shortLeaveRequistionType;
    data['status'] = this.status;
    return data;
  }
}
