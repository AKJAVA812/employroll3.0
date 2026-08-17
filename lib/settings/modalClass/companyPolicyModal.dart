class CompanyPolicyModal {
  List<PayrollPolicyList>? payrollPolicyList;
  List<TimeAttPolicyList>? timeAttPolicyList;
  List<LeavePolicyList>? leavePolicyList;
  List<AllPolicyList>? allPolicyList;
  List<OrgPolicyList>? orgPolicyList;
  List<ClaimsPolicyList>? claimsPolicyList;

  CompanyPolicyModal(
      {this.payrollPolicyList,
        this.timeAttPolicyList,
        this.leavePolicyList,
        this.allPolicyList,
        this.orgPolicyList,
        this.claimsPolicyList});

  CompanyPolicyModal.fromJson(Map<String, dynamic> json) {
    if (json['payrollPolicyList'] != null) {
      payrollPolicyList = <PayrollPolicyList>[];
      json['payrollPolicyList'].forEach((v) {
        payrollPolicyList!.add(PayrollPolicyList.fromJson(v));
      });
    }
    if (json['timeAttPolicyList'] != null) {
      timeAttPolicyList = <TimeAttPolicyList>[];
      json['timeAttPolicyList'].forEach((v) {
        timeAttPolicyList!.add(TimeAttPolicyList.fromJson(v));
      });
    }
    if (json['leavePolicyList'] != null) {
      leavePolicyList = <LeavePolicyList>[];
      json['leavePolicyList'].forEach((v) {
        leavePolicyList!.add(LeavePolicyList.fromJson(v));
      });
    }
    if (json['allPolicyList'] != null) {
      allPolicyList = <AllPolicyList>[];
      json['allPolicyList'].forEach((v) {
        allPolicyList!.add(AllPolicyList.fromJson(v));
      });
    }
    if (json['orgPolicyList'] != null) {
      orgPolicyList = <OrgPolicyList>[];
      json['orgPolicyList'].forEach((v) {
        orgPolicyList!.add(OrgPolicyList.fromJson(v));
      });
    }
    if (json['claimsPolicyList'] != null) {
      claimsPolicyList = <ClaimsPolicyList>[];
      json['claimsPolicyList'].forEach((v) {
        claimsPolicyList!.add(ClaimsPolicyList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (payrollPolicyList != null) {
      data['payrollPolicyList'] =
          payrollPolicyList!.map((v) => v.toJson()).toList();
    }
    if (timeAttPolicyList != null) {
      data['timeAttPolicyList'] =
          timeAttPolicyList!.map((v) => v.toJson()).toList();
    }
    if (leavePolicyList != null) {
      data['leavePolicyList'] =
          leavePolicyList!.map((v) => v.toJson()).toList();
    }
    if (allPolicyList != null) {
      data['allPolicyList'] =
          allPolicyList!.map((v) => v.toJson()).toList();
    }
    if (orgPolicyList != null) {
      data['orgPolicyList'] =
          orgPolicyList!.map((v) => v.toJson()).toList();
    }
    if (claimsPolicyList != null) {
      data['claimsPolicyList'] =
          claimsPolicyList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PayrollPolicyList {
  dynamic uploadedFileName;
  dynamic policyName;
  dynamic policytype;
  dynamic description;
  dynamic id;
  dynamic docPath;

  PayrollPolicyList(
      {this.uploadedFileName,
        this.policyName,
        this.policytype,
        this.description,
        this.id,
        this.docPath});

  PayrollPolicyList.fromJson(Map<String, dynamic> json) {
    uploadedFileName = json['uploadedFileName'];
    policyName = json['policyName'];
    policytype = json['policytype'];
    description = json['description'];
    id = json['id'];
    docPath = json['docPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uploadedFileName'] = uploadedFileName;
    data['policyName'] = policyName;
    data['policytype'] = policytype;
    data['description'] = description;
    data['id'] = id;
    data['docPath'] = docPath;
    return data;
  }
}

class TimeAttPolicyList {
  dynamic uploadedFileName;
  dynamic policyName;
  dynamic policytype;
  dynamic description;
  dynamic id;
  dynamic docPath;

  TimeAttPolicyList(
      {this.uploadedFileName,
        this.policyName,
        this.policytype,
        this.description,
        this.id,
        this.docPath});

  TimeAttPolicyList.fromJson(Map<String, dynamic> json) {
    uploadedFileName = json['uploadedFileName'];
    policyName = json['policyName'];
    policytype = json['policytype'];
    description = json['description'];
    id = json['id'];
    docPath = json['docPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uploadedFileName'] = uploadedFileName;
    data['policyName'] = policyName;
    data['policytype'] = policytype;
    data['description'] = description;
    data['id'] = id;
    data['docPath'] = docPath;
    return data;
  }
}

class LeavePolicyList {
  dynamic uploadedFileName;
  dynamic policyName;
  dynamic policytype;
  dynamic description;
  dynamic id;
  dynamic docPath;

  LeavePolicyList(
      {this.uploadedFileName,
        this.policyName,
        this.policytype,
        this.description,
        this.id,
        this.docPath});

  LeavePolicyList.fromJson(Map<String, dynamic> json) {
    uploadedFileName = json['uploadedFileName'];
    policyName = json['policyName'];
    policytype = json['policytype'];
    description = json['description'];
    id = json['id'];
    docPath = json['docPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uploadedFileName'] = uploadedFileName;
    data['policyName'] = policyName;
    data['policytype'] = policytype;
    data['description'] = description;
    data['id'] = id;
    data['docPath'] = docPath;
    return data;
  }
}

class AllPolicyList {
  dynamic uploadedFileName;
  dynamic policyName;
  dynamic policytype;
  dynamic description;
  dynamic id;
  dynamic docPath;

  AllPolicyList(
      {this.uploadedFileName,
        this.policyName,
        this.policytype,
        this.description,
        this.id,
        this.docPath});

  AllPolicyList.fromJson(Map<String, dynamic> json) {
    uploadedFileName = json['uploadedFileName'];
    policyName = json['policyName'];
    policytype = json['policytype'];
    description = json['description'];
    id = json['id'];
    docPath = json['docPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uploadedFileName'] = uploadedFileName;
    data['policyName'] = policyName;
    data['policytype'] = policytype;
    data['description'] = description;
    data['id'] = id;
    data['docPath'] = docPath;
    return data;
  }
}

class OrgPolicyList {
  dynamic uploadedFileName;
  dynamic policyName;
  dynamic policytype;
  dynamic description;
  dynamic id;
  dynamic docPath;

  OrgPolicyList(
      {this.uploadedFileName,
        this.policyName,
        this.policytype,
        this.description,
        this.id,
        this.docPath});

  OrgPolicyList.fromJson(Map<String, dynamic> json) {
    uploadedFileName = json['uploadedFileName'];
    policyName = json['policyName'];
    policytype = json['policytype'];
    description = json['description'];
    id = json['id'];
    docPath = json['docPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uploadedFileName'] = uploadedFileName;
    data['policyName'] = policyName;
    data['policytype'] = policytype;
    data['description'] = description;
    data['id'] = id;
    data['docPath'] = docPath;
    return data;
  }
}

class ClaimsPolicyList {
  dynamic uploadedFileName;
  dynamic policyName;
  dynamic policytype;
  dynamic description;
  dynamic id;
  dynamic docPath;

  ClaimsPolicyList(
      {this.uploadedFileName,
        this.policyName,
        this.policytype,
        this.description,
        this.id,
        this.docPath});

  ClaimsPolicyList.fromJson(Map<String, dynamic> json) {
    uploadedFileName = json['uploadedFileName'];
    policyName = json['policyName'];
    policytype = json['policytype'];
    description = json['description'];
    id = json['id'];
    docPath = json['docPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uploadedFileName'] = uploadedFileName;
    data['policyName'] = policyName;
    data['policytype'] = policytype;
    data['description'] = description;
    data['id'] = id;
    data['docPath'] = docPath;
    return data;
  }
}
