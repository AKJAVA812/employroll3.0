class LoanAdvanceReqModal {
  List<LoanRequiDatalist>? loanRequiDatalist;

  LoanAdvanceReqModal({this.loanRequiDatalist});

  LoanAdvanceReqModal.fromJson(Map<String, dynamic> json) {
    if (json['loanRequiDatalist'] != null) {
      loanRequiDatalist = <LoanRequiDatalist>[];
      json['loanRequiDatalist'].forEach((v) {
        loanRequiDatalist!.add(LoanRequiDatalist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (loanRequiDatalist != null) {
      data['loanRequiDatalist'] =
          loanRequiDatalist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LoanRequiDatalist {
  String? date;
  String? loanType;
  String? advanceActive;
  String? remark;
  String? loanAdId;
  String? empDetId;
  String? loanReqId;
  String? loanActive;
  String? loanAmount;
  String? empCode;
  String? empName;
  String? raisedBy;
  String? status;

  LoanRequiDatalist(
      {this.date,
        this.loanType,
        this.advanceActive,
        this.remark,
        this.loanAdId,
        this.empDetId,
        this.loanReqId,
        this.loanActive,
        this.loanAmount,
        this.empCode,
        this.empName,
        this.raisedBy,
        this.status});

  LoanRequiDatalist.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    loanType = json['loanType'];
    advanceActive = json['advanceActive'];
    remark = json['remark'];
    loanAdId = json['loanAdId'];
    empDetId = json['empDetId'];
    loanReqId = json['loanReqId'];
    loanActive = json['loanActive'];
    loanAmount = json['loanAmount'];
    empCode = json['empCode'];
    empName = json['empName'];
    raisedBy = json['raisedBy'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['loanType'] = loanType;
    data['advanceActive'] = advanceActive;
    data['remark'] = remark;
    data['loanAdId'] = loanAdId;
    data['empDetId'] = empDetId;
    data['loanReqId'] = loanReqId;
    data['loanActive'] = loanActive;
    data['loanAmount'] = loanAmount;
    data['empCode'] = empCode;
    data['empName'] = empName;
    data['raisedBy'] = raisedBy;
    data['status'] = status;
    return data;
  }
}
