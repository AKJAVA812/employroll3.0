class LeaveBalModal {
  LeaveData? leaveData;

  LeaveBalModal({this.leaveData});

  LeaveBalModal.fromJson(Map<String, dynamic> json) {
    leaveData = json['leaveData'] != null
        ? new LeaveData.fromJson(json['leaveData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.leaveData != null) {
      data['leaveData'] = this.leaveData!.toJson();
    }
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
  dynamic lwp;
  dynamic leavesTaken;
  dynamic totalLeavesPending;
  dynamic currentYearLeaves;
  dynamic lastYearLeaves;

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
