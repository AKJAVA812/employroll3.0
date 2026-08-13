class SelfLeaveRequisitionListModal {
  List<Data>? data;

  SelfLeaveRequisitionListModal({this.data});

  SelfLeaveRequisitionListModal.fromJson(Map<String, dynamic> json) {
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
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    deptName = json['deptName'];
    branchId = json['branchId'];
    leavetype = json['leaveTypeName']?.toString() ?? json['leavetype']?.toString() ?? '';
    noOfDay = (json['days'] as num?)?.toDouble() ?? (json['noOfDay'] as num?)?.toDouble();
    endDate = json['toDate']?.toString() ?? json['endDate']?.toString() ?? '';
    branchName = json['branchName'];
    employeeId = json['employeeCode']?.toString() ?? json['employeeId']?.toString() ?? '';
    leaveLength = json['leaveLength']?.toString() ?? '';
    approvaldate = json['actionedAt']?.toString() ?? json['approvaldate']?.toString() ?? '';
    applicationdate = json['appliedDate']?.toString() ?? json['applicationdate']?.toString() ?? '';
    empName = json['employeeName']?.toString() ?? json['empName']?.toString() ?? '';
    nominee = json['nominee'];
    startTime = json['sessionName']?.toString() ?? json['startTime']?.toString() ?? '';
    leaveId = json['leaveId'];
    appliedby = json['appliedBy']?.toString() ?? json['appliedby']?.toString() ?? '';
    endTime = json['endTime']?.toString() ?? '';
    leavereqId = int.tryParse(json['id']?.toString() ?? json['leavereqId']?.toString() ?? '');
    approvarRemark = json['approvedRemarks']?.toString() ?? json['approvarRemark']?.toString() ?? '';
    startDate = json['fromDate']?.toString() ?? json['startDate']?.toString() ?? '';
    status = (json['status']?.toString() ?? '').toUpperCase();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['deptName'] = this.deptName;
    data['branchId'] = this.branchId;
    data['leavetype'] = this.leavetype;
    data['noOfDay'] = this.noOfDay;
    data['endDate'] = this.endDate;
    data['branchName'] = this.branchName;
    data['employeeId'] = this.employeeId;
    data['leaveLength'] = this.leaveLength;
    data['approvaldate'] = this.approvaldate;
    data['applicationdate'] = this.applicationdate;
    data['empName'] = this.empName;
    data['nominee'] = this.nominee;
    data['startTime'] = this.startTime;
    data['leaveId'] = this.leaveId;
    data['appliedby'] = this.appliedby;
    data['endTime'] = this.endTime;
    data['leavereqId'] = this.leavereqId;
    data['approvarRemark'] = this.approvarRemark;
    data['startDate'] = this.startDate;
    data['status'] = this.status;
    return data;
  }
}
