class EmployeeResignationListModal {
  dynamic result;
  List<Exitlist>? exitlist;

  EmployeeResignationListModal({this.result, this.exitlist});

  EmployeeResignationListModal.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    if (json['exitlist'] != null) {
      exitlist = <Exitlist>[];
      json['exitlist'].forEach((v) {
        exitlist!.add(Exitlist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['result'] = this.result;
    if (this.exitlist != null) {
      data['exitlist'] = this.exitlist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Exitlist {
  dynamic separationMode;
  dynamic resignDate;
  dynamic lastWorkingDate;
  dynamic separationModeId;
  dynamic resonForleaving;
  dynamic dept;
  dynamic branch;
  dynamic resignationDate;
  dynamic noticePeriod;
  dynamic tentativeLeavingDate;
  dynamic attachment;
  dynamic empCode;
  dynamic empName;
  dynamic resignationActionDate;
  dynamic designation;
  dynamic resignStatus;
  dynamic exitId;
  dynamic noticePeriodDays;
  dynamic doj;
  dynamic remarks;
  dynamic status;

  Exitlist(
      {this.separationMode,
        this.resignDate,
        this.lastWorkingDate,
        this.separationModeId,
        this.resonForleaving,
        this.dept,
        this.branch,
        this.resignationDate,
        this.noticePeriod,
        this.tentativeLeavingDate,
        this.attachment,
        this.empCode,
        this.empName,
        this.resignationActionDate,
        this.designation,
        this.resignStatus,
        this.exitId,
        this.noticePeriodDays,
        this.doj,
        this.remarks,
        this.status});

  Exitlist.fromJson(Map<String, dynamic> json) {
    separationMode = json['separationMode'];
    resignDate = json['resignDate'];
    lastWorkingDate = json['lastWorkingDate'];
    separationModeId = json['separationModeId'];
    resonForleaving = json['resonForleaving'];
    dept = json['dept'];
    branch = json['branch'];
    resignationDate = json['resignationDate'];
    noticePeriod = json['noticePeriod'];
    tentativeLeavingDate = json['tentativeLeavingDate'];
    attachment = json['attachment'];
    empCode = json['empCode'];
    empName = json['empName'];
    resignationActionDate = json['resignationActionDate'];
    designation = json['designation'];
    resignStatus = json['resignStatus'];
    exitId = json['exitId'];
    noticePeriodDays = json['noticePeriodDays'];
    doj = json['doj'];
    remarks = json['remarks'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['separationMode'] = this.separationMode;
    data['resignDate'] = this.resignDate;
    data['lastWorkingDate'] = this.lastWorkingDate;
    data['separationModeId'] = this.separationModeId;
    data['resonForleaving'] = this.resonForleaving;
    data['dept'] = this.dept;
    data['branch'] = this.branch;
    data['resignationDate'] = this.resignationDate;
    data['noticePeriod'] = this.noticePeriod;
    data['tentativeLeavingDate'] = this.tentativeLeavingDate;
    data['attachment'] = this.attachment;
    data['empCode'] = this.empCode;
    data['empName'] = this.empName;
    data['resignationActionDate'] = this.resignationActionDate;
    data['designation'] = this.designation;
    data['resignStatus'] = this.resignStatus;
    data['exitId'] = this.exitId;
    data['noticePeriodDays'] = this.noticePeriodDays;
    data['doj'] = this.doj;
    data['remarks'] = this.remarks;
    data['status'] = this.status;
    return data;
  }
}
