class ClaimRequisitionModal {
  dynamic totaDraftAmount;
  dynamic approvedValue;
  List<ClaimRequisitionPendinglist>? claimRequisitionPendinglist;
  List<ClaimRequisitionApprovedlist>? claimRequisitionApprovedlist;
  List<DataNew>? data;
  dynamic submittedValue;
  dynamic disApprovedValue;
  List<ClaimRequisitionDisapprovelist>? claimRequisitionDisapprovelist;
  List<ClaimRequisitionDraftlist>? claimRequisitionDraftlist;
  dynamic pendingAmount;

  ClaimRequisitionModal(
      {this.totaDraftAmount,
        this.approvedValue,
        this.claimRequisitionPendinglist,
        this.claimRequisitionApprovedlist,
        this.data,
        this.submittedValue,
        this.disApprovedValue,
        this.claimRequisitionDisapprovelist,
        this.claimRequisitionDraftlist,
        this.pendingAmount});

  ClaimRequisitionModal.fromJson(Map<String, dynamic> json) {
    totaDraftAmount = json['totaDraftAmount'];
    approvedValue = json['approvedValue'];
    if (json['claimRequisitionPendinglist'] != null) {
      claimRequisitionPendinglist = <ClaimRequisitionPendinglist>[];
      json['claimRequisitionPendinglist'].forEach((v) {
        claimRequisitionPendinglist!
            .add(new ClaimRequisitionPendinglist.fromJson(v));
      });
    }
    if (json['claimRequisitionApprovedlist'] != null) {
      claimRequisitionApprovedlist = <ClaimRequisitionApprovedlist>[];
      json['claimRequisitionApprovedlist'].forEach((v) {
        claimRequisitionApprovedlist!
            .add(new ClaimRequisitionApprovedlist.fromJson(v));
      });
    }
    if (json['data'] != null) {
      data = <DataNew>[];
      json['data'].forEach((v) {
        data!.add(new DataNew.fromJson(v));
      });
    }
    submittedValue = json['submittedValue'];
    disApprovedValue = json['disApprovedValue'];
    if (json['claimRequisitionDisapprovelist'] != null) {
      claimRequisitionDisapprovelist = <ClaimRequisitionDisapprovelist>[];
      json['claimRequisitionDisapprovelist'].forEach((v) {
        claimRequisitionDisapprovelist!
            .add(new ClaimRequisitionDisapprovelist.fromJson(v));
      });
    }
    if (json['claimRequisitionDraftlist'] != null) {
      claimRequisitionDraftlist = <ClaimRequisitionDraftlist>[];
      json['claimRequisitionDraftlist'].forEach((v) {
        claimRequisitionDraftlist!
            .add(new ClaimRequisitionDraftlist.fromJson(v));
      });
    }
    pendingAmount = json['pendingAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totaDraftAmount'] = this.totaDraftAmount;
    data['approvedValue'] = this.approvedValue;
    if (this.claimRequisitionPendinglist != null) {
      data['claimRequisitionPendinglist'] =
          this.claimRequisitionPendinglist!.map((v) => v.toJson()).toList();
    }
    if (this.claimRequisitionApprovedlist != null) {
      data['claimRequisitionApprovedlist'] =
          this.claimRequisitionApprovedlist!.map((v) => v.toJson()).toList();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['submittedValue'] = this.submittedValue;
    data['disApprovedValue'] = this.disApprovedValue;
    if (this.claimRequisitionDisapprovelist != null) {
      data['claimRequisitionDisapprovelist'] =
          this.claimRequisitionDisapprovelist!.map((v) => v.toJson()).toList();
    }
    if (this.claimRequisitionDraftlist != null) {
      data['claimRequisitionDraftlist'] =
          this.claimRequisitionDraftlist!.map((v) => v.toJson()).toList();
    }
    data['pendingAmount'] = this.pendingAmount;
    return data;
  }
}

class ClaimRequisitionPendinglist {
  String? empId;
  String? claimNo;
  String? raisedOn;
  String? statusShow;
  String? branch;
  dynamic orgId;
  String? empName;
  String? catName;
  dynamic approvedAmount;
  String? reimbName;
  String? expName;
  String? raisedDate;
  String? dept;
  dynamic claimedAmt;
  String? subExpName;
  bool? plainingg1;
  bool? isCheck;
  bool? plainingg2;
  bool? plainingg3;
  String? empGrade;
  bool? plainingg4;
  bool? plainingg5;
  dynamic empDetailsId;
  String? designation;
  dynamic reimbId;
  String? reqDate;
  dynamic claimRaiseId;
  String? status;

