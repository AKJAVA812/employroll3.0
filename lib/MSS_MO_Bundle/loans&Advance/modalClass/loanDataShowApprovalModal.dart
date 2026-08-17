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
    final Map<String, dynamic> data = <String, dynamic>{};
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['desig'] = desig;
    data['installmentlevelThree'] = installmentlevelThree;
    data['loanType'] = loanType;
    data['approverLevelOneName'] = approverLevelOneName;
    data['dedDateLevelThree'] = dedDateLevelThree;
    data['approverLevelTwoName'] = approverLevelTwoName;
    data['levelThreeAppAmt'] = levelThreeAppAmt;
    data['interestBalance'] = interestBalance;
    data['installmentRequested'] = installmentRequested;
    data['principalbalance'] = principalbalance;
    data['branch'] = branch;
    data['deductFroDate'] = deductFroDate;
    data['levelOneAppAmt'] = levelOneAppAmt;
    data['result'] = result;
    data['interestRateLevelOne'] = interestRateLevelOne;
    data['dedDateLevelTwo'] = dedDateLevelTwo;
    data['empName'] = empName;
    data['interestRateL1'] = interestRateL1;
    data['interestBalanceL3'] = interestBalanceL3;
    data['dept'] = dept;
    data['loanAdId'] = loanAdId;
    data['interestBalanceL2'] = interestBalanceL2;
    data['loanAmount'] = loanAmount;
    data['installmentlevelOne'] = installmentlevelOne;
    data['loanAccountNo'] = loanAccountNo;
    data['deductFromDateL3'] = deductFromDateL3;
    data['approverLevelThreeName'] = approverLevelThreeName;
    data['deductFromDateL2'] = deductFromDateL2;
    data['onDate'] = onDate;
    data['empCode'] = empCode;
    data['installmentlevelTwo'] = installmentlevelTwo;
    data['interestRateL2'] = interestRateL2;
    data['levelTwoAppAmt'] = levelTwoAppAmt;
    data['interestRateL3'] = interestRateL3;
    data['dedDate'] = dedDate;
    data['status'] = status;
    return data;
  }
}
