class LoanSummaryModal {
  List<LoanSummary>? loanSummary;
  dynamic pendingValue;

  LoanSummaryModal({this.loanSummary, this.pendingValue});

  LoanSummaryModal.fromJson(Map<String, dynamic> json) {
    if (json['loanSummary'] != null) {
      loanSummary = <LoanSummary>[];
      json['loanSummary'].forEach((v) {
        loanSummary!.add(new LoanSummary.fromJson(v));
      });
    }
    pendingValue = json['pendingValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.loanSummary != null) {
      data['loanSummary'] = this.loanSummary!.map((v) => v.toJson()).toList();
    }
    data['pendingValue'] = this.pendingValue;
    return data;
  }
}

class LoanSummary {
  dynamic date;
  dynamic desig;
  dynamic loanType;
  dynamic installmentAmount;
  dynamic loanAppliedFor;
  dynamic remark;
  dynamic empDetId;
  dynamic branch;
  dynamic orgId;
  dynamic totalEmiPaid;
  dynamic empName;
  dynamic approvedAmount;
  dynamic pendingEmiCount;
  dynamic totalPendingAmt;
  dynamic raisedBy;
  dynamic loanPaidUp;
  dynamic loanAdvId;
  dynamic dept;
  dynamic loanReqId;
  dynamic loanAmount;
  dynamic empCode;
  dynamic doj;
  dynamic paidEmiCount;
  dynamic status;
  dynamic pendingInstallments;

  LoanSummary(
      {this.date,
        this.desig,
        this.loanType,
        this.installmentAmount,
        this.loanAppliedFor,
        this.remark,
        this.empDetId,
        this.branch,
        this.orgId,
        this.totalEmiPaid,
        this.empName,
        this.approvedAmount,
        this.pendingEmiCount,
        this.totalPendingAmt,
        this.raisedBy,
        this.loanPaidUp,
        this.loanAdvId,
        this.dept,
        this.loanReqId,
        this.loanAmount,
        this.empCode,
        this.doj,
        this.paidEmiCount,
        this.status,
        this.pendingInstallments});

  LoanSummary.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    desig = json['desig'];
    loanType = json['loanType'];
    installmentAmount = json['installmentAmount'];
    loanAppliedFor = json['loanAppliedFor'];
    remark = json['remark'];
    empDetId = json['empDetId'];
    branch = json['branch'];
    orgId = json['orgId'];
    totalEmiPaid = json['totalEmiPaid'];
    empName = json['empName'];
    approvedAmount = json['approvedAmount'];
    pendingEmiCount = json['pendingEmiCount'];
    totalPendingAmt = json['totalPendingAmt'];
    raisedBy = json['raisedBy'];
    loanPaidUp = json['loanPaidUp'];
    loanAdvId = json['loanAdvId'];
    dept = json['dept'];
    loanReqId = json['loanReqId'];
    loanAmount = json['loanAmount'];
    empCode = json['empCode'];
    doj = json['doj'];
    paidEmiCount = json['paidEmiCount'];
    status = json['status'];
    pendingInstallments = json['pendingInstallments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['desig'] = this.desig;
    data['loanType'] = this.loanType;
    data['installmentAmount'] = this.installmentAmount;
    data['loanAppliedFor'] = this.loanAppliedFor;
    data['remark'] = this.remark;
    data['empDetId'] = this.empDetId;
    data['branch'] = this.branch;
    data['orgId'] = this.orgId;
    data['totalEmiPaid'] = this.totalEmiPaid;
    data['empName'] = this.empName;
    data['approvedAmount'] = this.approvedAmount;
    data['pendingEmiCount'] = this.pendingEmiCount;
    data['totalPendingAmt'] = this.totalPendingAmt;
    data['raisedBy'] = this.raisedBy;
    data['loanPaidUp'] = this.loanPaidUp;
    data['loanAdvId'] = this.loanAdvId;
    data['dept'] = this.dept;
    data['loanReqId'] = this.loanReqId;
    data['loanAmount'] = this.loanAmount;
    data['empCode'] = this.empCode;
    data['doj'] = this.doj;
    data['paidEmiCount'] = this.paidEmiCount;
    data['status'] = this.status;
    data['pendingInstallments'] = this.pendingInstallments;
    return data;
  }
}
