class ReportingOfficerListModal {
  List<ListData>? listData;

  ReportingOfficerListModal({this.listData});

  ReportingOfficerListModal.fromJson(Map<String, dynamic> json) {
    if (json['listData'] != null) {
      listData = <ListData>[];
      json['listData'].forEach((v) {
        listData!.add(new ListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listData != null) {
      data['listData'] = this.listData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListData {
  int? reportingOfficerId;
  String? reportingOfficerName;
  String? reportieeType;
  String? emailId;
  int? empDetId;

  ListData(
      {this.reportingOfficerId,
        this.reportingOfficerName,
        this.reportieeType,
        this.emailId,
        this.empDetId});

  ListData.fromJson(Map<String, dynamic> json) {
    reportingOfficerId = json['reportingOfficerId'];
    reportingOfficerName = json['reportingOfficerName'];
    reportieeType = json['reportieeType'];
    emailId = json['emailId'];
    empDetId = json['empDetId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reportingOfficerId'] = this.reportingOfficerId;
    data['reportingOfficerName'] = this.reportingOfficerName;
    data['reportieeType'] = this.reportieeType;
    data['emailId'] = this.emailId;
    data['empDetId'] = this.empDetId;
    return data;
  }
}
