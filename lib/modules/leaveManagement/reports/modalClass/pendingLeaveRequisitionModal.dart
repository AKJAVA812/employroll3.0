class PendingLeaveRequisitionModal {
  Result? result;

  PendingLeaveRequisitionModal({this.result});

  PendingLeaveRequisitionModal.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.toJson();
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
  String? requestType;
  int? currentLevel;
  int? totalLevels;


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
    requestType = json['requestType'];
    currentLevel = int.tryParse(
      (json['currentLevel'] ?? json['approvalLevel'] ?? json['levelNo'] ?? '')
          .toString(),
    );
    totalLevels = int.tryParse((json['totalLevels'] ?? '').toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['summary'] = summary;
    data['employeeName'] = employeeName;
    data['empId'] = empId;
    data['endDate'] = endDate;
    data['document'] = document;
    data['count'] = count;
    data['branchName'] = branchName;
    data['leaveLength'] = leaveLength;
    data['reqId'] = reqId;
    data['totalLeave'] = totalLeave;
    data['leaveType'] = leaveType;
    data['nominee'] = nominee;
    data['department'] = department;
    data['startDate'] = startDate;
    data['applicationDate'] = applicationDate;
    data['status'] = status;
    data['approvedBy'] = approvedBy;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['requestType'] = requestType;
    data['currentLevel'] = currentLevel;
    data['totalLevels'] = totalLevels;
    return data;
  }
}
