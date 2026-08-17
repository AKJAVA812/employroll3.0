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
            .add(ClaimRequisitionPendinglist.fromJson(v));
      });
    }
    if (json['claimRequisitionApprovedlist'] != null) {
      claimRequisitionApprovedlist = <ClaimRequisitionApprovedlist>[];
      json['claimRequisitionApprovedlist'].forEach((v) {
        claimRequisitionApprovedlist!
            .add(ClaimRequisitionApprovedlist.fromJson(v));
      });
    }
    if (json['data'] != null) {
      data = <DataNew>[];
      json['data'].forEach((v) {
        data!.add(DataNew.fromJson(v));
      });
    }
    submittedValue = json['submittedValue'];
    disApprovedValue = json['disApprovedValue'];
    if (json['claimRequisitionDisapprovelist'] != null) {
      claimRequisitionDisapprovelist = <ClaimRequisitionDisapprovelist>[];
      json['claimRequisitionDisapprovelist'].forEach((v) {
        claimRequisitionDisapprovelist!
            .add(ClaimRequisitionDisapprovelist.fromJson(v));
      });
    }
    if (json['claimRequisitionDraftlist'] != null) {
      claimRequisitionDraftlist = <ClaimRequisitionDraftlist>[];
      json['claimRequisitionDraftlist'].forEach((v) {
        claimRequisitionDraftlist!
            .add(ClaimRequisitionDraftlist.fromJson(v));
      });
    }
    pendingAmount = json['pendingAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totaDraftAmount'] = totaDraftAmount;
    data['approvedValue'] = approvedValue;
    if (claimRequisitionPendinglist != null) {
      data['claimRequisitionPendinglist'] =
          claimRequisitionPendinglist!.map((v) => v.toJson()).toList();
    }
    if (claimRequisitionApprovedlist != null) {
      data['claimRequisitionApprovedlist'] =
          claimRequisitionApprovedlist!.map((v) => v.toJson()).toList();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['submittedValue'] = submittedValue;
    data['disApprovedValue'] = disApprovedValue;
    if (claimRequisitionDisapprovelist != null) {
      data['claimRequisitionDisapprovelist'] =
          claimRequisitionDisapprovelist!.map((v) => v.toJson()).toList();
    }
    if (claimRequisitionDraftlist != null) {
      data['claimRequisitionDraftlist'] =
          claimRequisitionDraftlist!.map((v) => v.toJson()).toList();
    }
    data['pendingAmount'] = pendingAmount;
    return data;
  }
}

class DataNew {
  dynamic empId;
  dynamic claimNo;
  dynamic subSubCatId;
  dynamic odometerStart;
  dynamic raisedOn;
  dynamic document;
  dynamic statusShow;
  dynamic branch;
  dynamic orgId;
  dynamic empName;
  dynamic catName;
  dynamic approvedAmount;
  dynamic reimbName;
  dynamic expId;
  dynamic expName;
  dynamic raisedDate;
  dynamic subExpId;
  dynamic merchant;
  dynamic dept;
  dynamic claimedAmt;
  dynamic catId;
  dynamic subExpName;
  bool? plainingg1;
  bool? isCheck;
  bool? plainingg2;
  dynamic month;
  bool? plainingg3;
  dynamic empGrade;
  bool? plainingg4;
  dynamic travelTo;
  bool? plainingg5;
  dynamic kilometers;
  dynamic travelFrom;
  dynamic empDetailsId;
  dynamic designation;
  dynamic reimbId;
  dynamic reqDate;
  dynamic claimRaiseId;
  dynamic odometerEnd;
  dynamic remarks;
  dynamic status;

  DataNew(
      {this.empId,
        this.claimNo,
        this.subSubCatId,
        this.odometerStart,
        this.raisedOn,
        this.document,
        this.statusShow,
        this.branch,
        this.orgId,
        this.empName,
        this.catName,
        this.approvedAmount,
        this.reimbName,
        this.expId,
        this.expName,
        this.raisedDate,
        this.subExpId,
        this.merchant,
        this.dept,
        this.claimedAmt,
        this.catId,
        this.subExpName,
        this.plainingg1,
        this.isCheck,
        this.plainingg2,
        this.month,
        this.plainingg3,
        this.empGrade,
        this.plainingg4,
        this.travelTo,
        this.plainingg5,
        this.kilometers,
        this.travelFrom,
        this.empDetailsId,
        this.designation,
        this.reimbId,
        this.reqDate,
        this.claimRaiseId,
        this.odometerEnd,
        this.remarks,
        this.status});

