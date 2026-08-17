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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    if (exitlist != null) {
      data['exitlist'] = exitlist!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['separationMode'] = separationMode;
    data['resignDate'] = resignDate;
    data['lastWorkingDate'] = lastWorkingDate;
    data['separationModeId'] = separationModeId;
    data['resonForleaving'] = resonForleaving;
    data['dept'] = dept;
    data['branch'] = branch;
    data['resignationDate'] = resignationDate;
    data['noticePeriod'] = noticePeriod;
    data['tentativeLeavingDate'] = tentativeLeavingDate;
    data['attachment'] = attachment;
    data['empCode'] = empCode;
    data['empName'] = empName;
    data['resignationActionDate'] = resignationActionDate;
    data['designation'] = designation;
    data['resignStatus'] = resignStatus;
    data['exitId'] = exitId;
    data['noticePeriodDays'] = noticePeriodDays;
    data['doj'] = doj;
    data['remarks'] = remarks;
    data['status'] = status;
    return data;
  }
}
