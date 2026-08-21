class ApprovedLeaveReqModal {
  Result? result;

  ApprovedLeaveReqModal({this.result});

  ApprovedLeaveReqModal.fromJson(Map<String, dynamic> json) {
    if (json['content'] is List) {
      result = Result(data: (json['content'] as List)
          .whereType<Map>()
          .map((item) => Data.fromJson(Map<String, dynamic>.from(item)))
          .toList());
    } else {
      result = json['result'] is Map
          ? Result.fromJson(Map<String, dynamic>.from(json['result']))
          : Result(data: <Data>[]);
    }
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
  int? requisitionId;
  String? requestType;
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
      {this.requisitionId,
        this.requestType,
        this.employeeName,
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
    requisitionId = int.tryParse((json['id'] ?? json['requisitionId'] ?? '').toString());
    requestType = json['requestType']?.toString();
    employeeName = json['employeeName']?.toString();
    leaveType = (json['leaveTypeName'] ?? json['leaveType'])?.toString();
    endDate = (json['toDate'] ?? json['endDate'])?.toString();
    approvedBy = json['approvedBy'];
    final countValue = json['days'] ?? json['count'];
    count = countValue is num
        ? countValue.toDouble()
        : double.tryParse(countValue?.toString() ?? '');
    nominee = json['nominee'];
    leaveLength = json['leaveLength'];
    startDate = (json['fromDate'] ?? json['startDate'])?.toString();
    status = json['status'];
    applicationDate = (json['appliedDate'] ?? json['applicationDate'])?.toString();
    startTime = json['startTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = requisitionId;
    data['requestType'] = requestType;
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
