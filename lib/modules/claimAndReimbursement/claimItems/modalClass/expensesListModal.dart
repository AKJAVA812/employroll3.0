class ExpensesListModal {
  List<ClaimRequiDatalist>? claimRequiDatalist;

  ExpensesListModal({this.claimRequiDatalist});

  ExpensesListModal.fromJson(Map<String, dynamic> json) {
    if (json['claimRequiDatalist'] != null) {
      claimRequiDatalist = <ClaimRequiDatalist>[];
      json['claimRequiDatalist'].forEach((v) {
        claimRequiDatalist!.add(ClaimRequiDatalist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (claimRequiDatalist != null) {
      data['claimRequiDatalist'] =
          claimRequiDatalist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClaimRequiDatalist {
  String? empId;
  String? claimNo;
  String? distance;
  String? claimReqId;
  String? fromPlace;
  String? purpose;
  String? branch;
  String? attachment;
  String? empName;
  String? catName;
  String? toPlace;
  String? reimbName;
  String? expId;
  String? expName;
  String? subExpId;
  String? toDate;
  String? dept;
  String? claimId;
  String? billAvail;
  String? claimedAmt;
  String? fromDate;
  String? catId;
  String? policyId;
  String? empGrade;
  String? subName;
  String? reqDate;
  String? remarks;
  String? status;

  ClaimRequiDatalist(
      {this.empId,
        this.claimNo,
        this.distance,
        this.claimReqId,
        this.fromPlace,
        this.purpose,
        this.branch,
        this.attachment,
        this.empName,
        this.catName,
        this.toPlace,
        this.reimbName,
        this.expId,
        this.expName,
        this.subExpId,
        this.toDate,
        this.dept,
        this.claimId,
        this.billAvail,
        this.claimedAmt,
        this.fromDate,
        this.catId,
        this.policyId,
        this.empGrade,
        this.subName,
        this.reqDate,
        this.remarks,
        this.status});

  ClaimRequiDatalist.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    claimNo = json['claimNo'];
    distance = json['distance'];
    claimReqId = json['claimReqId'];
    fromPlace = json['fromPlace'];
    purpose = json['purpose'];
    branch = json['branch'];
    attachment = json['attachment'];
    empName = json['empName'];
    catName = json['catName'];
    toPlace = json['toPlace'];
    reimbName = json['reimbName'];
    expId = json['expId'];
    expName = json['expName'];
    subExpId = json['subExpId'];
    toDate = json['toDate'];
    dept = json['dept'];
    claimId = json['claimId'];
    billAvail = json['billAvail'];
    claimedAmt = json['claimedAmt'];
    fromDate = json['fromDate'];
    catId = json['catId'];
    policyId = json['policyId'];
    empGrade = json['empGrade'];
    subName = json['subName'];
    reqDate = json['ReqDate'];
    remarks = json['remarks'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empId'] = empId;
    data['claimNo'] = claimNo;
    data['distance'] = distance;
    data['claimReqId'] = claimReqId;
    data['fromPlace'] = fromPlace;
    data['purpose'] = purpose;
    data['branch'] = branch;
    data['attachment'] = attachment;
    data['empName'] = empName;
    data['catName'] = catName;
    data['toPlace'] = toPlace;
    data['reimbName'] = reimbName;
    data['expId'] = expId;
    data['expName'] = expName;
    data['subExpId'] = subExpId;
    data['toDate'] = toDate;
    data['dept'] = dept;
    data['claimId'] = claimId;
    data['billAvail'] = billAvail;
    data['claimedAmt'] = claimedAmt;
    data['fromDate'] = fromDate;
    data['catId'] = catId;
    data['policyId'] = policyId;
    data['empGrade'] = empGrade;
    data['subName'] = subName;
    data['ReqDate'] = reqDate;
    data['remarks'] = remarks;
    data['status'] = status;
    return data;
  }
}
