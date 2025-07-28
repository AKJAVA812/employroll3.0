class MSSLoanListModal {
  List<LoanRequiDataforOthers>? loanRequiDataforOthers;

  MSSLoanListModal({this.loanRequiDataforOthers});

  MSSLoanListModal.fromJson(Map<String, dynamic> json) {
    if (json['loanRequiDataforOthers'] != null) {
      loanRequiDataforOthers = <LoanRequiDataforOthers>[];
      json['loanRequiDataforOthers'].forEach((v) {
        loanRequiDataforOthers!.add(new LoanRequiDataforOthers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.loanRequiDataforOthers != null) {
      data['loanRequiDataforOthers'] =
          this.loanRequiDataforOthers!.map((v) => v.toJson()).toList();
    }
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['desig'] = this.desig;
    data['transferStatus'] = this.transferStatus;
    data['loanType'] = this.loanType;
    data['statusShow'] = this.statusShow;
    data['remark'] = this.remark;
    data['empDetId'] = this.empDetId;
    data['branch'] = this.branch;
    data['orgId'] = this.orgId;
    data['empName'] = this.empName;
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
    data['installment'] = this.installment;
    data['doj'] = this.doj;
    data['status'] = this.status;
    return data;
  }
}
