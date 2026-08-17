class ExitResignationRquisitionListModal {
  String? orgName;
  List<ListData>? data;

  ExitResignationRquisitionListModal({this.orgName, this.data});

  ExitResignationRquisitionListModal.fromJson(Map<String, dynamic> json) {
    orgName = json['orgName'];
    if (json['data'] != null) {
      data = <ListData>[];
      json['data'].forEach((v) {
        data!.add(ListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orgName'] = orgName;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empId'] = empId;
    data['resignDate'] = resignDate;
    data['lastWorkingDate'] = lastWorkingDate;
    data['statusShow'] = statusShow;
    data['showStatus'] = showStatus;
    data['remark'] = remark;
    data['branch'] = branch;
    data['orgId'] = orgId;
    data['plainingg1'] = plainingg1;
    data['plainingg2'] = plainingg2;
    data['plainingg3'] = plainingg3;
    data['empCode'] = empCode;
    data['plainingg4'] = plainingg4;
    data['requestId'] = requestId;
    data['plainingg5'] = plainingg5;
    data['empName'] = empName;
    data['requestDate'] = requestDate;
    data['designation'] = designation;
    data['department'] = department;
    data['doj'] = doj;
    data['status'] = status;
    return data;
  }
}
