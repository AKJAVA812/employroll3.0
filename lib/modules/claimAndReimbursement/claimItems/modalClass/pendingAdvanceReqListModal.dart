class PendingAdvReqListModal {
  List<ClaimAdvDatalist>? claimAdvDatalist;

  PendingAdvReqListModal({this.claimAdvDatalist});

  PendingAdvReqListModal.fromJson(Map<String, dynamic> json) {
    if (json['claimAdvDatalist'] != null) {
      claimAdvDatalist = <ClaimAdvDatalist>[];
      json['claimAdvDatalist'].forEach((v) {
        claimAdvDatalist!.add(new ClaimAdvDatalist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.claimAdvDatalist != null) {
      data['claimAdvDatalist'] =
          this.claimAdvDatalist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClaimAdvDatalist {
  String? date;
  String? empId;
  String? purpose;
  String? remark;
  String? advanceAmt;
  String? claimId;
  String? branch;
  String? placeTour;
  String? approvedStatus;
  String? approvedRemark;
  String? empName;
  String? design;
  String? approvedAmount;
  String? ndays;

  ClaimAdvDatalist(
      {this.date,
        this.empId,
        this.purpose,
        this.remark,
        this.advanceAmt,
        this.claimId,
        this.branch,
        this.placeTour,
        this.approvedStatus,
        this.approvedRemark,
        this.empName,
        this.design,
        this.approvedAmount,
        this.ndays});

  ClaimAdvDatalist.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    empId = json['empId'];
    purpose = json['purpose'];
    remark = json['remark'];
    advanceAmt = json['advanceAmt'];
    claimId = json['claimId'];
    branch = json['branch'];
    placeTour = json['placeTour'];
    approvedStatus = json['approvedStatus'];
    approvedRemark = json['approvedRemark'];
    empName = json['empName'];
    design = json['design'];
    approvedAmount = json['approvedAmount'];
    ndays = json['Ndays'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['empId'] = this.empId;
    data['purpose'] = this.purpose;
    data['remark'] = this.remark;
    data['advanceAmt'] = this.advanceAmt;
    data['claimId'] = this.claimId;
    data['branch'] = this.branch;
    data['placeTour'] = this.placeTour;
    data['approvedStatus'] = this.approvedStatus;
    data['approvedRemark'] = this.approvedRemark;
    data['empName'] = this.empName;
    data['design'] = this.design;
    data['approvedAmount'] = this.approvedAmount;
    data['Ndays'] = this.ndays;
    return data;
  }
}