  DataNew.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    claimNo = json['claimNo'];
    subSubCatId = json['subSubCatId'];
    odometerStart = json['odometerStart'];
    raisedOn = json['raisedOn'];
    document = json['document'];
    statusShow = json['statusShow'];
    branch = json['branch'];
    orgId = json['orgId'];
    empName = json['empName'];
    catName = json['catName'];
    approvedAmount = json['approvedAmount'];
    reimbName = json['reimbName'];
    expId = json['expId'];
    expName = json['expName'];
    raisedDate = json['raisedDate'];
    subExpId = json['subExpId'];
    merchant = json['merchant'];
    dept = json['dept'];
    claimedAmt = json['claimedAmt'];
    catId = json['catId'];
    subExpName = json['subExpName'];
    plainingg1 = json['plainingg1'];
    isCheck = json['isCheck'];
    plainingg2 = json['plainingg2'];
    month = json['month'];
    plainingg3 = json['plainingg3'];
    empGrade = json['empGrade'];
    plainingg4 = json['plainingg4'];
    travelTo = json['travelTo'];
    plainingg5 = json['plainingg5'];
    kilometers = json['kilometers'];
    travelFrom = json['travelFrom'];
    empDetailsId = json['empDetailsId'];
    designation = json['designation'];
    reimbId = json['reimbId'];
    reqDate = json['ReqDate'];
    claimRaiseId = json['claimRaiseId'];
    odometerEnd = json['odometerEnd'];
    remarks = json['remarks'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empId'] = empId;
    data['claimNo'] = claimNo;
    data['subSubCatId'] = subSubCatId;
    data['odometerStart'] = odometerStart;
    data['raisedOn'] = raisedOn;
    data['document'] = document;
    data['statusShow'] = statusShow;
    data['branch'] = branch;
    data['orgId'] = orgId;
    data['empName'] = empName;
    data['catName'] = catName;
    data['approvedAmount'] = approvedAmount;
    data['reimbName'] = reimbName;
    data['expId'] = expId;
    data['expName'] = expName;
    data['raisedDate'] = raisedDate;
    data['subExpId'] = subExpId;
    data['merchant'] = merchant;
    data['dept'] = dept;
    data['claimedAmt'] = claimedAmt;
    data['catId'] = catId;
    data['subExpName'] = subExpName;
    data['plainingg1'] = plainingg1;
    data['isCheck'] = isCheck;
    data['plainingg2'] = plainingg2;
    data['month'] = month;
    data['plainingg3'] = plainingg3;
    data['empGrade'] = empGrade;
    data['plainingg4'] = plainingg4;
    data['travelTo'] = travelTo;
    data['plainingg5'] = plainingg5;
    data['kilometers'] = kilometers;
    data['travelFrom'] = travelFrom;
    data['empDetailsId'] = empDetailsId;
    data['designation'] = designation;
    data['reimbId'] = reimbId;
    data['ReqDate'] = reqDate;
    data['claimRaiseId'] = claimRaiseId;
    data['odometerEnd'] = odometerEnd;
    data['remarks'] = remarks;
    data['status'] = status;
    return data;
  }
}

