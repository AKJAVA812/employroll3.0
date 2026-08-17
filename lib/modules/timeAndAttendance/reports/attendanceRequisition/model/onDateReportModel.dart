class OnDateAttModel {
  String? date;
  int? empId;
  dynamic workingHrs;
  dynamic isShortLeave;
  dynamic isOdReq;
  dynamic isNormalCoff;
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
        this.isNormalCoff,
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
    isNormalCoff = json['isNormalCoff'];
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['empId'] = empId;
    data['workingHrs'] = workingHrs;
    data['isShortLeave'] = isShortLeave;
    data['isOdReq'] = isOdReq;
    data['isNormalCoff'] = isNormalCoff;
    data['dept'] = dept;
    data['branch'] = branch;
    data['inTime'] = inTime;
    data['updatedWorkingHour'] = updatedWorkingHour;
    data['relaxationHour'] = relaxationHour;
    data['empName'] = empName;
    data['shiftWorkingHour'] = shiftWorkingHour;
    data['outTime'] = outTime;
    data['status'] = status;
    return data;
  }
}
