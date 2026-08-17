class PendingAdvReqListModal {
  List<ClaimAdvDatalist>? claimAdvDatalist;

  PendingAdvReqListModal({this.claimAdvDatalist});

  PendingAdvReqListModal.fromJson(Map<String, dynamic> json) {
    if (json['claimAdvDatalist'] != null) {
      claimAdvDatalist = <ClaimAdvDatalist>[];
      json['claimAdvDatalist'].forEach((v) {
        claimAdvDatalist!.add(ClaimAdvDatalist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (claimAdvDatalist != null) {
      data['claimAdvDatalist'] =
          claimAdvDatalist!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['empId'] = empId;
    data['purpose'] = purpose;
    data['remark'] = remark;
    data['advanceAmt'] = advanceAmt;
    data['claimId'] = claimId;
    data['branch'] = branch;
    data['placeTour'] = placeTour;
    data['approvedStatus'] = approvedStatus;
    data['approvedRemark'] = approvedRemark;
    data['empName'] = empName;
    data['design'] = design;
    data['approvedAmount'] = approvedAmount;
    data['Ndays'] = ndays;
    return data;
  }
}
