class AddExpDropPolicyModal {
  List<ClaimDataList>? claimDataList;

  AddExpDropPolicyModal({this.claimDataList});

  AddExpDropPolicyModal.fromJson(Map<String, dynamic> json) {
    if (json['claimDataList'] != null) {
      claimDataList = <ClaimDataList>[];
      json['claimDataList'].forEach((v) {
        claimDataList!.add(ClaimDataList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (claimDataList != null) {
      data['claimDataList'] =
          claimDataList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClaimDataList {
  int? policyId;
  String? policyName;
  int? claimId;
  String? policyCode;

  ClaimDataList(
      {this.policyId, this.policyName, this.claimId, this.policyCode});

  ClaimDataList.fromJson(Map<String, dynamic> json) {
    policyId = json['policyId'];
    policyName = json['policyName'];
    claimId = json['claimId'];
    policyCode = json['policyCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['policyId'] = policyId;
    data['policyName'] = policyName;
    data['claimId'] = claimId;
    data['policyCode'] = policyCode;
    return data;
  }
}
