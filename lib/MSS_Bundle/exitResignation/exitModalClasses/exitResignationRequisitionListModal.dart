class ExitResignationRquisitionListModal {
  String? orgName;
  List<ListData>? data;

  ExitResignationRquisitionListModal({this.orgName, this.data});

  ExitResignationRquisitionListModal.fromJson(Map<String, dynamic> json) {
    orgName = json['orgName'];
    if (json['data'] != null) {
      data = <ListData>[];
      json['data'].forEach((v) {
        data!.add(new ListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orgName'] = this.orgName;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListData {
  String? empId;
  String? resignDate;
  String? lastWorkingDate;
  String? statusShow;
  String? showStatus;
  String? remark;
  String? branch;
  int? orgId;
  String? plainingg1;
  String? plainingg2;
  String? plainingg3;
  String? empCode;
  String? plainingg4;
  int? requestId;
  String? plainingg5;
  String? empName;
  String? requestDate;
  String? designation;
  String? department;
  String? doj;
  String? status;

  ListData(
      {this.empId,
        this.resignDate,
        this.lastWorkingDate,
        this.statusShow,
        this.showStatus,
        this.remark,
        this.branch,
        this.orgId,
        this.plainingg1,
        this.plainingg2,
        this.plainingg3,
        this.empCode,
        this.plainingg4,
        this.requestId,
        this.plainingg5,
        this.empName,
        this.requestDate,
        this.designation,
        this.department,
        this.doj,
        this.status});

  ListData.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    resignDate = json['resignDate'];
    lastWorkingDate = json['lastWorkingDate'];
    statusShow = json['statusShow'];
    showStatus = json['showStatus'];
    remark = json['remark'];
    branch = json['branch'];
    orgId = json['orgId'];
    plainingg1 = json['plainingg1'];
    plainingg2 = json['plainingg2'];
    plainingg3 = json['plainingg3'];
    empCode = json['empCode'];
    plainingg4 = json['plainingg4'];
    requestId = json['requestId'];
    plainingg5 = json['plainingg5'];
    empName = json['empName'];
    requestDate = json['requestDate'];
    designation = json['designation'];
    department = json['department'];
    doj = json['doj'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['resignDate'] = this.resignDate;
    data['lastWorkingDate'] = this.lastWorkingDate;
    data['statusShow'] = this.statusShow;
    data['showStatus'] = this.showStatus;
    data['remark'] = this.remark;
    data['branch'] = this.branch;
    data['orgId'] = this.orgId;
    data['plainingg1'] = this.plainingg1;
    data['plainingg2'] = this.plainingg2;
    data['plainingg3'] = this.plainingg3;
    data['empCode'] = this.empCode;
    data['plainingg4'] = this.plainingg4;
    data['requestId'] = this.requestId;
    data['plainingg5'] = this.plainingg5;
    data['empName'] = this.empName;
    data['requestDate'] = this.requestDate;
    data['designation'] = this.designation;
    data['department'] = this.department;
    data['doj'] = this.doj;
    data['status'] = this.status;
    return data;
  }
}