class ClaimRequisitionPendinglist {
  dynamic empId;
  dynamic claimNo;
  dynamic subSubCatId;
  dynamic odometerStart;
  dynamic raisedOn;
  dynamic document;
  dynamic statusShow;
  dynamic branch;
  dynamic orgId;
  dynamic empName;
  dynamic catName;
  dynamic approvedAmount;
  dynamic reimbName;
  dynamic expId;
  dynamic expName;
  dynamic raisedDate;
  dynamic subExpId;
  dynamic merchant;
  dynamic dept;
  dynamic claimedAmt;
  dynamic catId;
  dynamic subExpName;
  bool? plainingg1;
  bool? isCheck;
  bool? plainingg2;
  dynamic month;
  bool? plainingg3;
  dynamic empGrade;
  bool? plainingg4;
  dynamic travelTo;
  bool? plainingg5;
  dynamic kilometers;
  dynamic travelFrom;
  dynamic empDetailsId;
  dynamic designation;
  dynamic reimbId;
  dynamic reqDate;
  dynamic claimRaiseId;
  dynamic odometerEnd;
  dynamic remarks;
  dynamic status;

  ClaimRequisitionPendinglist(
      {this.empId,
        this.claimNo,
        this.subSubCatId,
        this.odometerStart,
        this.raisedOn,
        this.document,
        this.statusShow,
        this.branch,
        this.orgId,
        this.empName,
        this.catName,
        this.approvedAmount,
        this.reimbName,
        this.expId,
        this.expName,
        this.raisedDate,
        this.subExpId,
        this.merchant,
        this.dept,
        this.claimedAmt,
        this.catId,
        this.subExpName,
        this.plainingg1,
        this.isCheck,
        this.plainingg2,
        this.month,
        this.plainingg3,
        this.empGrade,
        this.plainingg4,
        this.travelTo,
        this.plainingg5,
        this.kilometers,
        this.travelFrom,
        this.empDetailsId,
        this.designation,
        this.reimbId,
        this.reqDate,
        this.claimRaiseId,
        this.odometerEnd,
        this.remarks,
        this.status});

  ClaimRequisitionPendinglist.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    claimNo = json['claimNo'];
    subSubCatId = json['subSubCatId'];
    odometerStart = json['odometerStart'];
    raisedOn = json['raisedOn'];
    document = json['document'];
    statusShow = json['statusShow'];
    branch = json['branch'];
    orgId = json['orgId'];
    empName = json['empName'];
    catName = json['catName'];
    approvedAmount = json['approvedAmount'];
    reimbName = json['reimbName'];
    expId = json['expId'];
    expName = json['expName'];
    raisedDate = json['raisedDate'];
    subExpId = json['subExpId'];
    merchant = json['merchant'];
    dept = json['dept'];
    claimedAmt = json['claimedAmt'];
    catId = json['catId'];
    subExpName = json['subExpName'];
    plainingg1 = json['plainingg1'];
    isCheck = json['isCheck'];
    plainingg2 = json['plainingg2'];
    month = json['month'];
    plainingg3 = json['plainingg3'];
    empGrade = json['empGrade'];
    plainingg4 = json['plainingg4'];
    travelTo = json['travelTo'];
    plainingg5 = json['plainingg5'];
    kilometers = json['kilometers'];
    travelFrom = json['travelFrom'];
    empDetailsId = json['empDetailsId'];
    designation = json['designation'];
    reimbId = json['reimbId'];
    reqDate = json['ReqDate'];
    claimRaiseId = json['claimRaiseId'];
    odometerEnd = json['odometerEnd'];
    remarks = json['remarks'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empId'] = empId;
    data['claimNo'] = claimNo;
    data['subSubCatId'] = subSubCatId;
    data['odometerStart'] = odometerStart;
    data['raisedOn'] = raisedOn;
    data['document'] = document;
    data['statusShow'] = statusShow;
    data['branch'] = branch;
    data['orgId'] = orgId;
    data['empName'] = empName;
    data['catName'] = catName;
    data['approvedAmount'] = approvedAmount;
    data['reimbName'] = reimbName;
    data['expId'] = expId;
    data['expName'] = expName;
    data['raisedDate'] = raisedDate;
    data['subExpId'] = subExpId;
    data['merchant'] = merchant;
    data['dept'] = dept;
    data['claimedAmt'] = claimedAmt;
    data['catId'] = catId;
    data['subExpName'] = subExpName;
    data['plainingg1'] = plainingg1;
    data['isCheck'] = isCheck;
    data['plainingg2'] = plainingg2;
    data['month'] = month;
    data['plainingg3'] = plainingg3;
    data['empGrade'] = empGrade;
    data['plainingg4'] = plainingg4;
    data['travelTo'] = travelTo;
    data['plainingg5'] = plainingg5;
    data['kilometers'] = kilometers;
    data['travelFrom'] = travelFrom;
    data['empDetailsId'] = empDetailsId;
    data['designation'] = designation;
    data['reimbId'] = reimbId;
    data['ReqDate'] = reqDate;
    data['claimRaiseId'] = claimRaiseId;
    data['odometerEnd'] = odometerEnd;
    data['remarks'] = remarks;
    data['status'] = status;
    return data;
  }
}

