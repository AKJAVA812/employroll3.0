class SelfLeaveRequisitionListModal {
  List<Data>? data;

  SelfLeaveRequisitionListModal({this.data});

  SelfLeaveRequisitionListModal.fromJson(Map<String, dynamic> json) {
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
    leavetype = json['leavetype'];
    noOfDay = json['noOfDay'];
    endDate = json['endDate'];
    branchName = json['branchName'];
    employeeId = json['employeeId'];
    leaveLength = json['leaveLength'];
    approvaldate = json['approvaldate'];
    applicationdate = json['applicationdate'];
    empName = json['empName'];
    nominee = json['nominee'];
    startTime = json['startTime'];
    leaveId = json['leaveId'];
    appliedby = json['appliedby'];
    endTime = json['endTime'];
    leavereqId = json['leavereqId'];
    approvarRemark = json['approvarRemark'];
    startDate = json['startDate'];
    status = json['status'];
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
