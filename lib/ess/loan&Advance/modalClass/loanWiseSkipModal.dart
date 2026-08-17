class LoanWiseSkipModal {
  List<Loandata>? loandata;

  LoanWiseSkipModal({this.loandata});

  LoanWiseSkipModal.fromJson(Map<String, dynamic> json) {
    if (json['loandata'] != null) {
      loandata = <Loandata>[];
      json['loandata'].forEach((v) {
        loandata!.add(Loandata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (loandata != null) {
      data['loandata'] = loandata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Loandata {
  dynamic actualPaidAmount;
  dynamic loanType;
  dynamic monthName;
  dynamic skipId;
  dynamic approvedBy;
  dynamic installmentMonth;
  dynamic creationDate;
  dynamic branch;
  dynamic ledgerId;
  dynamic skipStatus;
  dynamic monthlyActualAmt;
  dynamic skipEmiMonth;
  dynamic empCode;
  dynamic empName;
  dynamic userType;
  dynamic monthlyAmt;
  dynamic monthVal;
  dynamic doj;
  dynamic status;
  dynamic isLoanCheck;

  Loandata(
      {this.actualPaidAmount,
        this.loanType,
        this.monthName,
        this.skipId,
        this.approvedBy,
        this.installmentMonth,
        this.creationDate,
        this.branch,
        this.ledgerId,
        this.skipStatus,
        this.monthlyActualAmt,
        this.skipEmiMonth,
        this.empCode,
        this.empName,
        this.userType,
        this.monthlyAmt,
        this.monthVal,
        this.doj,
        this.status,
        this.isLoanCheck});

  Loandata.fromJson(Map<String, dynamic> json) {
    actualPaidAmount = json['actualPaidAmount'];
    loanType = json['loanType'];
    monthName = json['monthName'];
    skipId = json['skipId'];
    approvedBy = json['approvedBy'];
    installmentMonth = json['installmentMonth'];
    creationDate = json['creationDate'];
    branch = json['branch'];
    ledgerId = json['ledgerId'];
    skipStatus = json['skipStatus'];
    monthlyActualAmt = json['monthlyActualAmt'];
    skipEmiMonth = json['skipEmiMonth'];
    empCode = json['empCode'];
    empName = json['empName'];
    userType = json['userType'];
    monthlyAmt = json['monthlyAmt'];
    monthVal = json['monthVal'];
    doj = json['doj'];
    status = json['status'];
    isLoanCheck = json['isLoanCheck'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['actualPaidAmount'] = actualPaidAmount;
    data['loanType'] = loanType;
    data['monthName'] = monthName;
    data['skipId'] = skipId;
    data['approvedBy'] = approvedBy;
    data['installmentMonth'] = installmentMonth;
    data['creationDate'] = creationDate;
    data['branch'] = branch;
    data['ledgerId'] = ledgerId;
    data['skipStatus'] = skipStatus;
    data['monthlyActualAmt'] = monthlyActualAmt;
    data['skipEmiMonth'] = skipEmiMonth;
    data['empCode'] = empCode;
    data['empName'] = empName;
    data['userType'] = userType;
    data['monthlyAmt'] = monthlyAmt;
    data['monthVal'] = monthVal;
    data['doj'] = doj;
    data['status'] = status;
    data['isLoanCheck'] = isLoanCheck;
    return data;
  }
}
