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
        data!.add(Data.fromJson(v));
      });
    }
    appList = json['appList'];
    disAppList = json['disAppList'];
    draftList = json['draftList'];
    pendingList = json['pendingList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['appList'] = appList;
    data['disAppList'] = disAppList;
    data['draftList'] = draftList;
    data['pendingList'] = pendingList;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empId'] = empId;
    data['claimNo'] = claimNo;
    data['raiseOn'] = raiseOn;
    data['raisedOn'] = raisedOn;
    data['claimAmount'] = claimAmount;
    data['statusShow'] = statusShow;
    data['claimId'] = claimId;
    data['dept'] = dept;
    data['branch'] = branch;
    data['orgId'] = orgId;
    data['plainingg1'] = plainingg1;
    data['isCheck'] = isCheck;
    data['plainingg2'] = plainingg2;
    data['plainingg3'] = plainingg3;
    data['empCode'] = empCode;
    data['plainingg4'] = plainingg4;
    data['plainingg5'] = plainingg5;
    data['empName'] = empName;
    data['designation'] = designation;
    data['approvedAmount'] = approvedAmount;
    data['reimbName'] = reimbName;
    data['status'] = status;
    return data;
  }
}
