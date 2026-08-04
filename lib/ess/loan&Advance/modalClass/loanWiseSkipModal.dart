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
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.loandata != null) {
      data['loandata'] = this.loandata!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['actualPaidAmount'] = this.actualPaidAmount;
    data['loanType'] = this.loanType;
    data['monthName'] = this.monthName;
    data['skipId'] = this.skipId;
    data['approvedBy'] = this.approvedBy;
    data['installmentMonth'] = this.installmentMonth;
    data['creationDate'] = this.creationDate;
    data['branch'] = this.branch;
    data['ledgerId'] = this.ledgerId;
    data['skipStatus'] = this.skipStatus;
    data['monthlyActualAmt'] = this.monthlyActualAmt;
    data['skipEmiMonth'] = this.skipEmiMonth;
    data['empCode'] = this.empCode;
    data['empName'] = this.empName;
    data['userType'] = this.userType;
    data['monthlyAmt'] = this.monthlyAmt;
    data['monthVal'] = this.monthVal;
    data['doj'] = this.doj;
    data['status'] = this.status;
    data['isLoanCheck'] = this.isLoanCheck;
    return data;
  }
}
