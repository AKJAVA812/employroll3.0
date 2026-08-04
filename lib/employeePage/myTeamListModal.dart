class MyTeamsListModal {
  List<DottedEmpList>? dottedEmpList;
  List<SharedEmpList>? sharedEmpList;
  List<ListData>? listData;
  List<DirectEmpList>? directEmpList;
  List<DesignatedEmpList>? designatedEmpList;

  MyTeamsListModal(
      {this.dottedEmpList,
        this.sharedEmpList,
        this.listData,
        this.directEmpList,
        this.designatedEmpList});

  MyTeamsListModal.fromJson(Map<String, dynamic> json) {
    if (json['dottedEmpList'] != null) {
      dottedEmpList = <DottedEmpList>[];
      json['dottedEmpList'].forEach((v) {
        dottedEmpList!.add(DottedEmpList.fromJson(v));
      });
    }
    if (json['sharedEmpList'] != null) {
      sharedEmpList = <SharedEmpList>[];
      json['sharedEmpList'].forEach((v) {
        sharedEmpList!.add(SharedEmpList.fromJson(v));
      });
    }
    if (json['listData'] != null) {
      listData = <ListData>[];
      json['listData'].forEach((v) {
        listData!.add(ListData.fromJson(v));
      });
    }
    if (json['directEmpList'] != null) {
      directEmpList = <DirectEmpList>[];
      json['directEmpList'].forEach((v) {
        directEmpList!.add(DirectEmpList.fromJson(v));
      });
    }
    if (json['designatedEmpList'] != null) {
      designatedEmpList = <DesignatedEmpList>[];
      json['designatedEmpList'].forEach((v) {
        designatedEmpList!.add(DesignatedEmpList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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

class ListData {
  String? profileName;
  int? reportingOfficerId;
  String? empDeptName;
  String? empContact;
  int? empDetId;
  String? empBranchName;
  String? employeeStatus;
  String? empDesignationName;
  String? reportingOfficerName;
  String? empCode;
  String? empName;
  String? reportieeStatus;
  String? empEmailId;
  String? reportieeType;
  String? empPhoto;

  ListData(
      {this.profileName,
        this.reportingOfficerId,
        this.empDeptName,
        this.empContact,
        this.empDetId,
        this.empBranchName,
        this.employeeStatus,
        this.empDesignationName,
        this.reportingOfficerName,
        this.empCode,
        this.empName,
        this.reportieeStatus,
        this.empEmailId,
        this.reportieeType,
        this.empPhoto});

  ListData.fromJson(Map<String, dynamic> json) {
    profileName = json['profileName'];
    reportingOfficerId = json['reportingOfficerId'];
    empDeptName = json['empDeptName'];
    empContact = json['empContact'];
    empDetId = json['empDetId'];
    empBranchName = json['empBranchName'];
    employeeStatus = json['employeeStatus'];
    empDesignationName = json['empDesignationName'];
    reportingOfficerName = json['reportingOfficerName'];
    empCode = json['empCode'];
    empName = json['empName'];
    reportieeStatus = json['reportieeStatus'];
    empEmailId = json['empEmailId'];
    reportieeType = json['reportieeType'];
    empPhoto = json['empPhoto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['profileName'] = this.profileName;
    data['reportingOfficerId'] = this.reportingOfficerId;
    data['empDeptName'] = this.empDeptName;
    data['empContact'] = this.empContact;
    data['empDetId'] = this.empDetId;
    data['empBranchName'] = this.empBranchName;
    data['employeeStatus'] = this.employeeStatus;
    data['empDesignationName'] = this.empDesignationName;
    data['reportingOfficerName'] = this.reportingOfficerName;
    data['empCode'] = this.empCode;
    data['empName'] = this.empName;
    data['reportieeStatus'] = this.reportieeStatus;
    data['empEmailId'] = this.empEmailId;
    data['reportieeType'] = this.reportieeType;
    data['empPhoto'] = this.empPhoto;
    return data;
  }
}

class DottedEmpList {
  String? profileName;
  int? reportingOfficerId;
  String? empDeptName;
  String? empContact;
  int? empDetId;
  String? empBranchName;
  String? employeeStatus;
  String? empDesignationName;
  String? reportingOfficerName;
  String? empCode;
  String? empName;
  String? reportieeStatus;
  String? empEmailId;
  String? reportieeType;
  String? empPhoto;

  DottedEmpList(
      {this.profileName,
        this.reportingOfficerId,
        this.empDeptName,
        this.empContact,
        this.empDetId,
        this.empBranchName,
        this.employeeStatus,
        this.empDesignationName,
        this.reportingOfficerName,
        this.empCode,
        this.empName,
        this.reportieeStatus,
        this.empEmailId,
        this.reportieeType,
        this.empPhoto});

  DottedEmpList.fromJson(Map<String, dynamic> json) {
    profileName = json['profileName'];
    reportingOfficerId = json['reportingOfficerId'];
    empDeptName = json['empDeptName'];
    empContact = json['empContact'];
    empDetId = json['empDetId'];
    empBranchName = json['empBranchName'];
    employeeStatus = json['employeeStatus'];
    empDesignationName = json['empDesignationName'];
    reportingOfficerName = json['reportingOfficerName'];
    empCode = json['empCode'];
    empName = json['empName'];
    reportieeStatus = json['reportieeStatus'];
    empEmailId = json['empEmailId'];
    reportieeType = json['reportieeType'];
    empPhoto = json['empPhoto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['profileName'] = this.profileName;
    data['reportingOfficerId'] = this.reportingOfficerId;
    data['empDeptName'] = this.empDeptName;
    data['empContact'] = this.empContact;
    data['empDetId'] = this.empDetId;
    data['empBranchName'] = this.empBranchName;
    data['employeeStatus'] = this.employeeStatus;
    data['empDesignationName'] = this.empDesignationName;
    data['reportingOfficerName'] = this.reportingOfficerName;
    data['empCode'] = this.empCode;
    data['empName'] = this.empName;
    data['reportieeStatus'] = this.reportieeStatus;
    data['empEmailId'] = this.empEmailId;
    data['reportieeType'] = this.reportieeType;
    data['empPhoto'] = this.empPhoto;
    return data;
  }
}

class DirectEmpList {
  String? profileName;
  int? reportingOfficerId;
  String? empDeptName;
  String? empContact;
  int? empDetId;
  String? empBranchName;
  String? employeeStatus;
  String? empDesignationName;
  String? reportingOfficerName;
  String? empCode;
  String? empName;
  String? reportieeStatus;
  String? empEmailId;
  String? reportieeType;
  String? empPhoto;

  DirectEmpList(
      {this.profileName,
        this.reportingOfficerId,
        this.empDeptName,
        this.empContact,
        this.empDetId,
        this.empBranchName,
        this.employeeStatus,
        this.empDesignationName,
        this.reportingOfficerName,
        this.empCode,
        this.empName,
        this.reportieeStatus,
        this.empEmailId,
        this.reportieeType,
        this.empPhoto,
      });

  DirectEmpList.fromJson(Map<String, dynamic> json) {
    profileName = json['profileName'];
    reportingOfficerId = json['reportingOfficerId'];
    empDeptName = json['empDeptName'];
    empContact = json['empContact'];
    empDetId = json['empDetId'];
    empBranchName = json['empBranchName'];
    employeeStatus = json['employeeStatus'];
    empDesignationName = json['empDesignationName'];
    reportingOfficerName = json['reportingOfficerName'];
    empCode = json['empCode'];
    empName = json['empName'];
    reportieeStatus = json['reportieeStatus'];
    empEmailId = json['empEmailId'];
    reportieeType = json['reportieeType'];
    empPhoto = json['empPhoto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['profileName'] = this.profileName;
    data['reportingOfficerId'] = this.reportingOfficerId;
    data['empDeptName'] = this.empDeptName;
    data['empContact'] = this.empContact;
    data['empDetId'] = this.empDetId;
    data['empBranchName'] = this.empBranchName;
    data['employeeStatus'] = this.employeeStatus;
    data['empDesignationName'] = this.empDesignationName;
    data['reportingOfficerName'] = this.reportingOfficerName;
    data['empCode'] = this.empCode;
    data['empName'] = this.empName;
    data['reportieeStatus'] = this.reportieeStatus;
    data['empEmailId'] = this.empEmailId;
    data['reportieeType'] = this.reportieeType;
    data['empPhoto'] = this.empPhoto;
    return data;
  }
}

class SharedEmpList {
  String? profileName;
  int? reportingOfficerId;
  String? empDeptName;
  String? empContact;
  int? empDetId;
  String? empBranchName;
  String? employeeStatus;
  String? empDesignationName;
  String? reportingOfficerName;
  String? empCode;
  String? empName;
  String? reportieeStatus;
  String? empEmailId;
  String? reportieeType;
  String? empPhoto;

  SharedEmpList(
      {this.profileName,
        this.reportingOfficerId,
        this.empDeptName,
        this.empContact,
        this.empDetId,
        this.empBranchName,
        this.employeeStatus,
        this.empDesignationName,
        this.reportingOfficerName,
        this.empCode,
        this.empName,
        this.reportieeStatus,
        this.empEmailId,
        this.reportieeType,
        this.empPhoto,
      });

  SharedEmpList.fromJson(Map<String, dynamic> json) {
    profileName = json['profileName'];
    reportingOfficerId = json['reportingOfficerId'];
    empDeptName = json['empDeptName'];
    empContact = json['empContact'];
    empDetId = json['empDetId'];
    empBranchName = json['empBranchName'];
    employeeStatus = json['employeeStatus'];
    empDesignationName = json['empDesignationName'];
    reportingOfficerName = json['reportingOfficerName'];
    empCode = json['empCode'];
    empName = json['empName'];
    reportieeStatus = json['reportieeStatus'];
    empEmailId = json['empEmailId'];
    reportieeType = json['reportieeType'];
    empPhoto = json['empPhoto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['profileName'] = this.profileName;
    data['reportingOfficerId'] = this.reportingOfficerId;
    data['empDeptName'] = this.empDeptName;
    data['empContact'] = this.empContact;
    data['empDetId'] = this.empDetId;
    data['empBranchName'] = this.empBranchName;
    data['employeeStatus'] = this.employeeStatus;
    data['empDesignationName'] = this.empDesignationName;
    data['reportingOfficerName'] = this.reportingOfficerName;
    data['empCode'] = this.empCode;
    data['empName'] = this.empName;
    data['reportieeStatus'] = this.reportieeStatus;
    data['empEmailId'] = this.empEmailId;
    data['reportieeType'] = this.reportieeType;
    data['empPhoto'] = this.empPhoto;
    return data;
  }
}

class DesignatedEmpList {
  String? profileName;
  int? reportingOfficerId;
  String? empDeptName;
  String? empContact;
  int? empDetId;
  String? empBranchName;
  String? employeeStatus;
  String? empDesignationName;
  String? reportingOfficerName;
  String? empCode;
  String? empName;
  String? reportieeStatus;
  String? empEmailId;
  String? reportieeType;
  String? empPhoto;

  DesignatedEmpList(
      {this.profileName,
        this.reportingOfficerId,
        this.empDeptName,
        this.empContact,
        this.empDetId,
        this.empBranchName,
        this.employeeStatus,
        this.empDesignationName,
        this.reportingOfficerName,
        this.empCode,
        this.empName,
        this.reportieeStatus,
        this.empEmailId,
        this.reportieeType,
        this.empPhoto,
      });

  DesignatedEmpList.fromJson(Map<String, dynamic> json) {
    profileName = json['profileName'];
    reportingOfficerId = json['reportingOfficerId'];
    empDeptName = json['empDeptName'];
    empContact = json['empContact'];
    empDetId = json['empDetId'];
    empBranchName = json['empBranchName'];
    employeeStatus = json['employeeStatus'];
    empDesignationName = json['empDesignationName'];
    reportingOfficerName = json['reportingOfficerName'];
    empCode = json['empCode'];
    empName = json['empName'];
    reportieeStatus = json['reportieeStatus'];
    empEmailId = json['empEmailId'];
    reportieeType = json['reportieeType'];
    empPhoto = json['empPhoto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['profileName'] = this.profileName;
    data['reportingOfficerId'] = this.reportingOfficerId;
    data['empDeptName'] = this.empDeptName;
    data['empContact'] = this.empContact;
    data['empDetId'] = this.empDetId;
    data['empBranchName'] = this.empBranchName;
    data['employeeStatus'] = this.employeeStatus;
    data['empDesignationName'] = this.empDesignationName;
    data['reportingOfficerName'] = this.reportingOfficerName;
    data['empCode'] = this.empCode;
    data['empName'] = this.empName;
    data['reportieeStatus'] = this.reportieeStatus;
    data['empEmailId'] = this.empEmailId;
    data['reportieeType'] = this.reportieeType;
    data['empPhoto'] = this.empPhoto;
    return data;
  }
}
