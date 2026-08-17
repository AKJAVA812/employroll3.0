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
    final Map<String, dynamic> data = <String, dynamic>{};
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
  dynamic requestType;
  int? currentLevel;
  int? totalLevels;

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
        this.requestType,
        this.currentLevel,
        this.totalLevels,
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
    requestType = json['requestType'];
    currentLevel = int.tryParse(
      (json['currentLevel'] ?? json['approvalLevel'] ?? json['levelNo'] ?? '')
          .toString(),
    );
    totalLevels = int.tryParse((json['totalLevels'] ?? '').toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empId'] = empId;
    data['attendanceRequisionType'] = attendanceRequisionType;
    data['compOffRequistionType'] = compOffRequistionType;
    data['outRemarks'] = outRemarks;
    data['actualInTime'] = actualInTime;
    data['isShortLeave'] = isShortLeave;
    data['branch'] = branch;
    data['inTime'] = inTime;
    data['updatedWorkingHour'] = updatedWorkingHour;
    data['relaxationHour'] = relaxationHour;
    data['nightRequistionType'] = nightRequistionType;
    data['onDate'] = onDate;
    data['requestId'] = requestId;
    data['empName'] = empName;
    data['inRemarks'] = inRemarks;
    data['actualOutTime'] = actualOutTime;
    data['department'] = department;
    data['shiftWorkingHour'] = shiftWorkingHour;
    data['outTime'] = outTime;
    data['status'] = status;
    data['shortLeaveRequistionType'] = shortLeaveRequistionType;
    data['odRequistionType'] = odRequistionType;
    data['requestType'] = requestType;
    data['currentLevel'] = currentLevel;
    data['totalLevels'] = totalLevels;
    return data;
  }
}