  ClaimRequisitionPendinglist(
      {this.empId,
        this.claimNo,
        this.raisedOn,
        this.statusShow,
        this.branch,
        this.orgId,
        this.empName,
        this.catName,
        this.approvedAmount,
        this.reimbName,
        this.expName,
        this.raisedDate,
        this.dept,
        this.claimedAmt,
        this.subExpName,
        this.plainingg1,
        this.isCheck,
        this.plainingg2,
        this.plainingg3,
        this.empGrade,
        this.plainingg4,
        this.plainingg5,
        this.empDetailsId,
        this.designation,
        this.reimbId,
        this.reqDate,
        this.claimRaiseId,
        this.status});

  ClaimRequisitionPendinglist.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    claimNo = json['claimNo'];
    raisedOn = json['raisedOn'];
    statusShow = json['statusShow'];
    branch = json['branch'];
    orgId = json['orgId'];
    empName = json['empName'];
    catName = json['catName'];
    approvedAmount = json['approvedAmount'];
    reimbName = json['reimbName'];
    expName = json['expName'];
    raisedDate = json['raisedDate'];
    dept = json['dept'];
    claimedAmt = json['claimedAmt'];
    subExpName = json['subExpName'];
    plainingg1 = json['plainingg1'];
    isCheck = json['isCheck'];
    plainingg2 = json['plainingg2'];
    plainingg3 = json['plainingg3'];
    empGrade = json['empGrade'];
    plainingg4 = json['plainingg4'];
    plainingg5 = json['plainingg5'];
    empDetailsId = json['empDetailsId'];
    designation = json['designation'];
    reimbId = json['reimbId'];
    reqDate = json['ReqDate'];
    claimRaiseId = json['claimRaiseId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['claimNo'] = this.claimNo;
    data['raisedOn'] = this.raisedOn;
    data['statusShow'] = this.statusShow;
    data['branch'] = this.branch;
    data['orgId'] = this.orgId;
    data['empName'] = this.empName;
    data['catName'] = this.catName;
    data['approvedAmount'] = this.approvedAmount;
    data['reimbName'] = this.reimbName;
    data['expName'] = this.expName;
    data['raisedDate'] = this.raisedDate;
    data['dept'] = this.dept;
    data['claimedAmt'] = this.claimedAmt;
    data['subExpName'] = this.subExpName;
    data['plainingg1'] = this.plainingg1;
    data['isCheck'] = this.isCheck;
    data['plainingg2'] = this.plainingg2;
    data['plainingg3'] = this.plainingg3;
    data['empGrade'] = this.empGrade;
    data['plainingg4'] = this.plainingg4;
    data['plainingg5'] = this.plainingg5;
    data['empDetailsId'] = this.empDetailsId;
    data['designation'] = this.designation;
    data['reimbId'] = this.reimbId;
    data['ReqDate'] = this.reqDate;
    data['claimRaiseId'] = this.claimRaiseId;
    data['status'] = this.status;
    return data;
  }
}

class ClaimRequisitionApprovedlist {
  String? empId;
  String? claimNo;
  String? raisedOn;
  String? statusShow;
  String? branch;
  dynamic orgId;
  String? empName;
  String? catName;
  dynamic approvedAmount;
  String? reimbName;
  String? expName;
  String? raisedDate;
  String? dept;
  dynamic claimedAmt;
  String? subExpName;
  bool? plainingg1;
  bool? isCheck;
  bool? plainingg2;
  bool? plainingg3;
  String? empGrade;
  bool? plainingg4;
  bool? plainingg5;
  dynamic empDetailsId;
  String? designation;
  dynamic reimbId;
  String? reqDate;
  dynamic claimRaiseId;
  String? status;

  ClaimRequisitionApprovedlist(
      {this.empId,
        this.claimNo,
        this.raisedOn,
        this.statusShow,
        this.branch,
        this.orgId,
        this.empName,
        this.catName,
        this.approvedAmount,
        this.reimbName,
        this.expName,
        this.raisedDate,
        this.dept,
        this.claimedAmt,
        this.subExpName,
        this.plainingg1,
        this.isCheck,
        this.plainingg2,
        this.plainingg3,
        this.empGrade,
        this.plainingg4,
        this.plainingg5,
        this.empDetailsId,
        this.designation,
        this.reimbId,
        this.reqDate,
        this.claimRaiseId,
        this.status});

