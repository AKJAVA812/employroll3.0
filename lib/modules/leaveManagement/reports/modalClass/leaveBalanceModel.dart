class LeaveBalanceModel {
  List<LeaveTypeListDetails>? leaveTypeListDetails;
  LeaveData? leaveData;

  LeaveBalanceModel({this.leaveTypeListDetails, this.leaveData});

  LeaveBalanceModel.fromJson(Map<String, dynamic> json) {
    if (json['leaveTypeListDetails'] != null) {
      leaveTypeListDetails = <LeaveTypeListDetails>[];
      json['leaveTypeListDetails'].forEach((v) {
        leaveTypeListDetails!.add(LeaveTypeListDetails.fromJson(v));
      });
    }
    leaveData = json['leaveData'] != null
        ? LeaveData.fromJson(json['leaveData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (leaveTypeListDetails != null) {
      data['leaveTypeListDetails'] =
          leaveTypeListDetails!.map((v) => v.toJson()).toList();
    }
    if (leaveData != null) {
      data['leaveData'] = leaveData!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['medCerti'] = medCerti;
    data['leavetype'] = leavetype;
    data['lwpActive'] = lwpActive;
    data['noLwp'] = noLwp;
    data['lwpWithNotification'] = lwpWithNotification;
    data['medValue'] = medValue;
    data['leaveId'] = leaveId;
    data['leaveStatus'] = leaveStatus;
    data['leaveTypecode'] = leaveTypecode;
    data['isHalfday'] = isHalfday;
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
    cL607 = json['CL-607'] != null ? CL607.fromJson(json['CL-607']) : null;
    leaveTypeList = json['leaveTypeList'] != null
        ? LeaveTypeList.fromJson(json['leaveTypeList'])
        : null;
    eL608 = json['EL-608'] != null ? CL607.fromJson(json['EL-608']) : null;
    sL606 = json['SL-606'] != null ? CL607.fromJson(json['SL-606']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cL607 != null) {
      data['CL-607'] = cL607!.toJson();
    }
    if (leaveTypeList != null) {
      data['leaveTypeList'] = leaveTypeList!.toJson();
    }
    if (eL608 != null) {
      data['EL-608'] = eL608!.toJson();
    }
    if (sL606 != null) {
      data['SL-606'] = sL606!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lwp'] = lwp;
    data['leavesTaken'] = leavesTaken;
    data['totalLeavesPending'] = totalLeavesPending;
    data['currentYearLeaves'] = currentYearLeaves;
    data['lastYearLeaves'] = lastYearLeaves;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['leaveTypelist'] = leaveTypelist;
    return data;
  }
}