class ClaimRequisitionApprovedlist {
  dynamic empId;
  dynamic claimNo;
  dynamic subSubCatId;
  dynamic odometerStart;
  dynamic raisedOn;
  dynamic document;
  dynamic statusShow;
  dynamic branch;
  dynamic orgId;
  dynamic empName;
  dynamic catName;
  dynamic approvedAmount;
  dynamic reimbName;
  dynamic expId;
  dynamic expName;
  dynamic raisedDate;
  dynamic subExpId;
  dynamic merchant;
  dynamic dept;
  dynamic claimedAmt;
  dynamic catId;
  dynamic subExpName;
  bool? plainingg1;
  bool? isCheck;
  bool? plainingg2;
  dynamic month;
  bool? plainingg3;
  dynamic empGrade;
  bool? plainingg4;
  dynamic travelTo;
  bool? plainingg5;
  dynamic kilometers;
  dynamic travelFrom;
  dynamic empDetailsId;
  dynamic designation;
  dynamic reimbId;
  dynamic reqDate;
  dynamic claimRaiseId;
  dynamic odometerEnd;
  dynamic remarks;
  dynamic status;

  ClaimRequisitionApprovedlist(
      {this.empId,
        this.claimNo,
        this.subSubCatId,
        this.odometerStart,
        this.raisedOn,
        this.document,
        this.statusShow,
        this.branch,
        this.orgId,
        this.empName,
        this.catName,
        this.approvedAmount,
        this.reimbName,
        this.expId,
        this.expName,
        this.raisedDate,
        this.subExpId,
        this.merchant,
        this.dept,
        this.claimedAmt,
        this.catId,
        this.subExpName,
        this.plainingg1,
        this.isCheck,
        this.plainingg2,
        this.month,
        this.plainingg3,
        this.empGrade,
        this.plainingg4,
        this.travelTo,
        this.plainingg5,
        this.kilometers,
        this.travelFrom,
        this.empDetailsId,
        this.designation,
        this.reimbId,
        this.reqDate,
        this.claimRaiseId,
        this.odometerEnd,
        this.remarks,
        this.status});