  ClaimRequisitionApprovedlist.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    claimNo = json['claimNo'];
    raisedOn = json['raisedOn'];
    statusShow = json['statusShow'];
    branch = json['branch'];
    orgId = json['orgId'];
    empName = json['empName'];
    catName = json['catName'];
    approvedAmount = json['approvedAmount'];
    reimbName = json['reimbName'];
    expName = json['expName'];
    raisedDate = json['raisedDate'];
    dept = json['dept'];
    claimedAmt = json['claimedAmt'];
    subExpName = json['subExpName'];
    plainingg1 = json['plainingg1'];
    isCheck = json['isCheck'];
    plainingg2 = json['plainingg2'];
    plainingg3 = json['plainingg3'];
    empGrade = json['empGrade'];
    plainingg4 = json['plainingg4'];
    plainingg5 = json['plainingg5'];
    empDetailsId = json['empDetailsId'];
    designation = json['designation'];
    reimbId = json['reimbId'];
    reqDate = json['ReqDate'];
    claimRaiseId = json['claimRaiseId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['claimNo'] = this.claimNo;
    data['raisedOn'] = this.raisedOn;
    data['statusShow'] = this.statusShow;
    data['branch'] = this.branch;
    data['orgId'] = this.orgId;
    data['empName'] = this.empName;
    data['catName'] = this.catName;
    data['approvedAmount'] = this.approvedAmount;
    data['reimbName'] = this.reimbName;
    data['expName'] = this.expName;
    data['raisedDate'] = this.raisedDate;
    data['dept'] = this.dept;
    data['claimedAmt'] = this.claimedAmt;
    data['subExpName'] = this.subExpName;
    data['plainingg1'] = this.plainingg1;
    data['isCheck'] = this.isCheck;
    data['plainingg2'] = this.plainingg2;
    data['plainingg3'] = this.plainingg3;
    data['empGrade'] = this.empGrade;
    data['plainingg4'] = this.plainingg4;
    data['plainingg5'] = this.plainingg5;
    data['empDetailsId'] = this.empDetailsId;
    data['designation'] = this.designation;
    data['reimbId'] = this.reimbId;
    data['ReqDate'] = this.reqDate;
    data['claimRaiseId'] = this.claimRaiseId;
    data['status'] = this.status;
    return data;
  }
}

class DataNew {
  String? empId;
  String? claimNo;
  String? raisedOn;
  String? statusShow;
  String? branch;
  dynamic orgId;
  String? empName;
  String? catName;
  dynamic approvedAmount;
  String? reimbName;
  String? expName;
  String? raisedDate;
  String? dept;
  dynamic claimedAmt;
  String? subExpName;
  bool? plainingg1;
  bool? isCheck;
  bool? plainingg2;
  bool? plainingg3;
  String? empGrade;
  bool? plainingg4;
  bool? plainingg5;
  dynamic empDetailsId;
  String? designation;
  dynamic reimbId;
  String? reqDate;
  dynamic claimRaiseId;
  String? status;

  DataNew(
      {this.empId,
        this.claimNo,
        this.raisedOn,
        this.statusShow,
        this.branch,
        this.orgId,
        this.empName,
        this.catName,
        this.approvedAmount,
        this.reimbName,
        this.expName,
        this.raisedDate,
        this.dept,
        this.claimedAmt,
        this.subExpName,
        this.plainingg1,
        this.isCheck,
        this.plainingg2,
        this.plainingg3,
        this.empGrade,
        this.plainingg4,
        this.plainingg5,
        this.empDetailsId,
        this.designation,
        this.reimbId,
        this.reqDate,
        this.claimRaiseId,
        this.status});

