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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['claimNo'] = this.claimNo;
    data['subSubCatId'] = this.subSubCatId;
    data['odometerStart'] = this.odometerStart;
    data['raisedOn'] = this.raisedOn;
    data['document'] = this.document;
    data['statusShow'] = this.statusShow;
    data['branch'] = this.branch;
    data['orgId'] = this.orgId;
    data['empName'] = this.empName;
    data['catName'] = this.catName;
    data['approvedAmount'] = this.approvedAmount;
    data['reimbName'] = this.reimbName;
    data['expId'] = this.expId;
    data['expName'] = this.expName;
    data['raisedDate'] = this.raisedDate;
    data['subExpId'] = this.subExpId;
    data['merchant'] = this.merchant;
    data['dept'] = this.dept;
    data['claimedAmt'] = this.claimedAmt;
    data['catId'] = this.catId;
    data['subExpName'] = this.subExpName;
    data['plainingg1'] = this.plainingg1;
    data['isCheck'] = this.isCheck;
    data['plainingg2'] = this.plainingg2;
    data['month'] = this.month;
    data['plainingg3'] = this.plainingg3;
    data['empGrade'] = this.empGrade;
    data['plainingg4'] = this.plainingg4;
    data['travelTo'] = this.travelTo;
    data['plainingg5'] = this.plainingg5;
    data['kilometers'] = this.kilometers;
    data['travelFrom'] = this.travelFrom;
    data['empDetailsId'] = this.empDetailsId;
    data['designation'] = this.designation;
    data['reimbId'] = this.reimbId;
    data['ReqDate'] = this.reqDate;
    data['claimRaiseId'] = this.claimRaiseId;
    data['odometerEnd'] = this.odometerEnd;
    data['remarks'] = this.remarks;
    data['status'] = this.status;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['claimNo'] = this.claimNo;
    data['subSubCatId'] = this.subSubCatId;
    data['odometerStart'] = this.odometerStart;
    data['raisedOn'] = this.raisedOn;
    data['document'] = this.document;
    data['statusShow'] = this.statusShow;
    data['branch'] = this.branch;
    data['orgId'] = this.orgId;
    data['empName'] = this.empName;
    data['catName'] = this.catName;
    data['approvedAmount'] = this.approvedAmount;
    data['reimbName'] = this.reimbName;
    data['expId'] = this.expId;
    data['expName'] = this.expName;
    data['raisedDate'] = this.raisedDate;
    data['subExpId'] = this.subExpId;
    data['merchant'] = this.merchant;
    data['dept'] = this.dept;
    data['claimedAmt'] = this.claimedAmt;
    data['catId'] = this.catId;
    data['subExpName'] = this.subExpName;
    data['plainingg1'] = this.plainingg1;
    data['isCheck'] = this.isCheck;
    data['plainingg2'] = this.plainingg2;
    data['month'] = this.month;
    data['plainingg3'] = this.plainingg3;
    data['empGrade'] = this.empGrade;
    data['plainingg4'] = this.plainingg4;
    data['travelTo'] = this.travelTo;
    data['plainingg5'] = this.plainingg5;
    data['kilometers'] = this.kilometers;
    data['travelFrom'] = this.travelFrom;
    data['empDetailsId'] = this.empDetailsId;
    data['designation'] = this.designation;
    data['reimbId'] = this.reimbId;
    data['ReqDate'] = this.reqDate;
    data['claimRaiseId'] = this.claimRaiseId;
    data['odometerEnd'] = this.odometerEnd;
    data['remarks'] = this.remarks;
    data['status'] = this.status;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['claimNo'] = this.claimNo;
    data['subSubCatId'] = this.subSubCatId;
    data['odometerStart'] = this.odometerStart;
    data['raisedOn'] = this.raisedOn;
    data['document'] = this.document;
    data['statusShow'] = this.statusShow;
    data['branch'] = this.branch;
    data['orgId'] = this.orgId;
    data['empName'] = this.empName;
    data['catName'] = this.catName;
    data['approvedAmount'] = this.approvedAmount;
    data['reimbName'] = this.reimbName;
    data['expId'] = this.expId;
    data['expName'] = this.expName;
    data['raisedDate'] = this.raisedDate;
    data['subExpId'] = this.subExpId;
    data['merchant'] = this.merchant;
    data['dept'] = this.dept;
    data['claimedAmt'] = this.claimedAmt;
    data['catId'] = this.catId;
    data['subExpName'] = this.subExpName;
    data['plainingg1'] = this.plainingg1;
    data['isCheck'] = this.isCheck;
    data['plainingg2'] = this.plainingg2;
    data['month'] = this.month;
    data['plainingg3'] = this.plainingg3;
    data['empGrade'] = this.empGrade;
    data['plainingg4'] = this.plainingg4;
    data['travelTo'] = this.travelTo;
    data['plainingg5'] = this.plainingg5;
    data['kilometers'] = this.kilometers;
    data['travelFrom'] = this.travelFrom;
    data['empDetailsId'] = this.empDetailsId;
    data['designation'] = this.designation;
    data['reimbId'] = this.reimbId;
    data['ReqDate'] = this.reqDate;
    data['claimRaiseId'] = this.claimRaiseId;
    data['odometerEnd'] = this.odometerEnd;
    data['remarks'] = this.remarks;
    data['status'] = this.status;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['claimNo'] = this.claimNo;
    data['subSubCatId'] = this.subSubCatId;
    data['odometerStart'] = this.odometerStart;
    data['raisedOn'] = this.raisedOn;
    data['document'] = this.document;
    data['statusShow'] = this.statusShow;
    data['branch'] = this.branch;
    data['orgId'] = this.orgId;
    data['empName'] = this.empName;
    data['catName'] = this.catName;
    data['approvedAmount'] = this.approvedAmount;
    data['reimbName'] = this.reimbName;
    data['expId'] = this.expId;
    data['expName'] = this.expName;
    data['raisedDate'] = this.raisedDate;
    data['subExpId'] = this.subExpId;
    data['merchant'] = this.merchant;
    data['dept'] = this.dept;
    data['claimedAmt'] = this.claimedAmt;
    data['catId'] = this.catId;
    data['subExpName'] = this.subExpName;
    data['plainingg1'] = this.plainingg1;
    data['isCheck'] = this.isCheck;
    data['plainingg2'] = this.plainingg2;
    data['month'] = this.month;
    data['plainingg3'] = this.plainingg3;
    data['empGrade'] = this.empGrade;
    data['plainingg4'] = this.plainingg4;
    data['travelTo'] = this.travelTo;
    data['plainingg5'] = this.plainingg5;
    data['kilometers'] = this.kilometers;
    data['travelFrom'] = this.travelFrom;
    data['empDetailsId'] = this.empDetailsId;
    data['designation'] = this.designation;
    data['reimbId'] = this.reimbId;
    data['ReqDate'] = this.reqDate;
    data['claimRaiseId'] = this.claimRaiseId;
    data['odometerEnd'] = this.odometerEnd;
    data['remarks'] = this.remarks;
    data['status'] = this.status;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['claimNo'] = this.claimNo;
    data['subSubCatId'] = this.subSubCatId;
    data['odometerStart'] = this.odometerStart;
    data['raisedOn'] = this.raisedOn;
    data['document'] = this.document;
    data['statusShow'] = this.statusShow;
    data['branch'] = this.branch;
    data['orgId'] = this.orgId;
    data['empName'] = this.empName;
    data['catName'] = this.catName;
    data['approvedAmount'] = this.approvedAmount;
    data['reimbName'] = this.reimbName;
    data['expId'] = this.expId;
    data['expName'] = this.expName;
    data['raisedDate'] = this.raisedDate;
    data['subExpId'] = this.subExpId;
    data['merchant'] = this.merchant;
    data['dept'] = this.dept;
    data['claimedAmt'] = this.claimedAmt;
    data['catId'] = this.catId;
    data['subExpName'] = this.subExpName;
    data['plainingg1'] = this.plainingg1;
    data['isCheck'] = this.isCheck;
    data['plainingg2'] = this.plainingg2;
    data['month'] = this.month;
    data['plainingg3'] = this.plainingg3;
    data['empGrade'] = this.empGrade;
    data['plainingg4'] = this.plainingg4;
    data['travelTo'] = this.travelTo;
    data['plainingg5'] = this.plainingg5;
    data['kilometers'] = this.kilometers;
    data['travelFrom'] = this.travelFrom;
    data['empDetailsId'] = this.empDetailsId;
    data['designation'] = this.designation;
    data['reimbId'] = this.reimbId;
    data['ReqDate'] = this.reqDate;
    data['claimRaiseId'] = this.claimRaiseId;
    data['odometerEnd'] = this.odometerEnd;
    data['remarks'] = this.remarks;
    data['status'] = this.status;
    return data;
  }
}
