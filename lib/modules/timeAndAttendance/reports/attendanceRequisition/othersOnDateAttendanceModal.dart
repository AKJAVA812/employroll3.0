class OthersOnDateAttendanceModal {
  String? inTime;
  String? departmentName;
  String? employeeName;
  int? empId;
  String? workingHrs;
  String? onDate;
  String? branchName;
  int? logId;
  String? outTime;
  String? applicationDate;
  String? status;

  OthersOnDateAttendanceModal(
      {this.inTime,
        this.departmentName,
        this.employeeName,
        this.empId,
        this.workingHrs,
        this.onDate,
        this.branchName,
        this.logId,
        this.outTime,
        this.applicationDate,
        this.status});

  OthersOnDateAttendanceModal.fromJson(Map<String, dynamic> json) {
    inTime = json['inTime'];
    departmentName = json['departmentName'];
    employeeName = json['employeeName'];
    empId = json['empId'];
    workingHrs = json['workingHrs'];
    onDate = json['onDate'];
    branchName = json['branchName'];
    logId = json['logId'];
    outTime = json['outTime'];
    applicationDate = json['applicationDate'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['inTime'] = inTime;
    data['departmentName'] = departmentName;
    data['employeeName'] = employeeName;
    data['empId'] = empId;
    data['workingHrs'] = workingHrs;
    data['onDate'] = onDate;
    data['branchName'] = branchName;
    data['logId'] = logId;
    data['outTime'] = outTime;
    data['applicationDate'] = applicationDate;
    data['status'] = status;
    return data;
  }
}