  DataNew.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    claimNo = json['claimNo'];
    raisedOn = json['raisedOn'];
    statusShow = json['statusShow'];
    branch = json['branch'];
    orgId = json['orgId'];
    empName = json['empName'];
    catName = json['catName'];
    approvedAmount = json['approvedAmount'];
    reimbName = json['reimbName'];
    expName = json['expName'];
    raisedDate = json['raisedDate'];
    dept = json['dept'];
    claimedAmt = json['claimedAmt'];
    subExpName = json['subExpName'];
    plainingg1 = json['plainingg1'];
    isCheck = json['isCheck'];
    plainingg2 = json['plainingg2'];
    plainingg3 = json['plainingg3'];
    empGrade = json['empGrade'];
    plainingg4 = json['plainingg4'];
    plainingg5 = json['plainingg5'];
    empDetailsId = json['empDetailsId'];
    designation = json['designation'];
    reimbId = json['reimbId'];
    reqDate = json['ReqDate'];
    claimRaiseId = json['claimRaiseId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['claimNo'] = this.claimNo;
    data['raisedOn'] = this.raisedOn;
    data['statusShow'] = this.statusShow;
    data['branch'] = this.branch;
    data['orgId'] = this.orgId;
    data['empName'] = this.empName;
    data['catName'] = this.catName;
    data['approvedAmount'] = this.approvedAmount;
    data['reimbName'] = this.reimbName;
    data['expName'] = this.expName;
    data['raisedDate'] = this.raisedDate;
    data['dept'] = this.dept;
    data['claimedAmt'] = this.claimedAmt;
    data['subExpName'] = this.subExpName;
    data['plainingg1'] = this.plainingg1;
    data['isCheck'] = this.isCheck;
    data['plainingg2'] = this.plainingg2;
    data['plainingg3'] = this.plainingg3;
    data['empGrade'] = this.empGrade;
    data['plainingg4'] = this.plainingg4;
    data['plainingg5'] = this.plainingg5;
    data['empDetailsId'] = this.empDetailsId;
    data['designation'] = this.designation;
    data['reimbId'] = this.reimbId;
    data['ReqDate'] = this.reqDate;
    data['claimRaiseId'] = this.claimRaiseId;
    data['status'] = this.status;
    return data;
  }
}

class ClaimRequisitionDisapprovelist {
  String? empId;
  String? claimNo;
  String? raisedOn;
  String? statusShow;
  String? branch;
  dynamic orgId;
  String? empName;
  String? catName;
  dynamic approvedAmount;
  String? reimbName;
  String? expName;
  String? raisedDate;
  String? dept;
  dynamic claimedAmt;
  String? subExpName;
  bool? plainingg1;
  bool? isCheck;
  bool? plainingg2;
  bool? plainingg3;
  String? empGrade;
  bool? plainingg4;
  bool? plainingg5;
  dynamic empDetailsId;
  String? designation;
  dynamic reimbId;
  String? reqDate;
  dynamic claimRaiseId;
  String? status;

  ClaimRequisitionDisapprovelist(
      {this.empId,
        this.claimNo,
        this.raisedOn,
        this.statusShow,
        this.branch,
        this.orgId,
        this.empName,
        this.catName,
        this.approvedAmount,
        this.reimbName,
        this.expName,
        this.raisedDate,
        this.dept,
        this.claimedAmt,
        this.subExpName,
        this.plainingg1,
        this.isCheck,
        this.plainingg2,
        this.plainingg3,
        this.empGrade,
        this.plainingg4,
        this.plainingg5,
        this.empDetailsId,
        this.designation,
        this.reimbId,
        this.reqDate,
        this.claimRaiseId,
        this.status});

  ClaimRequisitionDisapprovelist.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    claimNo = json['claimNo'];
    raisedOn = json['raisedOn'];
    statusShow = json['statusShow'];
    branch = json['branch'];
    orgId = json['orgId'];
    empName = json['empName'];
    catName = json['catName'];
    approvedAmount = json['approvedAmount'];
    reimbName = json['reimbName'];
    expName = json['expName'];
    raisedDate = json['raisedDate'];
    dept = json['dept'];
    claimedAmt = json['claimedAmt'];
    subExpName = json['subExpName'];
    plainingg1 = json['plainingg1'];
    isCheck = json['isCheck'];
    plainingg2 = json['plainingg2'];
    plainingg3 = json['plainingg3'];
    empGrade = json['empGrade'];
    plainingg4 = json['plainingg4'];
    plainingg5 = json['plainingg5'];
    empDetailsId = json['empDetailsId'];
    designation = json['designation'];
    reimbId = json['reimbId'];
    reqDate = json['ReqDate'];
    claimRaiseId = json['claimRaiseId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['claimNo'] = this.claimNo;
    data['raisedOn'] = this.raisedOn;
    data['statusShow'] = this.statusShow;
    data['branch'] = this.branch;
    data['orgId'] = this.orgId;
    data['empName'] = this.empName;
    data['catName'] = this.catName;
    data['approvedAmount'] = this.approvedAmount;
    data['reimbName'] = this.reimbName;
    data['expName'] = this.expName;
    data['raisedDate'] = this.raisedDate;
    data['dept'] = this.dept;
    data['claimedAmt'] = this.claimedAmt;
    data['subExpName'] = this.subExpName;
    data['plainingg1'] = this.plainingg1;
    data['isCheck'] = this.isCheck;
    data['plainingg2'] = this.plainingg2;
    data['plainingg3'] = this.plainingg3;
    data['empGrade'] = this.empGrade;
    data['plainingg4'] = this.plainingg4;
    data['plainingg5'] = this.plainingg5;
    data['empDetailsId'] = this.empDetailsId;
    data['designation'] = this.designation;
    data['reimbId'] = this.reimbId;
    data['ReqDate'] = this.reqDate;
    data['claimRaiseId'] = this.claimRaiseId;
    data['status'] = this.status;
    return data;
  }
}

class ClaimRequisitionDraftlist {
  String? empId;
  String? claimNo;
  String? raisedOn;
  String? statusShow;
  String? branch;
  dynamic orgId;
  String? empName;
  String? catName;
  dynamic approvedAmount;
  String? reimbName;
  String? expName;
  String? raisedDate;
  String? dept;
  dynamic claimedAmt;
  String? subExpName;
  bool? plainingg1;
  bool? isCheck;
  bool? plainingg2;
  bool? plainingg3;
  String? empGrade;
  bool? plainingg4;
  bool? plainingg5;
  dynamic empDetailsId;
  String? designation;
  dynamic reimbId;
  String? reqDate;
  dynamic claimRaiseId;
  String? status;

