class LeaveBalanceModel {
  List<LeaveTypeListDetails>? leaveTypeListDetails;
  LeaveData? leaveData;

  LeaveBalanceModel({this.leaveTypeListDetails, this.leaveData});

  LeaveBalanceModel.fromJson(Map<String, dynamic> json) {
    if (json['leaveTypeListDetails'] != null) {
      leaveTypeListDetails = <LeaveTypeListDetails>[];
      json['leaveTypeListDetails'].forEach((v) {
        leaveTypeListDetails!.add(new LeaveTypeListDetails.fromJson(v));
      });
    }
    leaveData = json['leaveData'] != null
        ? new LeaveData.fromJson(json['leaveData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.leaveTypeListDetails != null) {
      data['leaveTypeListDetails'] =
          this.leaveTypeListDetails!.map((v) => v.toJson()).toList();
    }
    if (this.leaveData != null) {
      data['leaveData'] = this.leaveData!.toJson();
    }
    return data;
  }
}

class LeaveTypeListDetails {
  bool? medCerti;
  String? leavetype;
  bool? lwpActive;
  bool? noLwp;
  bool? lwpWithNotification;
  int? medValue;
  int? leaveId;
  String? leaveStatus;
  String? leaveTypecode;
  bool? isHalfday;

  LeaveTypeListDetails(
      {this.medCerti,
        this.leavetype,
        this.lwpActive,
        this.noLwp,
        this.lwpWithNotification,
        this.medValue,
        this.leaveId,
        this.leaveStatus,
        this.leaveTypecode,
        this.isHalfday});

  LeaveTypeListDetails.fromJson(Map<String, dynamic> json) {
    medCerti = json['medCerti'];
    leavetype = json['leavetype'];
    lwpActive = json['lwpActive'];
    noLwp = json['noLwp'];
    lwpWithNotification = json['lwpWithNotification'];
    medValue = json['medValue'];
    leaveId = json['leaveId'];
    leaveStatus = json['leaveStatus'];
    leaveTypecode = json['leaveTypecode'];
    isHalfday = json['isHalfday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medCerti'] = this.medCerti;
    data['leavetype'] = this.leavetype;
    data['lwpActive'] = this.lwpActive;
    data['noLwp'] = this.noLwp;
    data['lwpWithNotification'] = this.lwpWithNotification;
    data['medValue'] = this.medValue;
    data['leaveId'] = this.leaveId;
    data['leaveStatus'] = this.leaveStatus;
    data['leaveTypecode'] = this.leaveTypecode;
    data['isHalfday'] = this.isHalfday;
    return data;
  }
}

class LeaveData {
  CL607? cL607;
  LeaveTypeList? leaveTypeList;
  CL607? eL608;
  CL607? sL606;

  LeaveData({this.cL607, this.leaveTypeList, this.eL608, this.sL606});

  LeaveData.fromJson(Map<String, dynamic> json) {
    cL607 = json['CL-607'] != null ? new CL607.fromJson(json['CL-607']) : null;
    leaveTypeList = json['leaveTypeList'] != null
        ? new LeaveTypeList.fromJson(json['leaveTypeList'])
        : null;
    eL608 = json['EL-608'] != null ? new CL607.fromJson(json['EL-608']) : null;
    sL606 = json['SL-606'] != null ? new CL607.fromJson(json['SL-606']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cL607 != null) {
      data['CL-607'] = this.cL607!.toJson();
    }
    if (this.leaveTypeList != null) {
      data['leaveTypeList'] = this.leaveTypeList!.toJson();
    }
    if (this.eL608 != null) {
      data['EL-608'] = this.eL608!.toJson();
    }
    if (this.sL606 != null) {
      data['SL-606'] = this.sL606!.toJson();
    }
    return data;
  }
}

class CL607 {
  var lwp;
  var leavesTaken;
  var totalLeavesPending;
  var currentYearLeaves;
  var lastYearLeaves;

  CL607(
      {this.lwp,
        this.leavesTaken,
        this.totalLeavesPending,
        this.currentYearLeaves,
        this.lastYearLeaves});

  CL607.fromJson(Map<String, dynamic> json) {
    lwp = json['lwp'];
    leavesTaken = json['leavesTaken'];
    totalLeavesPending = json['totalLeavesPending'];
    currentYearLeaves = json['currentYearLeaves'];
    lastYearLeaves = json['lastYearLeaves'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lwp'] = this.lwp;
    data['leavesTaken'] = this.leavesTaken;
    data['totalLeavesPending'] = this.totalLeavesPending;
    data['currentYearLeaves'] = this.currentYearLeaves;
    data['lastYearLeaves'] = this.lastYearLeaves;
    return data;
  }
}

class LeaveTypeList {
  List<String>? leaveTypelist;

  LeaveTypeList({this.leaveTypelist});

  LeaveTypeList.fromJson(Map<String, dynamic> json) {
    leaveTypelist = json['leaveTypelist'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leaveTypelist'] = this.leaveTypelist;
    return data;
  }
}
