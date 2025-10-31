class FetchSingleResignationRequestModal {
  List<DataNew>? data;

  FetchSingleResignationRequestModal({this.data});

  FetchSingleResignationRequestModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataNew>[];
      json['data'].forEach((v) {
        data!.add(new DataNew.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataNew {
  String? resignDate;
  String? lastWorkingDate;
  String? levelOneRemarks;
  String? resignationDate;
  bool? noticePeriodActive;
  String? organisationName;
  String? levelTwoRemarks;
  String? lwdDate;
  String? attachment;
  String? empNameCode;
  String? seprationName;
  int? id;
  dynamic noticeperiod;
  String? remarks;
  String? reasonForLeave;

  DataNew(
      {this.resignDate,
        this.lastWorkingDate,
        this.levelOneRemarks,
        this.resignationDate,
        this.noticePeriodActive,
        this.organisationName,
        this.levelTwoRemarks,
        this.lwdDate,
        this.attachment,
        this.empNameCode,
        this.seprationName,
        this.id,
        this.noticeperiod,
        this.remarks,
        this.reasonForLeave});

  DataNew.fromJson(Map<String, dynamic> json) {
    resignDate = json['resignDate'];
    lastWorkingDate = json['lastWorkingDate'];
    levelOneRemarks = json['levelOneRemarks'];
    resignationDate = json['resignationDate'];
    noticePeriodActive = json['noticePeriodActive'];
    organisationName = json['organisationName'];
    levelTwoRemarks = json['levelTwoRemarks'];
    lwdDate = json['lwdDate'];
    attachment = json['attachment'];
    empNameCode = json['empNameCode'];
    seprationName = json['seprationName'];
    id = json['id'];
    noticeperiod = json['noticeperiod'];
    remarks = json['remarks'];
    reasonForLeave = json['reasonForLeave'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resignDate'] = this.resignDate;
    data['lastWorkingDate'] = this.lastWorkingDate;
    data['levelOneRemarks'] = this.levelOneRemarks;
    data['resignationDate'] = this.resignationDate;
    data['noticePeriodActive'] = this.noticePeriodActive;
    data['organisationName'] = this.organisationName;
    data['levelTwoRemarks'] = this.levelTwoRemarks;
    data['lwdDate'] = this.lwdDate;
    data['attachment'] = this.attachment;
    data['empNameCode'] = this.empNameCode;
    data['seprationName'] = this.seprationName;
    data['id'] = this.id;
    data['noticeperiod'] = this.noticeperiod;
    data['remarks'] = this.remarks;
    data['reasonForLeave'] = this.reasonForLeave;
    return data;
  }
}
