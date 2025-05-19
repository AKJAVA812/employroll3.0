class ClaimApproverListModalClass {
  List<Data>? data;
  dynamic appList;
  dynamic disAppList;
  dynamic draftList;
  dynamic pendingList;

  ClaimApproverListModalClass(
      {this.data,
        this.appList,
        this.disAppList,
        this.draftList,
        this.pendingList});

  ClaimApproverListModalClass.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    appList = json['appList'];
    disAppList = json['disAppList'];
    draftList = json['draftList'];
    pendingList = json['pendingList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['appList'] = this.appList;
    data['disAppList'] = this.disAppList;
    data['draftList'] = this.draftList;
    data['pendingList'] = this.pendingList;
    return data;
  }
}

class Data {
  dynamic empId;
  dynamic claimNo;
  dynamic raiseOn;
  dynamic raisedOn;
  dynamic claimAmount;
  dynamic statusShow;
  dynamic claimId;
  dynamic dept;
  dynamic branch;
  dynamic orgId;
  dynamic plainingg1;
  dynamic isCheck;
  dynamic plainingg2;
  dynamic plainingg3;
  dynamic empCode;
  dynamic plainingg4;
  dynamic plainingg5;
  dynamic empName;
  dynamic designation;
  dynamic approvedAmount;
  dynamic reimbName;
  dynamic status;

  Data(
      {this.empId,
        this.claimNo,
        this.raiseOn,
        this.raisedOn,
        this.claimAmount,
        this.statusShow,
        this.claimId,
        this.dept,
        this.branch,
        this.orgId,
        this.plainingg1,
        this.isCheck,
        this.plainingg2,
        this.plainingg3,
        this.empCode,
        this.plainingg4,
        this.plainingg5,
        this.empName,
        this.designation,
        this.approvedAmount,
        this.reimbName,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    claimNo = json['claimNo'];
    raiseOn = json['raiseOn'];
    raisedOn = json['raisedOn'];
    claimAmount = json['claimAmount'];
    statusShow = json['statusShow'];
    claimId = json['claimId'];
    dept = json['dept'];
    branch = json['branch'];
    orgId = json['orgId'];
    plainingg1 = json['plainingg1'];
    isCheck = json['isCheck'];
    plainingg2 = json['plainingg2'];
    plainingg3 = json['plainingg3'];
    empCode = json['empCode'];
    plainingg4 = json['plainingg4'];
    plainingg5 = json['plainingg5'];
    empName = json['empName'];
    designation = json['designation'];
    approvedAmount = json['approvedAmount'];
    reimbName = json['reimbName'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['claimNo'] = this.claimNo;
    data['raiseOn'] = this.raiseOn;
    data['raisedOn'] = this.raisedOn;
    data['claimAmount'] = this.claimAmount;
    data['statusShow'] = this.statusShow;
    data['claimId'] = this.claimId;
    data['dept'] = this.dept;
    data['branch'] = this.branch;
    data['orgId'] = this.orgId;
    data['plainingg1'] = this.plainingg1;
    data['isCheck'] = this.isCheck;
    data['plainingg2'] = this.plainingg2;
    data['plainingg3'] = this.plainingg3;
    data['empCode'] = this.empCode;
    data['plainingg4'] = this.plainingg4;
    data['plainingg5'] = this.plainingg5;
    data['empName'] = this.empName;
    data['designation'] = this.designation;
    data['approvedAmount'] = this.approvedAmount;
    data['reimbName'] = this.reimbName;
    data['status'] = this.status;
    return data;
  }
}
