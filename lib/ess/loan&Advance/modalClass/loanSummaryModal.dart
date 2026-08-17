class LoanSummaryModal {
  List<LoanSummary>? loanSummary;
  dynamic pendingValue;

  LoanSummaryModal({this.loanSummary, this.pendingValue});

  LoanSummaryModal.fromJson(Map<String, dynamic> json) {
    if (json['loanSummary'] != null) {
      loanSummary = <LoanSummary>[];
      json['loanSummary'].forEach((v) {
        loanSummary!.add(LoanSummary.fromJson(v));
      });
    }
    pendingValue = json['pendingValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (loanSummary != null) {
      data['loanSummary'] = loanSummary!.map((v) => v.toJson()).toList();
    }
    data['pendingValue'] = pendingValue;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['desig'] = desig;
    data['loanType'] = loanType;
    data['installmentAmount'] = installmentAmount;
    data['loanAppliedFor'] = loanAppliedFor;
    data['remark'] = remark;
    data['empDetId'] = empDetId;
    data['branch'] = branch;
    data['orgId'] = orgId;
    data['totalEmiPaid'] = totalEmiPaid;
    data['empName'] = empName;
    data['approvedAmount'] = approvedAmount;
    data['pendingEmiCount'] = pendingEmiCount;
    data['totalPendingAmt'] = totalPendingAmt;
    data['raisedBy'] = raisedBy;
    data['loanPaidUp'] = loanPaidUp;
    data['loanAdvId'] = loanAdvId;
    data['dept'] = dept;
    data['loanReqId'] = loanReqId;
    data['loanAmount'] = loanAmount;
    data['empCode'] = empCode;
    data['doj'] = doj;
    data['paidEmiCount'] = paidEmiCount;
    data['status'] = status;
    data['pendingInstallments'] = pendingInstallments;
    return data;
  }
}
