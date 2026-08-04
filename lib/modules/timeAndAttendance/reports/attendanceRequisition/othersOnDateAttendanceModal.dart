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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['inTime'] = this.inTime;
    data['departmentName'] = this.departmentName;
    data['employeeName'] = this.employeeName;
    data['empId'] = this.empId;
    data['workingHrs'] = this.workingHrs;
    data['onDate'] = this.onDate;
    data['branchName'] = this.branchName;
    data['logId'] = this.logId;
    data['outTime'] = this.outTime;
    data['applicationDate'] = this.applicationDate;
    data['status'] = this.status;
    return data;
  }
}
