class OnDateAttModel {
  String? date;
  String? inTime;
  int? empId;
  String? workingHrs;
  String? empName;
  String? dept;
  String? branch;
  String? outTime;
  String? status;

  OnDateAttModel(
      {this.date,
        this.inTime,
        this.empId,
        this.workingHrs,
        this.empName,
        this.dept,
        this.branch,
        this.outTime,
        this.status});

  OnDateAttModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    inTime = json['inTime'];
    empId = json['empId'];
    workingHrs = json['workingHrs'];
    empName = json['empName'];
    dept = json['dept'];
    branch = json['branch'];
    outTime = json['outTime'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['inTime'] = this.inTime;
    data['empId'] = this.empId;
    data['workingHrs'] = this.workingHrs;
    data['empName'] = this.empName;
    data['dept'] = this.dept;
    data['branch'] = this.branch;
    data['outTime'] = this.outTime;
    data['status'] = this.status;
    return data;
  }
}
