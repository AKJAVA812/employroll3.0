class PendingRequisitionModel {
  List<Data>? data;

  PendingRequisitionModel({this.data});

  PendingRequisitionModel.fromJson(Map<String, dynamic> json) {
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
  dynamic empId;
  dynamic attendanceRequisionType;
  dynamic compOffRequistionType;
  dynamic outRemarks;
  dynamic actualInTime;
  dynamic branch;
  dynamic inTime;
  dynamic nightRequistionType;
  dynamic onDate;
  dynamic requestId;
  dynamic empName;
  dynamic inRemarks;
  dynamic actualOutTime;
  dynamic department;
  dynamic outTime;
  dynamic status;
  dynamic shortLeaveRequistionType;

  Data(
      {this.empId,
        this.attendanceRequisionType,
        this.compOffRequistionType,
        this.outRemarks,
        this.actualInTime,
        this.branch,
        this.inTime,
        this.nightRequistionType,
        this.onDate,
        this.requestId,
        this.empName,
        this.inRemarks,
        this.actualOutTime,
        this.department,
        this.outTime,
        this.status,
        this.shortLeaveRequistionType});

  Data.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    attendanceRequisionType = json['attendanceRequisionType'];
    compOffRequistionType = json['compOffRequistionType'];
    outRemarks = json['outRemarks'];
    actualInTime = json['actualInTime'];
    branch = json['branch'];
    inTime = json['inTime'];
    nightRequistionType = json['nightRequistionType'];
    onDate = json['onDate'];
    requestId = json['requestId'];
    empName = json['empName'];
    inRemarks = json['inRemarks'];
    actualOutTime = json['actualOutTime'];
    department = json['department'];
    outTime = json['outTime'];
    status = json['status'];
    shortLeaveRequistionType = json['shortLeaveRequistionType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['attendanceRequisionType'] = this.attendanceRequisionType;
    data['compOffRequistionType'] = this.compOffRequistionType;
    data['outRemarks'] = this.outRemarks;
    data['actualInTime'] = this.actualInTime;
    data['branch'] = this.branch;
    data['inTime'] = this.inTime;
    data['nightRequistionType'] = this.nightRequistionType;
    data['onDate'] = this.onDate;
    data['requestId'] = this.requestId;
    data['empName'] = this.empName;
    data['inRemarks'] = this.inRemarks;
    data['actualOutTime'] = this.actualOutTime;
    data['department'] = this.department;
    data['outTime'] = this.outTime;
    data['status'] = this.status;
    data['shortLeaveRequistionType'] = this.shortLeaveRequistionType;
    return data;
  }
}
