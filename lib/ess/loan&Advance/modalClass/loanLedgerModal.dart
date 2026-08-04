class LoanLedgerModal {
  dynamic netDebitBal;
  dynamic period;
  List<EmpList>? empList;
  dynamic openingCreditBal;
  dynamic empCode;
  dynamic empName;
  dynamic netCreditBal;
  dynamic openingDebitBal;
  dynamic currentCreditBal;
  dynamic currentDebitBal;

  LoanLedgerModal(
      {this.netDebitBal,
        this.period,
        this.empList,
        this.openingCreditBal,
        this.empCode,
        this.empName,
        this.netCreditBal,
        this.openingDebitBal,
        this.currentCreditBal,
        this.currentDebitBal});

  LoanLedgerModal.fromJson(Map<String, dynamic> json) {
    netDebitBal = json['netDebitBal'];
    period = json['period'];
    if (json['empList'] != null) {
      empList = <EmpList>[];
      json['empList'].forEach((v) {
        empList!.add(EmpList.fromJson(v));
      });
    }
    openingCreditBal = json['openingCreditBal'];
    empCode = json['empCode'];
    empName = json['empName'];
    netCreditBal = json['netCreditBal'];
    openingDebitBal = json['openingDebitBal'];
    currentCreditBal = json['currentCreditBal'];
    currentDebitBal = json['currentDebitBal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['netDebitBal'] = this.netDebitBal;
    data['period'] = this.period;
    if (this.empList != null) {
      data['empList'] = this.empList!.map((v) => v.toJson()).toList();
    }
    data['openingCreditBal'] = this.openingCreditBal;
    data['empCode'] = this.empCode;
    data['empName'] = this.empName;
    data['netCreditBal'] = this.netCreditBal;
    data['openingDebitBal'] = this.openingDebitBal;
    data['currentCreditBal'] = this.currentCreditBal;
    data['currentDebitBal'] = this.currentDebitBal;
    return data;
  }
}

class EmpList {
  dynamic date;
  dynamic eventDesc;
  dynamic month;
  dynamic leaveType;
  dynamic loanType;
  dynamic debitValue;
  dynamic eventName;
  dynamic time;
  dynamic eventType;
  dynamic countType;
  dynamic creationDate;
  dynamic creditValue;

  EmpList(
      {this.date,
        this.eventDesc,
        this.month,
        this.leaveType,
        this.loanType,
        this.debitValue,
        this.eventName,
        this.time,
        this.eventType,
        this.countType,
        this.creationDate,
        this.creditValue});

  EmpList.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    eventDesc = json['eventDesc'];
    month = json['month'];
    leaveType = json['leaveType'];
    loanType = json['loanType'];
    debitValue = json['debitValue'];
    eventName = json['eventName'];
    time = json['time'];
    eventType = json['eventType'];
    countType = json['countType'];
    creationDate = json['creationDate'];
    creditValue = json['creditValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['date'] = this.date;
    data['eventDesc'] = this.eventDesc;
    data['month'] = this.month;
    data['leaveType'] = this.leaveType;
    data['loanType'] = this.loanType;
    data['debitValue'] = this.debitValue;
    data['eventName'] = this.eventName;
    data['time'] = this.time;
    data['eventType'] = this.eventType;
    data['countType'] = this.countType;
    data['creationDate'] = this.creationDate;
    data['creditValue'] = this.creditValue;
    return data;
  }
}
