class MSSLoanListModal {
  dynamic approvedValue;
  List<LoanRequiDataforOthers>? loanRequiDataforOthers;
  dynamic disApprovedValue;
  dynamic pendingAmount;

  MSSLoanListModal(
      {this.approvedValue,
        this.loanRequiDataforOthers,
        this.disApprovedValue,
        this.pendingAmount});

  MSSLoanListModal.fromJson(Map<String, dynamic> json) {
    approvedValue = json['approvedValue'];
    if (json['loanRequiDataforOthers'] != null) {
      loanRequiDataforOthers = <LoanRequiDataforOthers>[];
      json['loanRequiDataforOthers'].forEach((v) {
        loanRequiDataforOthers!.add(LoanRequiDataforOthers.fromJson(v));
      });
    }
    disApprovedValue = json['disApprovedValue'];
    pendingAmount = json['pendingAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['approvedValue'] = approvedValue;
    if (loanRequiDataforOthers != null) {
      data['loanRequiDataforOthers'] =
          loanRequiDataforOthers!.map((v) => v.toJson()).toList();
    }
    data['disApprovedValue'] = disApprovedValue;
    data['pendingAmount'] = pendingAmount;
    return data;
  }
}

class LoanRequiDataforOthers {
  dynamic date;
  dynamic desig;
  dynamic transferStatus;
  dynamic loanType;
  dynamic statusShow;
  dynamic remark;
  dynamic empDetId;
  dynamic branch;
  dynamic orgId;
  dynamic empName;
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
  dynamic installment;
  dynamic doj;
  dynamic status;

  LoanRequiDataforOthers(
      {this.date,
        this.desig,
        this.transferStatus,
        this.loanType,
        this.statusShow,
        this.remark,
        this.empDetId,
        this.branch,
        this.orgId,
        this.empName,
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
        this.installment,
        this.doj,
        this.status});

  LoanRequiDataforOthers.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    desig = json['desig'];
    transferStatus = json['transferStatus'];
    loanType = json['loanType'];
    statusShow = json['statusShow'];
    remark = json['remark'];
    empDetId = json['empDetId'];
    branch = json['branch'];
    orgId = json['orgId'];
    empName = json['empName'];
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
    installment = json['installment'];
    doj = json['doj'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['desig'] = desig;
    data['transferStatus'] = transferStatus;
    data['loanType'] = loanType;
    data['statusShow'] = statusShow;
    data['remark'] = remark;
    data['empDetId'] = empDetId;
    data['branch'] = branch;
    data['orgId'] = orgId;
    data['empName'] = empName;
    data['approvedAmount'] = approvedAmount;
    data['raisedBy'] = raisedBy;
    data['loanAdvId'] = loanAdvId;
    data['dept'] = dept;
    data['loanReqId'] = loanReqId;
    data['loanAmount'] = loanAmount;
    data['plainingg1'] = plainingg1;
    data['plainingg2'] = plainingg2;
    data['plainingg3'] = plainingg3;
    data['empCode'] = empCode;
    data['plainingg4'] = plainingg4;
    data['plainingg5'] = plainingg5;
    data['installment'] = installment;
    data['doj'] = doj;
    data['status'] = status;
    return data;
  }
}
