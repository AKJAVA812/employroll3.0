class AppDisReimbListModal {
  List<Data>? data;

  AppDisReimbListModal({this.data});

  AppDisReimbListModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
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

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['empId'] = this.empId;
    data['claimNo'] = this.claimNo;
    data['distance'] = this.distance;
    data['claimReqId'] = this.claimReqId;
    data['fromPlace'] = this.fromPlace;
    data['purpose'] = this.purpose;
    data['branch'] = this.branch;
    data['attachment'] = this.attachment;
    data['empName'] = this.empName;
    data['catName'] = this.catName;
    data['toPlace'] = this.toPlace;
    data['reimbName'] = this.reimbName;
    data['expId'] = this.expId;
    data['expName'] = this.expName;
    data['subExpId'] = this.subExpId;
    data['toDate'] = this.toDate;
    data['dept'] = this.dept;
    data['claimId'] = this.claimId;
    data['billAvail'] = this.billAvail;
    data['claimedAmt'] = this.claimedAmt;
    data['fromDate'] = this.fromDate;
    data['catId'] = this.catId;
    data['policyId'] = this.policyId;
    data['empGrade'] = this.empGrade;
    data['subName'] = this.subName;
    data['ReqDate'] = this.reqDate;
    data['remarks'] = this.remarks;
    data['status'] = this.status;
    return data;
  }
}
