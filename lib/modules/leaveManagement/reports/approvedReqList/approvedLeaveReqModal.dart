class ApprovedLeaveReqModal {
  Result? result;

  ApprovedLeaveReqModal({this.result});

  ApprovedLeaveReqModal.fromJson(Map<String, dynamic> json) {
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
  String? employeeName;
  String? leaveType;
  String? endDate;
  String? approvedBy;
  double? count;
  String? nominee;
  String? leaveLength;
  String? startDate;
  String? status;
  String? applicationDate;
  String? startTime;
  String? endTime;

  Data(
      {this.employeeName,
        this.leaveType,
        this.endDate,
        this.approvedBy,
        this.count,
        this.nominee,
        this.leaveLength,
        this.startDate,
        this.status,
        this.applicationDate,
        this.startTime,
        this.endTime});

  Data.fromJson(Map<String, dynamic> json) {
    employeeName = json['employeeName'];
    leaveType = json['leaveType'];
    endDate = json['endDate'];
    approvedBy = json['approvedBy'];
    count = json['count'];
    nominee = json['nominee'];
    leaveLength = json['leaveLength'];
    startDate = json['startDate'];
    status = json['status'];
    applicationDate = json['applicationDate'];
    startTime = json['startTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employeeName'] = employeeName;
    data['leaveType'] = leaveType;
    data['endDate'] = endDate;
    data['approvedBy'] = approvedBy;
    data['count'] = count;
    data['nominee'] = nominee;
    data['leaveLength'] = leaveLength;
    data['startDate'] = startDate;
    data['status'] = status;
    data['applicationDate'] = applicationDate;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    return data;
  }
}