  ClaimRequisitionApprovedlist.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    claimNo = json['claimNo'];
    subSubCatId = json['subSubCatId'];
    odometerStart = json['odometerStart'];
    raisedOn = json['raisedOn'];
    document = json['document'];
    statusShow = json['statusShow'];
    branch = json['branch'];
    orgId = json['orgId'];
    empName = json['empName'];
    catName = json['catName'];
    approvedAmount = json['approvedAmount'];
    reimbName = json['reimbName'];
    expId = json['expId'];
    expName = json['expName'];
    raisedDate = json['raisedDate'];
    subExpId = json['subExpId'];
    merchant = json['merchant'];
    dept = json['dept'];
    claimedAmt = json['claimedAmt'];
    catId = json['catId'];
    subExpName = json['subExpName'];
    plainingg1 = json['plainingg1'];
    isCheck = json['isCheck'];
    plainingg2 = json['plainingg2'];
    month = json['month'];
    plainingg3 = json['plainingg3'];
    empGrade = json['empGrade'];
    plainingg4 = json['plainingg4'];
    travelTo = json['travelTo'];
    plainingg5 = json['plainingg5'];
    kilometers = json['kilometers'];
    travelFrom = json['travelFrom'];
    empDetailsId = json['empDetailsId'];
    designation = json['designation'];
    reimbId = json['reimbId'];
    reqDate = json['ReqDate'];
    claimRaiseId = json['claimRaiseId'];
    odometerEnd = json['odometerEnd'];
    remarks = json['remarks'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empId'] = empId;
    data['claimNo'] = claimNo;
    data['subSubCatId'] = subSubCatId;
    data['odometerStart'] = odometerStart;
    data['raisedOn'] = raisedOn;
    data['document'] = document;
    data['statusShow'] = statusShow;
    data['branch'] = branch;
    data['orgId'] = orgId;
    data['empName'] = empName;
    data['catName'] = catName;
    data['approvedAmount'] = approvedAmount;
    data['reimbName'] = reimbName;
    data['expId'] = expId;
    data['expName'] = expName;
    data['raisedDate'] = raisedDate;
    data['subExpId'] = subExpId;
    data['merchant'] = merchant;
    data['dept'] = dept;
    data['claimedAmt'] = claimedAmt;
    data['catId'] = catId;
    data['subExpName'] = subExpName;
    data['plainingg1'] = plainingg1;
    data['isCheck'] = isCheck;
    data['plainingg2'] = plainingg2;
    data['month'] = month;
    data['plainingg3'] = plainingg3;
    data['empGrade'] = empGrade;
    data['plainingg4'] = plainingg4;
    data['travelTo'] = travelTo;
    data['plainingg5'] = plainingg5;
    data['kilometers'] = kilometers;
    data['travelFrom'] = travelFrom;
    data['empDetailsId'] = empDetailsId;
    data['designation'] = designation;
    data['reimbId'] = reimbId;
    data['ReqDate'] = reqDate;
    data['claimRaiseId'] = claimRaiseId;
    data['odometerEnd'] = odometerEnd;
    data['remarks'] = remarks;
    data['status'] = status;
    return data;
  }
}

class ClaimRequisitionDisapprovelist {
  dynamic empId;
  dynamic claimNo;
  dynamic subSubCatId;
  dynamic odometerStart;
  dynamic raisedOn;
  dynamic document;
  dynamic statusShow;
  dynamic branch;
  dynamic orgId;
  dynamic empName;
  dynamic catName;
  dynamic approvedAmount;
  dynamic reimbName;
  dynamic expId;
  dynamic expName;
  dynamic raisedDate;
  dynamic subExpId;
  dynamic merchant;
  dynamic dept;
  dynamic claimedAmt;
  dynamic catId;
  dynamic subExpName;
  bool? plainingg1;
  bool? isCheck;
  bool? plainingg2;
  dynamic month;
  bool? plainingg3;
  dynamic empGrade;
  bool? plainingg4;
  dynamic travelTo;
  bool? plainingg5;
  dynamic kilometers;
  dynamic travelFrom;
  dynamic empDetailsId;
  dynamic designation;
  dynamic reimbId;
  dynamic reqDate;
  dynamic claimRaiseId;
  dynamic odometerEnd;
  dynamic remarks;
  dynamic status;

  ClaimRequisitionDisapprovelist(
      {this.empId,
        this.claimNo,
        this.subSubCatId,
        this.odometerStart,
        this.raisedOn,
        this.document,
        this.statusShow,
        this.branch,
        this.orgId,
        this.empName,
        this.catName,
        this.approvedAmount,
        this.reimbName,
        this.expId,
        this.expName,
        this.raisedDate,
        this.subExpId,
        this.merchant,
        this.dept,
        this.claimedAmt,
        this.catId,
        this.subExpName,
        this.plainingg1,
        this.isCheck,
        this.plainingg2,
        this.month,
        this.plainingg3,
        this.empGrade,
        this.plainingg4,
        this.travelTo,
        this.plainingg5,
        this.kilometers,
        this.travelFrom,
        this.empDetailsId,
        this.designation,
        this.reimbId,
        this.reqDate,
        this.claimRaiseId,
        this.odometerEnd,
        this.remarks,
        this.status});

