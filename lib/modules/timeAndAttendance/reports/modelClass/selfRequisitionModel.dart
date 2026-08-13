class SelfRequisitionModel {
  List<Data>? data;

  SelfRequisitionModel({this.data});

  SelfRequisitionModel.fromJson(Map<String, dynamic> json) {
    final source = json['content'] ?? json['data'];
    if (source is List) {
      data = <Data>[];
      source.forEach((v) {
        if (v is Map) data!.add(Data.fromJson(Map<String, dynamic>.from(v)));
      });
    } else {
      data = <Data>[];
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
  bool? odRequistionType;
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
        this.odRequistionType,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    final requestType = json['requestType']?.toString().toLowerCase() ?? '';
    empId = json['employeeCode']?.toString() ?? json['empId']?.toString();
    employeeName = json['employeeName']?.toString() ?? '';
    inTimeRemark = json['reason']?.toString() ?? json['inTimeRemark']?.toString() ?? '';
    attendanceRequisionType = requestType == 'regularization';
    compOffRequistionType = requestType == 'overtime';
    outTimeRemark = json['detail']?.toString() ?? json['outTimeRemark']?.toString() ?? '';
    creationDate = json['appliedDate']?.toString() ?? json['creationDate']?.toString() ?? '';
    reqId = int.tryParse(json['id']?.toString() ?? json['reqId']?.toString() ?? '');
    inTime = json['requestedIn']?.toString() ?? json['inTime']?.toString() ?? '';
    reqDate = json['fromDate']?.toString() ?? json['reqDate']?.toString() ?? '';
    nightRequistionType = json['nightRequistionType'] == true;
    empDetailsId = int.tryParse(json['employeeId']?.toString() ?? json['empDetailsId']?.toString() ?? '');
    outTime = json['requestedOut']?.toString() ?? json['outTime']?.toString() ?? '';
    shortLeaveRequistionType = requestType == 'short_leave';
    odRequistionType = requestType == 'od';
    status = (json['status']?.toString() ??
            json['approvalStatus']?.toString() ??
            json['requestStatus']?.toString() ??
            '')
        .toUpperCase();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    data['odRequistionType'] = this.odRequistionType;
    data['status'] = this.status;
    return data;
  }
}
