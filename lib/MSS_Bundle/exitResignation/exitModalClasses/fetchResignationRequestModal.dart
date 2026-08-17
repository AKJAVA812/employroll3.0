class FetchSingleResignationRequestModal {
  List<DataNew>? data;

  FetchSingleResignationRequestModal({this.data});

  FetchSingleResignationRequestModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataNew>[];
      json['data'].forEach((v) {
        data!.add(DataNew.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['resignDate'] = resignDate;
    data['lastWorkingDate'] = lastWorkingDate;
    data['levelOneRemarks'] = levelOneRemarks;
    data['resignationDate'] = resignationDate;
    data['noticePeriodActive'] = noticePeriodActive;
    data['organisationName'] = organisationName;
    data['levelTwoRemarks'] = levelTwoRemarks;
    data['lwdDate'] = lwdDate;
    data['attachment'] = attachment;
    data['empNameCode'] = empNameCode;
    data['seprationName'] = seprationName;
    data['id'] = id;
    data['noticeperiod'] = noticeperiod;
    data['remarks'] = remarks;
    data['reasonForLeave'] = reasonForLeave;
    return data;
  }
}
