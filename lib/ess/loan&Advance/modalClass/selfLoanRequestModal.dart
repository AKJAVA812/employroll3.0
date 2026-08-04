class SelfLoanRequestModal {
  dynamic approvedValue;
  List<LoanRequisitionApprovedlist>? loanRequisitionApprovedlist;
  List<LoanRequisitionDisapprovelist>? loanRequisitionDisapprovelist;
  List<LoanRequiDataforOthers>? loanRequiDataforOthers;
  dynamic disApprovedValue;
  List<LoanRequisitionPendinglist>? loanRequisitionPendinglist;
  dynamic pendingAmount;

  SelfLoanRequestModal(
      {this.approvedValue,
        this.loanRequisitionApprovedlist,
        this.loanRequisitionDisapprovelist,
        this.loanRequiDataforOthers,
        this.disApprovedValue,
        this.loanRequisitionPendinglist,
        this.pendingAmount});

  SelfLoanRequestModal.fromJson(Map<String, dynamic> json) {
    approvedValue = json['approvedValue'];
    if (json['loanRequisitionApprovedlist'] != null) {
      loanRequisitionApprovedlist = <LoanRequisitionApprovedlist>[];
      json['loanRequisitionApprovedlist'].forEach((v) {
        loanRequisitionApprovedlist!
            .add(LoanRequisitionApprovedlist.fromJson(v));
      });
    }
    if (json['loanRequisitionDisapprovelist'] != null) {
      loanRequisitionDisapprovelist = <LoanRequisitionDisapprovelist>[];
      json['loanRequisitionDisapprovelist'].forEach((v) {
        loanRequisitionDisapprovelist!
            .add(LoanRequisitionDisapprovelist.fromJson(v));
      });
    }
    if (json['loanRequiDataforOthers'] != null) {
      loanRequiDataforOthers = <LoanRequiDataforOthers>[];
      json['loanRequiDataforOthers'].forEach((v) {
        loanRequiDataforOthers!.add(LoanRequiDataforOthers.fromJson(v));
      });
    }
    disApprovedValue = json['disApprovedValue'];
    if (json['loanRequisitionPendinglist'] != null) {
      loanRequisitionPendinglist = <LoanRequisitionPendinglist>[];
      json['loanRequisitionPendinglist'].forEach((v) {
        loanRequisitionPendinglist!
            .add(LoanRequisitionPendinglist.fromJson(v));
      });
    }
    pendingAmount = json['pendingAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['approvedValue'] = this.approvedValue;
    if (this.loanRequisitionApprovedlist != null) {
      data['loanRequisitionApprovedlist'] =
          this.loanRequisitionApprovedlist!.map((v) => v.toJson()).toList();
    }
    if (this.loanRequisitionDisapprovelist != null) {
      data['loanRequisitionDisapprovelist'] =
          this.loanRequisitionDisapprovelist!.map((v) => v.toJson()).toList();
    }
    if (this.loanRequiDataforOthers != null) {
      data['loanRequiDataforOthers'] =
          this.loanRequiDataforOthers!.map((v) => v.toJson()).toList();
    }
    data['disApprovedValue'] = this.disApprovedValue;
    if (this.loanRequisitionPendinglist != null) {
      data['loanRequisitionPendinglist'] =
          this.loanRequisitionPendinglist!.map((v) => v.toJson()).toList();
    }
    data['pendingAmount'] = this.pendingAmount;
    return data;
  }
}

class LoanRequisitionApprovedlist {
  dynamic date;
  dynamic desig;
  dynamic loanType;
  dynamic statusShow;
  dynamic loanStatus;
  dynamic remark;
  dynamic empDetId;
  dynamic branch;
  dynamic orgId;
  dynamic approvedInstallment;
  dynamic empName;
  dynamic requestedInstallment;
  dynamic approvedAmount;
  dynamic raisedBy;
  dynamic loanAdvId;
  dynamic dept;
  dynamic loanReqId;
  dynamic loanAmount;
  dynamic plainingg1;
  dynamic plainingg2;
  dynamic plainingg3;
  dynamic empCode;
  dynamic plainingg4;
  dynamic plainingg5;
  dynamic doj;
  dynamic status;

  LoanRequisitionApprovedlist(
      {this.date,
        this.desig,
        this.loanType,
        this.statusShow,
        this.loanStatus,
        this.remark,
        this.empDetId,
        this.branch,
        this.orgId,
        this.approvedInstallment,
        this.empName,
        this.requestedInstallment,
        this.approvedAmount,
        this.raisedBy,
        this.loanAdvId,
        this.dept,
        this.loanReqId,
        this.loanAmount,
        this.plainingg1,
        this.plainingg2,
        this.plainingg3,
        this.empCode,
        this.plainingg4,
        this.plainingg5,
        this.doj,
        this.status});

  LoanRequisitionApprovedlist.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    desig = json['desig'];
    loanType = json['LoanType'];
    statusShow = json['statusShow'];
    loanStatus = json['LoanStatus'];
    remark = json['remark'];
    empDetId = json['empDetId'];
    branch = json['branch'];
    orgId = json['orgId'];
    approvedInstallment = json['approvedInstallment'];
    empName = json['empName'];
    requestedInstallment = json['requestedInstallment'];
    approvedAmount = json['approvedAmount'];
    raisedBy = json['raisedBy'];
    loanAdvId = json['loanAdvId'];
    dept = json['dept'];
    loanReqId = json['loanReqId'];
    loanAmount = json['loanAmount'];
    plainingg1 = json['plainingg1'];
    plainingg2 = json['plainingg2'];
    plainingg3 = json['plainingg3'];
    empCode = json['empCode'];
    plainingg4 = json['plainingg4'];
    plainingg5 = json['plainingg5'];
    doj = json['doj'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['date'] = this.date;
    data['desig'] = this.desig;
    data['LoanType'] = this.loanType;
    data['statusShow'] = this.statusShow;
    data['LoanStatus'] = this.loanStatus;
    data['remark'] = this.remark;
    data['empDetId'] = this.empDetId;
    data['branch'] = this.branch;
    data['orgId'] = this.orgId;
    data['approvedInstallment'] = this.approvedInstallment;
    data['empName'] = this.empName;
    data['requestedInstallment'] = this.requestedInstallment;
    data['approvedAmount'] = this.approvedAmount;
    data['raisedBy'] = this.raisedBy;
    data['loanAdvId'] = this.loanAdvId;
    data['dept'] = this.dept;
    data['loanReqId'] = this.loanReqId;
    data['loanAmount'] = this.loanAmount;
    data['plainingg1'] = this.plainingg1;
    data['plainingg2'] = this.plainingg2;
    data['plainingg3'] = this.plainingg3;
    data['empCode'] = this.empCode;
    data['plainingg4'] = this.plainingg4;
    data['plainingg5'] = this.plainingg5;
    data['doj'] = this.doj;
    data['status'] = this.status;
    return data;
  }
}

class LoanRequisitionDisapprovelist {
  dynamic date;
  dynamic desig;
  dynamic loanType;
  dynamic statusShow;
  dynamic loanStatus;
  dynamic remark;
  dynamic empDetId;
  dynamic branch;
  dynamic orgId;
  dynamic approvedInstallment;
  dynamic empName;
  dynamic requestedInstallment;
  dynamic approvedAmount;
  dynamic raisedBy;
  dynamic loanAdvId;
  dynamic dept;
  dynamic loanReqId;
  dynamic loanAmount;
  dynamic plainingg1;
  dynamic plainingg2;
  dynamic plainingg3;
  dynamic empCode;
  dynamic plainingg4;
  dynamic plainingg5;
  dynamic doj;
  dynamic status;

  LoanRequisitionDisapprovelist(
      {this.date,
        this.desig,
        this.loanType,
        this.statusShow,
        this.loanStatus,
        this.remark,
        this.empDetId,
        this.branch,
        this.orgId,
        this.approvedInstallment,
        this.empName,
        this.requestedInstallment,
        this.approvedAmount,
        this.raisedBy,
        this.loanAdvId,
        this.dept,
        this.loanReqId,
        this.loanAmount,
        this.plainingg1,
        this.plainingg2,
        this.plainingg3,
        this.empCode,
        this.plainingg4,
        this.plainingg5,
        this.doj,
        this.status});

  LoanRequisitionDisapprovelist.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    desig = json['desig'];
    loanType = json['LoanType'];
    statusShow = json['statusShow'];
    loanStatus = json['LoanStatus'];
    remark = json['remark'];
    empDetId = json['empDetId'];
    branch = json['branch'];
    orgId = json['orgId'];
    approvedInstallment = json['approvedInstallment'];
    empName = json['empName'];
    requestedInstallment = json['requestedInstallment'];
    approvedAmount = json['approvedAmount'];
    raisedBy = json['raisedBy'];
    loanAdvId = json['loanAdvId'];
    dept = json['dept'];
    loanReqId = json['loanReqId'];
    loanAmount = json['loanAmount'];
    plainingg1 = json['plainingg1'];
    plainingg2 = json['plainingg2'];
    plainingg3 = json['plainingg3'];
    empCode = json['empCode'];
    plainingg4 = json['plainingg4'];
    plainingg5 = json['plainingg5'];
    doj = json['doj'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['date'] = this.date;
    data['desig'] = this.desig;
    data['LoanType'] = this.loanType;
    data['statusShow'] = this.statusShow;
    data['LoanStatus'] = this.loanStatus;
    data['remark'] = this.remark;
    data['empDetId'] = this.empDetId;
    data['branch'] = this.branch;
    data['orgId'] = this.orgId;
    data['approvedInstallment'] = this.approvedInstallment;
    data['empName'] = this.empName;
    data['requestedInstallment'] = this.requestedInstallment;
    data['approvedAmount'] = this.approvedAmount;
    data['raisedBy'] = this.raisedBy;
    data['loanAdvId'] = this.loanAdvId;
    data['dept'] = this.dept;
    data['loanReqId'] = this.loanReqId;
    data['loanAmount'] = this.loanAmount;
    data['plainingg1'] = this.plainingg1;
    data['plainingg2'] = this.plainingg2;
    data['plainingg3'] = this.plainingg3;
    data['empCode'] = this.empCode;
    data['plainingg4'] = this.plainingg4;
    data['plainingg5'] = this.plainingg5;
    data['doj'] = this.doj;
    data['status'] = this.status;
    return data;
  }
}

class LoanRequiDataforOthers {
  dynamic date;
  dynamic desig;
  dynamic loanType;
  dynamic statusShow;
  dynamic loanStatus;
  dynamic remark;
  dynamic empDetId;
  dynamic branch;
  dynamic orgId;
  dynamic approvedInstallment;
  dynamic empName;
  dynamic requestedInstallment;
  dynamic approvedAmount;
  dynamic raisedBy;
  dynamic loanAdvId;
  dynamic dept;
  dynamic loanReqId;
  dynamic loanAmount;
  dynamic plainingg1;
  dynamic plainingg2;
  dynamic plainingg3;
  dynamic empCode;
  dynamic plainingg4;
  dynamic plainingg5;
  dynamic doj;
  dynamic status;

  LoanRequiDataforOthers(
      {this.date,
        this.desig,
        this.loanType,
        this.statusShow,
        this.loanStatus,
        this.remark,
        this.empDetId,
        this.branch,
        this.orgId,
        this.approvedInstallment,
        this.empName,
        this.requestedInstallment,
        this.approvedAmount,
        this.raisedBy,
        this.loanAdvId,
        this.dept,
        this.loanReqId,
        this.loanAmount,
        this.plainingg1,
        this.plainingg2,
        this.plainingg3,
        this.empCode,
        this.plainingg4,
        this.plainingg5,
        this.doj,
        this.status});

  LoanRequiDataforOthers.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    desig = json['desig'];
    loanType = json['LoanType'];
    statusShow = json['statusShow'];
    loanStatus = json['LoanStatus'];
    remark = json['remark'];
    empDetId = json['empDetId'];
    branch = json['branch'];
    orgId = json['orgId'];
    approvedInstallment = json['approvedInstallment'];
    empName = json['empName'];
    requestedInstallment = json['requestedInstallment'];
    approvedAmount = json['approvedAmount'];
    raisedBy = json['raisedBy'];
    loanAdvId = json['loanAdvId'];
    dept = json['dept'];
    loanReqId = json['loanReqId'];
    loanAmount = json['loanAmount'];
    plainingg1 = json['plainingg1'];
    plainingg2 = json['plainingg2'];
    plainingg3 = json['plainingg3'];
    empCode = json['empCode'];
    plainingg4 = json['plainingg4'];
    plainingg5 = json['plainingg5'];
    doj = json['doj'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['date'] = this.date;
    data['desig'] = this.desig;
    data['LoanType'] = this.loanType;
    data['statusShow'] = this.statusShow;
    data['LoanStatus'] = this.loanStatus;
    data['remark'] = this.remark;
    data['empDetId'] = this.empDetId;
    data['branch'] = this.branch;
    data['orgId'] = this.orgId;
    data['approvedInstallment'] = this.approvedInstallment;
    data['empName'] = this.empName;
    data['requestedInstallment'] = this.requestedInstallment;
    data['approvedAmount'] = this.approvedAmount;
    data['raisedBy'] = this.raisedBy;
    data['loanAdvId'] = this.loanAdvId;
    data['dept'] = this.dept;
    data['loanReqId'] = this.loanReqId;
    data['loanAmount'] = this.loanAmount;
    data['plainingg1'] = this.plainingg1;
    data['plainingg2'] = this.plainingg2;
    data['plainingg3'] = this.plainingg3;
    data['empCode'] = this.empCode;
    data['plainingg4'] = this.plainingg4;
    data['plainingg5'] = this.plainingg5;
    data['doj'] = this.doj;
    data['status'] = this.status;
    return data;
  }
}

class LoanRequisitionPendinglist {
  dynamic date;
  dynamic desig;
  dynamic loanType;
  dynamic statusShow;
  dynamic loanStatus;
  dynamic remark;
  dynamic empDetId;
  dynamic branch;
  dynamic orgId;
  dynamic approvedInstallment;
  dynamic empName;
  dynamic requestedInstallment;
  dynamic approvedAmount;
  dynamic raisedBy;
  dynamic loanAdvId;
  dynamic dept;
  dynamic loanReqId;
  dynamic loanAmount;
  dynamic plainingg1;
  dynamic plainingg2;
  dynamic plainingg3;
  dynamic empCode;
  dynamic plainingg4;
  dynamic plainingg5;
  dynamic doj;
  dynamic status;

  LoanRequisitionPendinglist(
      {this.date,
        this.desig,
        this.loanType,
        this.statusShow,
        this.loanStatus,
        this.remark,
        this.empDetId,
        this.branch,
        this.orgId,
        this.approvedInstallment,
        this.empName,
        this.requestedInstallment,
        this.approvedAmount,
        this.raisedBy,
        this.loanAdvId,
        this.dept,
        this.loanReqId,
        this.loanAmount,
        this.plainingg1,
        this.plainingg2,
        this.plainingg3,
        this.empCode,
        this.plainingg4,
        this.plainingg5,
        this.doj,
        this.status});

  LoanRequisitionPendinglist.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    desig = json['desig'];
    loanType = json['LoanType'];
    statusShow = json['statusShow'];
    loanStatus = json['LoanStatus'];
    remark = json['remark'];
    empDetId = json['empDetId'];
    branch = json['branch'];
    orgId = json['orgId'];
    approvedInstallment = json['approvedInstallment'];
    empName = json['empName'];
    requestedInstallment = json['requestedInstallment'];
    approvedAmount = json['approvedAmount'];
    raisedBy = json['raisedBy'];
    loanAdvId = json['loanAdvId'];
    dept = json['dept'];
    loanReqId = json['loanReqId'];
    loanAmount = json['loanAmount'];
    plainingg1 = json['plainingg1'];
    plainingg2 = json['plainingg2'];
    plainingg3 = json['plainingg3'];
    empCode = json['empCode'];
    plainingg4 = json['plainingg4'];
    plainingg5 = json['plainingg5'];
    doj = json['doj'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['date'] = this.date;
    data['desig'] = this.desig;
    data['LoanType'] = this.loanType;
    data['statusShow'] = this.statusShow;
    data['LoanStatus'] = this.loanStatus;
    data['remark'] = this.remark;
    data['empDetId'] = this.empDetId;
    data['branch'] = this.branch;
    data['orgId'] = this.orgId;
    data['approvedInstallment'] = this.approvedInstallment;
    data['empName'] = this.empName;
    data['requestedInstallment'] = this.requestedInstallment;
    data['approvedAmount'] = this.approvedAmount;
    data['raisedBy'] = this.raisedBy;
    data['loanAdvId'] = this.loanAdvId;
    data['dept'] = this.dept;
    data['loanReqId'] = this.loanReqId;
    data['loanAmount'] = this.loanAmount;
    data['plainingg1'] = this.plainingg1;
    data['plainingg2'] = this.plainingg2;
    data['plainingg3'] = this.plainingg3;
    data['empCode'] = this.empCode;
    data['plainingg4'] = this.plainingg4;
    data['plainingg5'] = this.plainingg5;
    data['doj'] = this.doj;
    data['status'] = this.status;
    return data;
  }
}
