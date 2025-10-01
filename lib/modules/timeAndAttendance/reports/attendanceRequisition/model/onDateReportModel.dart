class OnDateAttModel {
  String? date;
  int? empId;
  String? workingHrs;
  dynamic isShortLeave;
  dynamic isOdReq;
  String? dept;
  String? branch;
  String? inTime;
  String? updatedWorkingHour;
  String? relaxationHour;
  String? empName;
  String? shiftWorkingHour;
  String? outTime;
  String? status;

  OnDateAttModel(
      {this.date,
        this.empId,
        this.workingHrs,
        this.isShortLeave,
        this.isOdReq,
        this.dept,
        this.branch,
        this.inTime,
        this.updatedWorkingHour,
        this.relaxationHour,
        this.empName,
        this.shiftWorkingHour,
        this.outTime,
        this.status});

  OnDateAttModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    empId = json['empId'];
    workingHrs = json['workingHrs'];
    isShortLeave = json['isShortLeave'];
    isOdReq = json['isOdReq'];
    dept = json['dept'];
    branch = json['branch'];
    inTime = json['inTime'];
    updatedWorkingHour = json['updatedWorkingHour'];
    relaxationHour = json['relaxationHour'];
    empName = json['empName'];
    shiftWorkingHour = json['shiftWorkingHour'];
    outTime = json['outTime'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['empId'] = this.empId;
    data['workingHrs'] = this.workingHrs;
    data['isShortLeave'] = this.isShortLeave;
    data['isOdReq'] = this.isOdReq;
    data['dept'] = this.dept;
    data['branch'] = this.branch;
    data['inTime'] = this.inTime;
    data['updatedWorkingHour'] = this.updatedWorkingHour;
    data['relaxationHour'] = this.relaxationHour;
    data['empName'] = this.empName;
    data['shiftWorkingHour'] = this.shiftWorkingHour;
    data['outTime'] = this.outTime;
    data['status'] = this.status;
    return data;
  }
}