  ClaimRequisitionDisapprovelist.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    claimNo = json['claimNo'];
    subSubCatId = json['subSubCatId'];
    odometerStart = json['odometerStart'];
    raisedOn = json['raisedOn'];
    document = json['document'];
    statusShow = json['statusShow'];
    branch = json['branch'];
    orgId = json['orgId'];
    empName = json['empName'];
    catName = json['catName'];
    approvedAmount = json['approvedAmount'];
    reimbName = json['reimbName'];
    expId = json['expId'];
    expName = json['expName'];
    raisedDate = json['raisedDate'];
    subExpId = json['subExpId'];
    merchant = json['merchant'];
    dept = json['dept'];
    claimedAmt = json['claimedAmt'];
    catId = json['catId'];
    subExpName = json['subExpName'];
    plainingg1 = json['plainingg1'];
    isCheck = json['isCheck'];
    plainingg2 = json['plainingg2'];
    month = json['month'];
    plainingg3 = json['plainingg3'];
    empGrade = json['empGrade'];
    plainingg4 = json['plainingg4'];
    travelTo = json['travelTo'];
    plainingg5 = json['plainingg5'];
    kilometers = json['kilometers'];
    travelFrom = json['travelFrom'];
    empDetailsId = json['empDetailsId'];
    designation = json['designation'];
    reimbId = json['reimbId'];
    reqDate = json['ReqDate'];
    claimRaiseId = json['claimRaiseId'];
    odometerEnd = json['odometerEnd'];
    remarks = json['remarks'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empId'] = empId;
    data['claimNo'] = claimNo;
    data['subSubCatId'] = subSubCatId;
    data['odometerStart'] = odometerStart;
    data['raisedOn'] = raisedOn;
    data['document'] = document;
    data['statusShow'] = statusShow;
    data['branch'] = branch;
    data['orgId'] = orgId;
    data['empName'] = empName;
    data['catName'] = catName;
    data['approvedAmount'] = approvedAmount;
    data['reimbName'] = reimbName;
    data['expId'] = expId;
    data['expName'] = expName;
    data['raisedDate'] = raisedDate;
    data['subExpId'] = subExpId;
    data['merchant'] = merchant;
    data['dept'] = dept;
    data['claimedAmt'] = claimedAmt;
    data['catId'] = catId;
    data['subExpName'] = subExpName;
    data['plainingg1'] = plainingg1;
    data['isCheck'] = isCheck;
    data['plainingg2'] = plainingg2;
    data['month'] = month;
    data['plainingg3'] = plainingg3;
    data['empGrade'] = empGrade;
    data['plainingg4'] = plainingg4;
    data['travelTo'] = travelTo;
    data['plainingg5'] = plainingg5;
    data['kilometers'] = kilometers;
    data['travelFrom'] = travelFrom;
    data['empDetailsId'] = empDetailsId;
    data['designation'] = designation;
    data['reimbId'] = reimbId;
    data['ReqDate'] = reqDate;
    data['claimRaiseId'] = claimRaiseId;
    data['odometerEnd'] = odometerEnd;
    data['remarks'] = remarks;
    data['status'] = status;
    return data;
  }
}

class ClaimRequisitionDraftlist {
  dynamic empId;
  dynamic claimNo;
  dynamic subSubCatId;
  dynamic odometerStart;
  dynamic raisedOn;
  dynamic document;
  dynamic statusShow;
  dynamic branch;
  dynamic orgId;
  dynamic empName;
  dynamic catName;
  dynamic approvedAmount;
  dynamic reimbName;
  dynamic expId;
  dynamic expName;
  dynamic raisedDate;
  dynamic subExpId;
  dynamic merchant;
  dynamic dept;
  dynamic claimedAmt;
  dynamic catId;
  dynamic subExpName;
  bool? plainingg1;
  bool? isCheck;
  bool? plainingg2;
  dynamic month;
  bool? plainingg3;
  dynamic empGrade;
  bool? plainingg4;
  dynamic travelTo;
  bool? plainingg5;
  dynamic kilometers;
  dynamic travelFrom;
  dynamic empDetailsId;
  dynamic designation;
  dynamic reimbId;
  dynamic reqDate;
  dynamic claimRaiseId;
  dynamic odometerEnd;
  dynamic remarks;
  dynamic status;

