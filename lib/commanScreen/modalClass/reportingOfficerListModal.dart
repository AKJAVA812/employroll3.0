class ReportingOfficerListModal {
  List<ListData>? listData;

  ReportingOfficerListModal({this.listData});

  ReportingOfficerListModal.fromJson(Map<String, dynamic> json) {
    if (json['listData'] != null) {
      listData = <ListData>[];
      json['listData'].forEach((v) {
        listData!.add(ListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (listData != null) {
      data['listData'] = listData!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reportingOfficerId'] = reportingOfficerId;
    data['reportingOfficerName'] = reportingOfficerName;
    data['reportieeType'] = reportieeType;
    data['emailId'] = emailId;
    data['empDetId'] = empDetId;
    return data;
  }
}
