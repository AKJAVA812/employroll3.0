class PendingLeaveRequisitionModal {
  Result? result;

  PendingLeaveRequisitionModal({this.result});

  PendingLeaveRequisitionModal.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  List<Data>? data;

  Result({this.data});

  Result.fromJson(Map<String, dynamic> json) {
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
  String? summary;
  String? employeeName;
  int? empId;
  String? endDate;
  dynamic document;
  double? count;
  String? branchName;
  String? leaveLength;
  int? reqId;
  var totalLeave;
  String? leaveType;
  String? nominee;
  String? department;
  String? startDate;
  String? applicationDate;
  String? status;
  String? approvedBy;
  String? startTime;
  String? endTime;


  Data(
      {this.summary,
        this.employeeName,
        this.empId,
        this.endDate,
        this.document,
        this.count,
        this.branchName,
        this.leaveLength,
        this.reqId,
        this.totalLeave,
        this.leaveType,
        this.nominee,
        this.department,
        this.startDate,
        this.applicationDate,
        this.status,
        this.approvedBy,
        this.startTime,
        this.endTime});

  Data.fromJson(Map<String, dynamic> json) {
    summary = json['summary'];
    employeeName = json['employeeName'];
    empId = json['empId'];
    endDate = json['endDate'];
    document = json['document'];
    count = json['count'];
    branchName = json['branchName'];
    leaveLength = json['leaveLength'];
    reqId = json['reqId'];
    totalLeave = json['totalLeave'];
    leaveType = json['leaveType'];
    nominee = json['nominee'];
    department = json['department'];
    startDate = json['startDate'];
    applicationDate = json['applicationDate'];
    status = json['status'];
    approvedBy = json['approvedBy'];
    startTime = json['startTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['summary'] = this.summary;
    data['employeeName'] = this.employeeName;
    data['empId'] = this.empId;
    data['endDate'] = this.endDate;
    data['document'] = this.document;
    data['count'] = this.count;
    data['branchName'] = this.branchName;
    data['leaveLength'] = this.leaveLength;
    data['reqId'] = this.reqId;
    data['totalLeave'] = this.totalLeave;
    data['leaveType'] = this.leaveType;
    data['nominee'] = this.nominee;
    data['department'] = this.department;
    data['startDate'] = this.startDate;
    data['applicationDate'] = this.applicationDate;
    data['status'] = this.status;
    data['approvedBy'] = this.approvedBy;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    return data;
  }
}
