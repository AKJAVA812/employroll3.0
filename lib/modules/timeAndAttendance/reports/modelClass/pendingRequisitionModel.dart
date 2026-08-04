class PendingRequisitionModel {
  List<Data>? data;

  PendingRequisitionModel({this.data});

  PendingRequisitionModel.fromJson(Map<String, dynamic> json) {
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
  dynamic empId;
  dynamic attendanceRequisionType;
  dynamic compOffRequistionType;
  dynamic outRemarks;
  dynamic actualInTime;
  dynamic isShortLeave;
  dynamic branch;
  dynamic inTime;
  dynamic updatedWorkingHour;
  dynamic relaxationHour;
  dynamic nightRequistionType;
  dynamic onDate;
  dynamic requestId;
  dynamic empName;
  dynamic inRemarks;
  dynamic actualOutTime;
  dynamic department;
  dynamic shiftWorkingHour;
  dynamic outTime;
  dynamic status;
  dynamic shortLeaveRequistionType;
  dynamic odRequistionType;

  Data(
      {this.empId,
        this.attendanceRequisionType,
        this.compOffRequistionType,
        this.outRemarks,
        this.actualInTime,
        this.isShortLeave,
        this.branch,
        this.inTime,
        this.updatedWorkingHour,
        this.relaxationHour,
        this.nightRequistionType,
        this.onDate,
        this.requestId,
        this.empName,
        this.inRemarks,
        this.actualOutTime,
        this.department,
        this.shiftWorkingHour,
        this.outTime,
        this.status,
        this.shortLeaveRequistionType,
        this.odRequistionType,
      });

  Data.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    attendanceRequisionType = json['attendanceRequisionType'];
    compOffRequistionType = json['compOffRequistionType'];
    outRemarks = json['outRemarks'];
    actualInTime = json['actualInTime'];
    isShortLeave = json['isShortLeave'];
    branch = json['branch'];
    inTime = json['inTime'];
    updatedWorkingHour = json['updatedWorkingHour'];
    relaxationHour = json['relaxationHour'];
    nightRequistionType = json['nightRequistionType'];
    onDate = json['onDate'];
    requestId = json['requestId'];
    empName = json['empName'];
    inRemarks = json['inRemarks'];
    actualOutTime = json['actualOutTime'];
    department = json['department'];
    shiftWorkingHour = json['shiftWorkingHour'];
    outTime = json['outTime'];
    status = json['status'];
    shortLeaveRequistionType = json['shortLeaveRequistionType'];
    odRequistionType = json['odRequistionType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['empId'] = this.empId;
    data['attendanceRequisionType'] = this.attendanceRequisionType;
    data['compOffRequistionType'] = this.compOffRequistionType;
    data['outRemarks'] = this.outRemarks;
    data['actualInTime'] = this.actualInTime;
    data['isShortLeave'] = this.isShortLeave;
    data['branch'] = this.branch;
    data['inTime'] = this.inTime;
    data['updatedWorkingHour'] = this.updatedWorkingHour;
    data['relaxationHour'] = this.relaxationHour;
    data['nightRequistionType'] = this.nightRequistionType;
    data['onDate'] = this.onDate;
    data['requestId'] = this.requestId;
    data['empName'] = this.empName;
    data['inRemarks'] = this.inRemarks;
    data['actualOutTime'] = this.actualOutTime;
    data['department'] = this.department;
    data['shiftWorkingHour'] = this.shiftWorkingHour;
    data['outTime'] = this.outTime;
    data['status'] = this.status;
    data['shortLeaveRequistionType'] = this.shortLeaveRequistionType;
    data['odRequistionType'] = this.odRequistionType;
    return data;
  }
}