  ClaimRequisitionDraftlist(
      {this.empId,
        this.claimNo,
        this.subSubCatId,
        this.odometerStart,
        this.raisedOn,
        this.document,
        this.statusShow,
        this.branch,
        this.orgId,
        this.empName,
        this.catName,
        this.approvedAmount,
        this.reimbName,
        this.expId,
        this.expName,
        this.raisedDate,
        this.subExpId,
        this.merchant,
        this.dept,
        this.claimedAmt,
        this.catId,
        this.subExpName,
        this.plainingg1,
        this.isCheck,
        this.plainingg2,
        this.month,
        this.plainingg3,
        this.empGrade,
        this.plainingg4,
        this.travelTo,
        this.plainingg5,
        this.kilometers,
        this.travelFrom,
        this.empDetailsId,
        this.designation,
        this.reimbId,
        this.reqDate,
        this.claimRaiseId,
        this.odometerEnd,
        this.remarks,
        this.status});

  ClaimRequisitionDraftlist.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    claimNo = json['claimNo'];
    subSubCatId = json['subSubCatId'];
    odometerStart = json['odometerStart'];
    raisedOn = json['raisedOn'];
    document = json['document'];
    statusShow = json['statusShow'];
    branch = json['branch'];
    orgId = json['orgId'];
    empName = json['empName'];
    catName = json['catName'];
    approvedAmount = json['approvedAmount'];
    reimbName = json['reimbName'];
    expId = json['expId'];
    expName = json['expName'];
    raisedDate = json['raisedDate'];
    subExpId = json['subExpId'];
    merchant = json['merchant'];
    dept = json['dept'];
    claimedAmt = json['claimedAmt'];
    catId = json['catId'];
    subExpName = json['subExpName'];
    plainingg1 = json['plainingg1'];
    isCheck = json['isCheck'];
    plainingg2 = json['plainingg2'];
    month = json['month'];
    plainingg3 = json['plainingg3'];
    empGrade = json['empGrade'];
    plainingg4 = json['plainingg4'];
    travelTo = json['travelTo'];
    plainingg5 = json['plainingg5'];
    kilometers = json['kilometers'];
    travelFrom = json['travelFrom'];
    empDetailsId = json['empDetailsId'];
    designation = json['designation'];
    reimbId = json['reimbId'];
    reqDate = json['ReqDate'];
    claimRaiseId = json['claimRaiseId'];
    odometerEnd = json['odometerEnd'];
    remarks = json['remarks'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empId'] = empId;
    data['claimNo'] = claimNo;
    data['subSubCatId'] = subSubCatId;
    data['odometerStart'] = odometerStart;
    data['raisedOn'] = raisedOn;
    data['document'] = document;
    data['statusShow'] = statusShow;
    data['branch'] = branch;
    data['orgId'] = orgId;
    data['empName'] = empName;
    data['catName'] = catName;
    data['approvedAmount'] = approvedAmount;
    data['reimbName'] = reimbName;
    data['expId'] = expId;
    data['expName'] = expName;
    data['raisedDate'] = raisedDate;
    data['subExpId'] = subExpId;
    data['merchant'] = merchant;
    data['dept'] = dept;
    data['claimedAmt'] = claimedAmt;
    data['catId'] = catId;
    data['subExpName'] = subExpName;
    data['plainingg1'] = plainingg1;
    data['isCheck'] = isCheck;
    data['plainingg2'] = plainingg2;
    data['month'] = month;
    data['plainingg3'] = plainingg3;
    data['empGrade'] = empGrade;
    data['plainingg4'] = plainingg4;
    data['travelTo'] = travelTo;
    data['plainingg5'] = plainingg5;
    data['kilometers'] = kilometers;
    data['travelFrom'] = travelFrom;
    data['empDetailsId'] = empDetailsId;
    data['designation'] = designation;
    data['reimbId'] = reimbId;
    data['ReqDate'] = reqDate;
    data['claimRaiseId'] = claimRaiseId;
    data['odometerEnd'] = odometerEnd;
    data['remarks'] = remarks;
    data['status'] = status;
    return data;
  }
}
