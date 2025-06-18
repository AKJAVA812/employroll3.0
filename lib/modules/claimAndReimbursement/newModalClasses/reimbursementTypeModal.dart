class ReimbursementTypeListModal {
  List<ClaimDataList>? claimDataList;

  ReimbursementTypeListModal({this.claimDataList});

  ReimbursementTypeListModal.fromJson(Map<String, dynamic> json) {
    if (json['claimDataList'] != null) {
      claimDataList = <ClaimDataList>[];
      json['claimDataList'].forEach((v) {
        claimDataList!.add(new ClaimDataList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.claimDataList != null) {
      data['claimDataList'] =
          this.claimDataList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClaimDataList {
  int? policyId;
  String? policyName;
  int? claimId;
  String? policyCode;
  var reimbId;

  ClaimDataList(
      {this.policyId,
        this.policyName,
        this.claimId,
        this.policyCode,
        this.reimbId});

  ClaimDataList.fromJson(Map<String, dynamic> json) {
    policyId = json['policyId'];
    policyName = json['policyName'];
    claimId = json['claimId'];
    policyCode = json['policyCode'];
    reimbId = json['reimbId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['policyId'] = this.policyId;
    data['policyName'] = this.policyName;
    data['claimId'] = this.claimId;
    data['policyCode'] = this.policyCode;
    data['reimbId'] = this.reimbId;
    return data;
  }
}
