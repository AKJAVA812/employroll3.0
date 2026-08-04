class LoanDataShowApprovalModal {
  List<DataNew>? data;

  LoanDataShowApprovalModal({this.data});

  LoanDataShowApprovalModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataNew>[];
      json['data'].forEach((v) {
        data!.add(DataNew.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataNew {
  dynamic date;
  dynamic desig;
  dynamic installmentlevelThree;
  dynamic loanType;
  dynamic approverLevelOneName;
  dynamic dedDateLevelThree;
  dynamic approverLevelTwoName;
  dynamic levelThreeAppAmt;
  dynamic interestBalance;
  dynamic installmentRequested;
  dynamic principalbalance;
  dynamic branch;
  dynamic deductFroDate;
  dynamic levelOneAppAmt;
  dynamic result;
  dynamic interestRateLevelOne;
  dynamic dedDateLevelTwo;
  dynamic empName;
  dynamic interestRateL1;
  dynamic interestBalanceL3;
  dynamic dept;
  dynamic loanAdId;
  dynamic interestBalanceL2;
  dynamic loanAmount;
  dynamic installmentlevelOne;
  dynamic loanAccountNo;
  dynamic deductFromDateL3;
  dynamic approverLevelThreeName;
  dynamic deductFromDateL2;
  dynamic onDate;
  dynamic empCode;
  dynamic installmentlevelTwo;
  dynamic interestRateL2;
  dynamic levelTwoAppAmt;
  dynamic interestRateL3;
  dynamic dedDate;
  dynamic status;

  DataNew(
      {this.date,
        this.desig,
        this.installmentlevelThree,
        this.loanType,
        this.approverLevelOneName,
        this.dedDateLevelThree,
        this.approverLevelTwoName,
        this.levelThreeAppAmt,
        this.interestBalance,
        this.installmentRequested,
        this.principalbalance,
        this.branch,
        this.deductFroDate,
        this.levelOneAppAmt,
        this.result,
        this.interestRateLevelOne,
        this.dedDateLevelTwo,
        this.empName,
        this.interestRateL1,
        this.interestBalanceL3,
        this.dept,
        this.loanAdId,
        this.interestBalanceL2,
        this.loanAmount,
        this.installmentlevelOne,
        this.loanAccountNo,
        this.deductFromDateL3,
        this.approverLevelThreeName,
        this.deductFromDateL2,
        this.onDate,
        this.empCode,
        this.installmentlevelTwo,
        this.interestRateL2,
        this.levelTwoAppAmt,
        this.interestRateL3,
        this.dedDate,
        this.status});

  DataNew.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    desig = json['desig'];
    installmentlevelThree = json['installmentlevelThree'];
    loanType = json['loanType'];
    approverLevelOneName = json['approverLevelOneName'];
    dedDateLevelThree = json['dedDateLevelThree'];
    approverLevelTwoName = json['approverLevelTwoName'];
    levelThreeAppAmt = json['levelThreeAppAmt'];
    interestBalance = json['interestBalance'];
    installmentRequested = json['installmentRequested'];
    principalbalance = json['principalbalance'];
    branch = json['branch'];
    deductFroDate = json['deductFroDate'];
    levelOneAppAmt = json['levelOneAppAmt'];
    result = json['result'];
    interestRateLevelOne = json['interestRateLevelOne'];
    dedDateLevelTwo = json['dedDateLevelTwo'];
    empName = json['empName'];
    interestRateL1 = json['interestRateL1'];
    interestBalanceL3 = json['interestBalanceL3'];
    dept = json['dept'];
    loanAdId = json['loanAdId'];
    interestBalanceL2 = json['interestBalanceL2'];
    loanAmount = json['loanAmount'];
    installmentlevelOne = json['installmentlevelOne'];
    loanAccountNo = json['loanAccountNo'];
    deductFromDateL3 = json['deductFromDateL3'];
    approverLevelThreeName = json['approverLevelThreeName'];
    deductFromDateL2 = json['deductFromDateL2'];
    onDate = json['onDate'];
    empCode = json['empCode'];
    installmentlevelTwo = json['installmentlevelTwo'];
    interestRateL2 = json['interestRateL2'];
    levelTwoAppAmt = json['levelTwoAppAmt'];
    interestRateL3 = json['interestRateL3'];
    dedDate = json['dedDate'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['date'] = this.date;
    data['desig'] = this.desig;
    data['installmentlevelThree'] = this.installmentlevelThree;
    data['loanType'] = this.loanType;
    data['approverLevelOneName'] = this.approverLevelOneName;
    data['dedDateLevelThree'] = this.dedDateLevelThree;
    data['approverLevelTwoName'] = this.approverLevelTwoName;
    data['levelThreeAppAmt'] = this.levelThreeAppAmt;
    data['interestBalance'] = this.interestBalance;
    data['installmentRequested'] = this.installmentRequested;
    data['principalbalance'] = this.principalbalance;
    data['branch'] = this.branch;
    data['deductFroDate'] = this.deductFroDate;
    data['levelOneAppAmt'] = this.levelOneAppAmt;
    data['result'] = this.result;
    data['interestRateLevelOne'] = this.interestRateLevelOne;
    data['dedDateLevelTwo'] = this.dedDateLevelTwo;
    data['empName'] = this.empName;
    data['interestRateL1'] = this.interestRateL1;
    data['interestBalanceL3'] = this.interestBalanceL3;
    data['dept'] = this.dept;
    data['loanAdId'] = this.loanAdId;
    data['interestBalanceL2'] = this.interestBalanceL2;
    data['loanAmount'] = this.loanAmount;
    data['installmentlevelOne'] = this.installmentlevelOne;
    data['loanAccountNo'] = this.loanAccountNo;
    data['deductFromDateL3'] = this.deductFromDateL3;
    data['approverLevelThreeName'] = this.approverLevelThreeName;
    data['deductFromDateL2'] = this.deductFromDateL2;
    data['onDate'] = this.onDate;
    data['empCode'] = this.empCode;
    data['installmentlevelTwo'] = this.installmentlevelTwo;
    data['interestRateL2'] = this.interestRateL2;
    data['levelTwoAppAmt'] = this.levelTwoAppAmt;
    data['interestRateL3'] = this.interestRateL3;
    data['dedDate'] = this.dedDate;
    data['status'] = this.status;
    return data;
  }
}
