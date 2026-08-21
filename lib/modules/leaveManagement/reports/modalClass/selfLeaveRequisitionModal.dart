class SelfLeaveRequisitionListModal {
  List<Data>? data;

  SelfLeaveRequisitionListModal({this.data});

  SelfLeaveRequisitionListModal.fromJson(Map<String, dynamic> json) {
    Object? source = json['content'];
    final nestedData = json['data'];
    if (source is! List && nestedData is List) {
      source = nestedData;
    } else if (source is! List && nestedData is Map) {
      source = nestedData['content'] ?? nestedData['data'];
    }
    final nestedResult = json['result'];
    if (source is! List && nestedResult is Map) {
      source = nestedResult['content'] ?? nestedResult['data'];
    }
    if (source is List) {
      data = <Data>[];
      for (var v in source) {
        if (v is Map) {
          data!.add(Data.fromJson(Map<String, dynamic>.from(v)));
        }
      }
    } else {
      data = <Data>[];
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
  String? deptName;
  int? branchId;
  String? leavetype;
  double? noOfDay;
  String? endDate;
  String? branchName;
  String? employeeId;
  String? leaveLength;
  String? approvaldate;
  String? applicationdate;
  String? empName;
  String? nominee;
  String? startTime;
  int? leaveId;
  String? appliedby;
  String? endTime;
  int? leavereqId;
  String? approvarRemark;
  String? startDate;
  String? status;
  String? requestType;
  String? approvedBy;
  String? reversalStatus;
  int? reversalRequestId;
  List<String> reversalRequestedDates = <String>[];

  Data(
      {this.deptName,
        this.branchId,
        this.leavetype,
        this.noOfDay,
        this.endDate,
        this.branchName,
        this.employeeId,
        this.leaveLength,
        this.approvaldate,
        this.applicationdate,
        this.empName,
        this.nominee,
        this.startTime,
        this.leaveId,
        this.appliedby,
        this.endTime,
        this.leavereqId,
        this.approvarRemark,
        this.startDate,
        this.status,
        this.requestType,
        this.approvedBy,
        this.reversalStatus,
        this.reversalRequestId,
        this.reversalRequestedDates = const <String>[]});

  Data.fromJson(Map<String, dynamic> json) {
    deptName = json['deptName']?.toString() ?? '';
    branchId = _intValue(json['branchId']);
    leavetype = json['leaveTypeName']?.toString() ?? json['leavetype']?.toString() ?? '';
    noOfDay = _doubleValue(json['days']) ?? _doubleValue(json['noOfDay']);
    endDate = json['toDate']?.toString() ?? json['endDate']?.toString() ?? '';
    branchName = json['branchName']?.toString() ?? '';
    employeeId = json['employeeCode']?.toString() ?? json['employeeId']?.toString() ?? '';
    leaveLength = json['leaveLength']?.toString() ?? '';
    approvaldate = json['actionedAt']?.toString() ?? json['approvaldate']?.toString() ?? '';
    applicationdate = json['appliedDate']?.toString() ?? json['applicationdate']?.toString() ?? '';
    empName = json['employeeName']?.toString() ?? json['empName']?.toString() ?? '';
    nominee = json['nominee']?.toString() ?? '';
    startTime = json['sessionName']?.toString() ?? json['startTime']?.toString() ?? '';
    leaveId = _intValue(json['leaveId']);
    appliedby = json['appliedBy']?.toString() ?? json['appliedby']?.toString() ?? '';
    endTime = json['endTime']?.toString() ?? '';
    leavereqId = int.tryParse(json['id']?.toString() ?? json['leavereqId']?.toString() ?? '');
    approvarRemark = json['approvedRemarks']?.toString() ?? json['approvarRemark']?.toString() ?? '';
    startDate = json['fromDate']?.toString() ?? json['startDate']?.toString() ?? '';
    status = (json['status'] ??
            json['requisitionStatus'] ??
            json['approvalStatus'] ??
            '')
        .toString()
        .trim()
        .toUpperCase();
    requestType = json['requestType']?.toString() ?? 'leave';
    approvedBy = json['approvedBy']?.toString() ?? '';
    reversalStatus = json['reversalStatus']?.toString().trim().toUpperCase() ?? '';
    reversalRequestId = _intValue(json['reversalRequestId']);
    reversalRequestedDates = (json['reversalRequestedDates'] as List? ?? const <dynamic>[])
        .map((value) => value.toString())
        .where((value) => value.isNotEmpty)
        .toList();
  }

  static int? _intValue(Object? value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString().trim() ?? '');
  }

  static double? _doubleValue(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString().trim() ?? '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deptName'] = deptName;
    data['branchId'] = branchId;
    data['leavetype'] = leavetype;
    data['noOfDay'] = noOfDay;
    data['endDate'] = endDate;
    data['branchName'] = branchName;
    data['employeeId'] = employeeId;
    data['leaveLength'] = leaveLength;
    data['approvaldate'] = approvaldate;
    data['applicationdate'] = applicationdate;
    data['empName'] = empName;
    data['nominee'] = nominee;
    data['startTime'] = startTime;
    data['leaveId'] = leaveId;
    data['appliedby'] = appliedby;
    data['endTime'] = endTime;
    data['leavereqId'] = leavereqId;
    data['approvarRemark'] = approvarRemark;
    data['startDate'] = startDate;
    data['status'] = status;
    data['requestType'] = requestType;
    data['approvedBy'] = approvedBy;
    data['reversalStatus'] = reversalStatus;
    data['reversalRequestId'] = reversalRequestId;
    data['reversalRequestedDates'] = reversalRequestedDates;
    return data;
  }
}