  ClaimRequisitionDraftlist(
      {this.empId,
        this.claimNo,
        this.raisedOn,
        this.statusShow,
        this.branch,
        this.orgId,
        this.empName,
        this.catName,
        this.approvedAmount,
        this.reimbName,
        this.expName,
        this.raisedDate,
        this.dept,
        this.claimedAmt,
        this.subExpName,
        this.plainingg1,
        this.isCheck,
        this.plainingg2,
        this.plainingg3,
        this.empGrade,
        this.plainingg4,
        this.plainingg5,
        this.empDetailsId,
        this.designation,
        this.reimbId,
        this.reqDate,
        this.claimRaiseId,
        this.status});

  ClaimRequisitionDraftlist.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    claimNo = json['claimNo'];
    raisedOn = json['raisedOn'];
    statusShow = json['statusShow'];
    branch = json['branch'];
    orgId = json['orgId'];
    empName = json['empName'];
    catName = json['catName'];
    approvedAmount = json['approvedAmount'];
    reimbName = json['reimbName'];
    expName = json['expName'];
    raisedDate = json['raisedDate'];
    dept = json['dept'];
    claimedAmt = json['claimedAmt'];
    subExpName = json['subExpName'];
    plainingg1 = json['plainingg1'];
    isCheck = json['isCheck'];
    plainingg2 = json['plainingg2'];
    plainingg3 = json['plainingg3'];
    empGrade = json['empGrade'];
    plainingg4 = json['plainingg4'];
    plainingg5 = json['plainingg5'];
    empDetailsId = json['empDetailsId'];
    designation = json['designation'];
    reimbId = json['reimbId'];
    reqDate = json['ReqDate'];
    claimRaiseId = json['claimRaiseId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['claimNo'] = this.claimNo;
    data['raisedOn'] = this.raisedOn;
    data['statusShow'] = this.statusShow;
    data['branch'] = this.branch;
    data['orgId'] = this.orgId;
    data['empName'] = this.empName;
    data['catName'] = this.catName;
    data['approvedAmount'] = this.approvedAmount;
    data['reimbName'] = this.reimbName;
    data['expName'] = this.expName;
    data['raisedDate'] = this.raisedDate;
    data['dept'] = this.dept;
    data['claimedAmt'] = this.claimedAmt;
    data['subExpName'] = this.subExpName;
    data['plainingg1'] = this.plainingg1;
    data['isCheck'] = this.isCheck;
    data['plainingg2'] = this.plainingg2;
    data['plainingg3'] = this.plainingg3;
    data['empGrade'] = this.empGrade;
    data['plainingg4'] = this.plainingg4;
    data['plainingg5'] = this.plainingg5;
    data['empDetailsId'] = this.empDetailsId;
    data['designation'] = this.designation;
    data['reimbId'] = this.reimbId;
    data['ReqDate'] = this.reqDate;
    data['claimRaiseId'] = this.claimRaiseId;
    data['status'] = this.status;
    return data;
  }
}
