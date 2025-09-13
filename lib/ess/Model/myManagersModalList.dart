class MyManagersModalList {
  List<DottedEmpList>? dottedEmpList;
  List<SharedEmpList>? sharedEmpList;
  List<ListData>? listData;
  List<DirectEmpList>? directEmpList;
  List<DesignatedEmpList>? designatedEmpList;

  MyManagersModalList(
      {this.dottedEmpList,
        this.sharedEmpList,
        this.listData,
        this.directEmpList,
        this.designatedEmpList});

  MyManagersModalList.fromJson(Map<String, dynamic> json) {
    if (json['dottedEmpList'] != null) {
      dottedEmpList = <DottedEmpList>[];
      json['dottedEmpList'].forEach((v) {
        dottedEmpList!.add(new DottedEmpList.fromJson(v));
      });
    }
    if (json['sharedEmpList'] != null) {
      sharedEmpList = <SharedEmpList>[];
      json['sharedEmpList'].forEach((v) {
        sharedEmpList!.add(new SharedEmpList.fromJson(v));
      });
    }
    if (json['listData'] != null) {
      listData = <ListData>[];
      json['listData'].forEach((v) {
        listData!.add(new ListData.fromJson(v));
      });
    }
    if (json['directEmpList'] != null) {
      directEmpList = <DirectEmpList>[];
      json['directEmpList'].forEach((v) {
        directEmpList!.add(new DirectEmpList.fromJson(v));
      });
    }
    if (json['designatedEmpList'] != null) {
      designatedEmpList = <DesignatedEmpList>[];
      json['designatedEmpList'].forEach((v) {
        designatedEmpList!.add(new DesignatedEmpList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dottedEmpList != null) {
      data['dottedEmpList'] =
          this.dottedEmpList!.map((v) => v.toJson()).toList();
    }
    if (this.sharedEmpList != null) {
      data['sharedEmpList'] =
          this.sharedEmpList!.map((v) => v.toJson()).toList();
    }
    if (this.listData != null) {
      data['listData'] = this.listData!.map((v) => v.toJson()).toList();
    }
    if (this.directEmpList != null) {
      data['directEmpList'] =
          this.directEmpList!.map((v) => v.toJson()).toList();
    }
    if (this.designatedEmpList != null) {
      data['designatedEmpList'] =
          this.designatedEmpList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SharedEmpList {
  String? profileName;
  int? reportingOfficerId;
  String? reportingOfficerName;
  String? reportieeStatus;
  String? reportieeType;
  String? emailId;
  int? empDetId;

  SharedEmpList(
      {this.profileName,
        this.reportingOfficerId,
        this.reportingOfficerName,
        this.reportieeStatus,
        this.reportieeType,
        this.emailId,
        this.empDetId});

  SharedEmpList.fromJson(Map<String, dynamic> json) {
    profileName = json['profileName'];
    reportingOfficerId = json['reportingOfficerId'];
    reportingOfficerName = json['reportingOfficerName'];
    reportieeStatus = json['reportieeStatus'];
    reportieeType = json['reportieeType'];
    emailId = json['emailId'];
    empDetId = json['empDetId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profileName'] = this.profileName;
    data['reportingOfficerId'] = this.reportingOfficerId;
    data['reportingOfficerName'] = this.reportingOfficerName;
    data['reportieeStatus'] = this.reportieeStatus;
    data['reportieeType'] = this.reportieeType;
    data['emailId'] = this.emailId;
    data['empDetId'] = this.empDetId;
    return data;
  }
}

class DottedEmpList {
  String? profileName;
  int? reportingOfficerId;
  String? reportingOfficerName;
  String? reportieeStatus;
  String? reportieeType;
  String? emailId;
  int? empDetId;

  DottedEmpList(
      {this.profileName,
        this.reportingOfficerId,
        this.reportingOfficerName,
        this.reportieeStatus,
        this.reportieeType,
        this.emailId,
        this.empDetId});

  DottedEmpList.fromJson(Map<String, dynamic> json) {
    profileName = json['profileName'];
    reportingOfficerId = json['reportingOfficerId'];
    reportingOfficerName = json['reportingOfficerName'];
    reportieeStatus = json['reportieeStatus'];
    reportieeType = json['reportieeType'];
    emailId = json['emailId'];
    empDetId = json['empDetId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profileName'] = this.profileName;
    data['reportingOfficerId'] = this.reportingOfficerId;
    data['reportingOfficerName'] = this.reportingOfficerName;
    data['reportieeStatus'] = this.reportieeStatus;
    data['reportieeType'] = this.reportieeType;
    data['emailId'] = this.emailId;
    data['empDetId'] = this.empDetId;
    return data;
  }
}

class ListData {
  String? profileName;
  int? reportingOfficerId;
  String? reportingOfficerName;
  String? reportieeStatus;
  String? reportieeType;
  String? emailId;
  int? empDetId;

  ListData(
      {this.profileName,
        this.reportingOfficerId,
        this.reportingOfficerName,
        this.reportieeStatus,
        this.reportieeType,
        this.emailId,
        this.empDetId});

  ListData.fromJson(Map<String, dynamic> json) {
    profileName = json['profileName'];
    reportingOfficerId = json['reportingOfficerId'];
    reportingOfficerName = json['reportingOfficerName'];
    reportieeStatus = json['reportieeStatus'];
    reportieeType = json['reportieeType'];
    emailId = json['emailId'];
    empDetId = json['empDetId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profileName'] = this.profileName;
    data['reportingOfficerId'] = this.reportingOfficerId;
    data['reportingOfficerName'] = this.reportingOfficerName;
    data['reportieeStatus'] = this.reportieeStatus;
    data['reportieeType'] = this.reportieeType;
    data['emailId'] = this.emailId;
    data['empDetId'] = this.empDetId;
    return data;
  }
}

class DirectEmpList {
  String? profileName;
  int? reportingOfficerId;
  String? reportingOfficerName;
  String? reportieeStatus;
  String? reportieeType;
  String? emailId;
  int? empDetId;

  DirectEmpList(
      {this.profileName,
        this.reportingOfficerId,
        this.reportingOfficerName,
        this.reportieeStatus,
        this.reportieeType,
        this.emailId,
        this.empDetId});

  DirectEmpList.fromJson(Map<String, dynamic> json) {
    profileName = json['profileName'];
    reportingOfficerId = json['reportingOfficerId'];
    reportingOfficerName = json['reportingOfficerName'];
    reportieeStatus = json['reportieeStatus'];
    reportieeType = json['reportieeType'];
    emailId = json['emailId'];
    empDetId = json['empDetId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profileName'] = this.profileName;
    data['reportingOfficerId'] = this.reportingOfficerId;
    data['reportingOfficerName'] = this.reportingOfficerName;
    data['reportieeStatus'] = this.reportieeStatus;
    data['reportieeType'] = this.reportieeType;
    data['emailId'] = this.emailId;
    data['empDetId'] = this.empDetId;
    return data;
  }
}

class DesignatedEmpList {
  String? profileName;
  int? reportingOfficerId;
  String? reportingOfficerName;
  String? reportieeStatus;
  String? reportieeType;
  String? emailId;
  int? empDetId;

  DesignatedEmpList(
      {this.profileName,
        this.reportingOfficerId,
        this.reportingOfficerName,
        this.reportieeStatus,
        this.reportieeType,
        this.emailId,
        this.empDetId});

  DesignatedEmpList.fromJson(Map<String, dynamic> json) {
    profileName = json['profileName'];
    reportingOfficerId = json['reportingOfficerId'];
    reportingOfficerName = json['reportingOfficerName'];
    reportieeStatus = json['reportieeStatus'];
    reportieeType = json['reportieeType'];
    emailId = json['emailId'];
    empDetId = json['empDetId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profileName'] = this.profileName;
    data['reportingOfficerId'] = this.reportingOfficerId;
    data['reportingOfficerName'] = this.reportingOfficerName;
    data['reportieeStatus'] = this.reportieeStatus;
    data['reportieeType'] = this.reportieeType;
    data['emailId'] = this.emailId;
    data['empDetId'] = this.empDetId;
    return data;
  }
}
