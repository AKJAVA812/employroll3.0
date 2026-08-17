class LoanApprovedReqModal {
  List<LoanAppReqDatalist>? loanAppReqDatalist;

  LoanApprovedReqModal({this.loanAppReqDatalist});

  LoanApprovedReqModal.fromJson(Map<String, dynamic> json) {
    if (json['loanAppReqDatalist'] != null) {
      loanAppReqDatalist = <LoanAppReqDatalist>[];
      json['loanAppReqDatalist'].forEach((v) {
        loanAppReqDatalist!.add(LoanAppReqDatalist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (loanAppReqDatalist != null) {
      data['loanAppReqDatalist'] =
          loanAppReqDatalist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LoanAppReqDatalist {
  String? requestedAmt;
  String? loanType;
  double? loanAppAmt;
  String? approvedBy;
  String? branchName;
  String? remark;
  String? loanReqId;
  String? designName;
  String? loanAppDetId;
  String? empCode;
  String? loanRaiseDate;
  String? empName;
  String? depttName;
  String? status;

  LoanAppReqDatalist(
      {this.requestedAmt,
        this.loanType,
        this.loanAppAmt,
        this.approvedBy,
        this.branchName,
        this.remark,
        this.loanReqId,
        this.designName,
        this.loanAppDetId,
        this.empCode,
        this.loanRaiseDate,
        this.empName,
        this.depttName,
        this.status});

  LoanAppReqDatalist.fromJson(Map<String, dynamic> json) {
    requestedAmt = json['requestedAmt'];
    loanType = json['loanType'];
    loanAppAmt = json['loanAppAmt'];
    approvedBy = json['approvedBy'];
    branchName = json['branchName'];
    remark = json['remark'];
    loanReqId = json['loanReqId'];
    designName = json['designName'];
    loanAppDetId = json['loanAppDetId'];
    empCode = json['empCode'];
    loanRaiseDate = json['loanRaiseDate'];
    empName = json['empName'];
    depttName = json['depttName'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requestedAmt'] = requestedAmt;
    data['loanType'] = loanType;
    data['loanAppAmt'] = loanAppAmt;
    data['approvedBy'] = approvedBy;
    data['branchName'] = branchName;
    data['remark'] = remark;
    data['loanReqId'] = loanReqId;
    data['designName'] = designName;
    data['loanAppDetId'] = loanAppDetId;
    data['empCode'] = empCode;
    data['loanRaiseDate'] = loanRaiseDate;
    data['empName'] = empName;
    data['depttName'] = depttName;
    data['status'] = status;
    return data;
  }
}
