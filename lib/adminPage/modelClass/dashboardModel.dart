class DashboardModel {
  List<MispunchEmpSEt>? mispunchEmpSEt;
  List<EarlyOutList>? earlyOutList;
  List<PresentEmp>? presentEmp;
  List<LateInList>? lateInList;
  int? mispunchEmp;
  List<AbsentEmp>? absentEmp;
  int? totalAbsentEmp;
  int? lateInEmp;
  int? workingEmp;
  List<HalfDayEmpSet>? halfDayEmpSet;
  List<OtEmpList>? otEmpList;
  String? result;
  int? otEmp;
  int? totalEmp;
  int? earlyOutEmp;
  int? halfEmp;
  List<WorkingList>? workingList;
  int? totalPresentEmp;

  DashboardModel(
      {this.mispunchEmpSEt,
        this.earlyOutList,
        this.presentEmp,
        this.lateInList,
        this.mispunchEmp,
        this.absentEmp,
        this.totalAbsentEmp,
        this.lateInEmp,
        this.workingEmp,
        this.halfDayEmpSet,
        this.otEmpList,
        this.result,
        this.otEmp,
        this.totalEmp,
        this.earlyOutEmp,
        this.halfEmp,
        this.workingList,
        this.totalPresentEmp});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    if (json['mispunchEmpSEt'] != null) {
      mispunchEmpSEt = <MispunchEmpSEt>[];
      json['mispunchEmpSEt'].forEach((v) {
        mispunchEmpSEt!.add(new MispunchEmpSEt.fromJson(v));
      });
    }
    if (json['earlyOutList'] != null) {
      earlyOutList = <EarlyOutList>[];
      json['earlyOutList'].forEach((v) {
        earlyOutList!.add(new EarlyOutList.fromJson(v));
      });
    }
    if (json['presentEmp'] != null) {
      presentEmp = <PresentEmp>[];
      json['presentEmp'].forEach((v) {
        presentEmp!.add(new PresentEmp.fromJson(v));
      });
    }
    if (json['lateInList'] != null) {
      lateInList = <LateInList>[];
      json['lateInList'].forEach((v) {
        lateInList!.add(new LateInList.fromJson(v));
      });
    }
    mispunchEmp = json['mispunchEmp'];
    if (json['absentEmp'] != null) {
      absentEmp = <AbsentEmp>[];
      json['absentEmp'].forEach((v) {
        absentEmp!.add(new AbsentEmp.fromJson(v));
      });
    }
    totalAbsentEmp = json['totalAbsentEmp'];
    lateInEmp = json['lateInEmp'];
    workingEmp = json['workingEmp'];
    if (json['halfDayEmpSet'] != null) {
      halfDayEmpSet = <HalfDayEmpSet>[];
      json['halfDayEmpSet'].forEach((v) {
        halfDayEmpSet!.add(new HalfDayEmpSet.fromJson(v));
      });
    }
    if (json['otEmpList'] != null) {
      otEmpList = <OtEmpList>[];
      json['otEmpList'].forEach((v) {
        otEmpList!.add(new OtEmpList.fromJson(v));
      });
    }
    result = json['result'];
    otEmp = json['otEmp'];
    totalEmp = json['totalEmp'];
    earlyOutEmp = json['earlyOutEmp'];
    halfEmp = json['halfEmp'];
    if (json['workingList'] != null) {
      workingList = <WorkingList>[];
      json['workingList'].forEach((v) {
        workingList!.add(new WorkingList.fromJson(v));
      });
    }
    totalPresentEmp = json['totalPresentEmp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mispunchEmpSEt != null) {
      data['mispunchEmpSEt'] =
          this.mispunchEmpSEt!.map((v) => v.toJson()).toList();
    }
    if (this.earlyOutList != null) {
      data['earlyOutList'] = this.earlyOutList!.map((v) => v.toJson()).toList();
    }
    if (this.presentEmp != null) {
      data['presentEmp'] = this.presentEmp!.map((v) => v.toJson()).toList();
    }
    if (this.lateInList != null) {
      data['lateInList'] = this.lateInList!.map((v) => v.toJson()).toList();
    }
    data['mispunchEmp'] = this.mispunchEmp;
    if (this.absentEmp != null) {
      data['absentEmp'] = this.absentEmp!.map((v) => v.toJson()).toList();
    }
    data['totalAbsentEmp'] = this.totalAbsentEmp;
    data['lateInEmp'] = this.lateInEmp;
    data['workingEmp'] = this.workingEmp;
    if (this.halfDayEmpSet != null) {
      data['halfDayEmpSet'] =
          this.halfDayEmpSet!.map((v) => v.toJson()).toList();
    }
    if (this.otEmpList != null) {
      data['otEmpList'] = this.otEmpList!.map((v) => v.toJson()).toList();
    }
    data['result'] = this.result;
    data['otEmp'] = this.otEmp;
    data['totalEmp'] = this.totalEmp;
    data['earlyOutEmp'] = this.earlyOutEmp;
    data['halfEmp'] = this.halfEmp;
    if (this.workingList != null) {
      data['workingList'] = this.workingList!.map((v) => v.toJson()).toList();
    }
    data['totalPresentEmp'] = this.totalPresentEmp;
    return data;
  }
}

class MispunchEmpSEt {
  String? empId;
  String? date;
  String? deptName;
  String? shiftInTime;
  String? outPunchType;
  String? distance;
  String? inPunchType;
  String? workHours;
  String? empEmail;
  String? mobStatus;
  String? otHrs;
  String? contact;
  String? branchN;
  String? workingHours;
  String? empCompStatus;
  String? empPhoto;
  String? branchId;
  String? employeeName;
  String? deptId;
  String? branchName;
  String? inTime;
  String? lateTime;
  String? empDetailsId;
  String? empDetailId;
  Null? remarks;
  String? outTime;

  MispunchEmpSEt(
      {this.empId,
        this.deptName,
        this.date,
        this.shiftInTime,
        this.outPunchType,
        this.distance,
        this.inPunchType,
        this.workHours,
        this.empEmail,
        this.mobStatus,
        this.otHrs,
        this.contact,
        this.branchN,
        this.workingHours,
        this.empCompStatus,
        this.empPhoto,
        this.branchId,
        this.employeeName,
        this.deptId,
        this.branchName,
        this.inTime,
        this.lateTime,
        this.empDetailsId,
        this.empDetailId,
        this.remarks,
        this.outTime});

  MispunchEmpSEt.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    date = json['date'];
    deptName = json['deptName'];
    shiftInTime = json['shiftInTime'];
    outPunchType = json['outPunchType'];
    distance = json['distance'];
    inPunchType = json['inPunchType'];
    workHours = json['workHours'];
    empEmail = json['empEmail'];
    mobStatus = json['mobStatus'];
    otHrs = json['otHrs'];
    contact = json['contact'];
    branchN = json['branchN'];
    workingHours = json['workingHours'];
    empCompStatus = json['empCompStatus'];
    empPhoto = json['empPhoto'];
    branchId = json['branchId'];
    employeeName = json['employeeName'];
    deptId = json['deptId'];
    branchName = json['branchName'];
    inTime = json['inTime'];
    lateTime = json['lateTime'];
    empDetailsId = json['empDetailsId'];
    empDetailId = json['empDetailId'];
    remarks = json['remarks'];
    outTime = json['outTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['date'] = this.date;
    data['deptName'] = this.deptName;
    data['shiftInTime'] = this.shiftInTime;
    data['outPunchType'] = this.outPunchType;
    data['distance'] = this.distance;
    data['inPunchType'] = this.inPunchType;
    data['workHours'] = this.workHours;
    data['empEmail'] = this.empEmail;
    data['mobStatus'] = this.mobStatus;
    data['otHrs'] = this.otHrs;
    data['contact'] = this.contact;
    data['branchN'] = this.branchN;
    data['workingHours'] = this.workingHours;
    data['empCompStatus'] = this.empCompStatus;
    data['empPhoto'] = this.empPhoto;
    data['branchId'] = this.branchId;
    data['employeeName'] = this.employeeName;
    data['deptId'] = this.deptId;
    data['branchName'] = this.branchName;
    data['inTime'] = this.inTime;
    data['lateTime'] = this.lateTime;
    data['empDetailsId'] = this.empDetailsId;
    data['empDetailId'] = this.empDetailId;
    data['remarks'] = this.remarks;
    data['outTime'] = this.outTime;
    return data;
  }
}

class EarlyOutList {
  String? empId;
  String? date;
  String? deptName;
  String? shiftInTime;
  String? outPunchType;
  String? distance;
  String? inPunchType;
  String? workHours;
  String? empEmail;
  String? mobStatus;
  String? otHrs;
  String? contact;
  String? branchN;
  String? workingHours;
  String? empCompStatus;
  String? empPhoto;
  String? branchId;
  String? employeeName;
  String? earlyTime;
  String? deptId;
  String? branchName;
  String? inTime;
  String? lateTime;
  String? empDetailsId;
  String? empDetailId;
  String? remarks;
  String? outTime;

  EarlyOutList(
      {this.empId,
      this.date,
        this.deptName,
        this.shiftInTime,
        this.outPunchType,
        this.distance,
        this.inPunchType,
        this.workHours,
        this.empEmail,
        this.mobStatus,
        this.otHrs,
        this.contact,
        this.branchN,
        this.workingHours,
        this.empCompStatus,
        this.empPhoto,
        this.branchId,
        this.employeeName,
        this.earlyTime,
        this.deptId,
        this.branchName,
        this.inTime,
        this.lateTime,
        this.empDetailsId,
        this.empDetailId,
        this.remarks,
        this.outTime});

  EarlyOutList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    date = json['date'];
    deptName = json['deptName'];
    shiftInTime = json['shiftInTime'];
    outPunchType = json['outPunchType'];
    distance = json['distance'];
    inPunchType = json['inPunchType'];
    workHours = json['workHours'];
    empEmail = json['empEmail'];
    mobStatus = json['mobStatus'];
    otHrs = json['otHrs'];
    contact = json['contact'];
    branchN = json['branchN'];
    workingHours = json['workingHours'];
    empCompStatus = json['empCompStatus'];
    empPhoto = json['empPhoto'];
    branchId = json['branchId'];
    employeeName = json['employeeName'];
    earlyTime = json['earlyTime'];
    deptId = json['deptId'];
    branchName = json['branchName'];
    inTime = json['inTime'];
    lateTime = json['lateTime'];
    empDetailsId = json['empDetailsId'];
    empDetailId = json['empDetailId'];
    remarks = json['remarks'];
    outTime = json['outTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['date'] = this.date;
    data['deptName'] = this.deptName;
    data['shiftInTime'] = this.shiftInTime;
    data['outPunchType'] = this.outPunchType;
    data['distance'] = this.distance;
    data['inPunchType'] = this.inPunchType;
    data['workHours'] = this.workHours;
    data['empEmail'] = this.empEmail;
    data['mobStatus'] = this.mobStatus;
    data['otHrs'] = this.otHrs;
    data['contact'] = this.contact;
    data['branchN'] = this.branchN;
    data['workingHours'] = this.workingHours;
    data['empCompStatus'] = this.empCompStatus;
    data['empPhoto'] = this.empPhoto;
    data['branchId'] = this.branchId;
    data['employeeName'] = this.employeeName;
    data['earlyTime'] = this.earlyTime;
    data['deptId'] = this.deptId;
    data['branchName'] = this.branchName;
    data['inTime'] = this.inTime;
    data['lateTime'] = this.lateTime;
    data['empDetailsId'] = this.empDetailsId;
    data['empDetailId'] = this.empDetailId;
    data['remarks'] = this.remarks;
    data['outTime'] = this.outTime;
    return data;
  }
}

class WorkingList {
  String? empId;
  String? date;
  String? deptName;
  String? shiftInTime;
  String? outPunchType;
  String? distance;
  String? inPunchType;
  String? workHours;
  String? empEmail;
  String? mobStatus;
  String? otHrs;
  String? contact;
  String? branchN;
  String? workingHours;
  String? empCompStatus;
  String? empPhoto;
  String? branchId;
  String? employeeName;
  String? deptId;
  String? branchName;
  String? inTime;
  String? lateTime;
  String? empDetailsId;
  String? empDetailId;
  Null? remarks;
  String? outTime;

  WorkingList({this.empId,
    this.date,
    this.deptName,
    this.shiftInTime,
    this.outPunchType,
    this.distance,
    this.inPunchType,
    this.workHours,
    this.empEmail,
    this.mobStatus,
    this.otHrs,
    this.contact,
    this.branchN,
    this.workingHours,
    this.empCompStatus,
    this.empPhoto,
    this.branchId,
    this.employeeName,
    this.deptId,
    this.branchName,
    this.inTime,
    this.lateTime,
    this.empDetailsId,
    this.empDetailId,
    this.remarks,
    this.outTime});

  WorkingList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    date = json['date'];
    deptName = json['deptName'];
    shiftInTime = json['shiftInTime'];
    outPunchType = json['outPunchType'];
    distance = json['distance'];
    inPunchType = json['inPunchType'];
    workHours = json['workHours'];
    empEmail = json['empEmail'];
    mobStatus = json['mobStatus'];
    otHrs = json['otHrs'];
    contact = json['contact'];
    branchN = json['branchN'];
    workingHours = json['workingHours'];
    empCompStatus = json['empCompStatus'];
    empPhoto = json['empPhoto'];
    branchId = json['branchId'];
    employeeName = json['employeeName'];
    deptId = json['deptId'];
    branchName = json['branchName'];
    inTime = json['inTime'];
    lateTime = json['lateTime'];
    empDetailsId = json['empDetailsId'];
    empDetailId = json['empDetailId'];
    remarks = json['remarks'];
    outTime = json['outTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['date'] = this.date;
    data['deptName'] = this.deptName;
    data['shiftInTime'] = this.shiftInTime;
    data['outPunchType'] = this.outPunchType;
    data['distance'] = this.distance;
    data['inPunchType'] = this.inPunchType;
    data['workHours'] = this.workHours;
    data['empEmail'] = this.empEmail;
    data['mobStatus'] = this.mobStatus;
    data['otHrs'] = this.otHrs;
    data['contact'] = this.contact;
    data['branchN'] = this.branchN;
    data['workingHours'] = this.workingHours;
    data['empCompStatus'] = this.empCompStatus;
    data['empPhoto'] = this.empPhoto;
    data['branchId'] = this.branchId;
    data['employeeName'] = this.employeeName;
    data['deptId'] = this.deptId;
    data['branchName'] = this.branchName;
    data['inTime'] = this.inTime;
    data['lateTime'] = this.lateTime;
    data['empDetailsId'] = this.empDetailsId;
    data['empDetailId'] = this.empDetailId;
    data['remarks'] = this.remarks;
    data['outTime'] = this.outTime;
    return data;
  }
}

class LateInList {
  String? empId;
  String? date;
  String? deptName;
  String? shiftInTime;
  String? outPunchType;
  String? distance;
  String? inPunchType;
  String? empEmail;
  String? mobStatus;
  String? otHrs;
  String? contact;
  String? branchN;
  String? workingHours;
  String? empCompStatus;
  String? empPhoto;
  String? branchId;
  String? employeeName;
  String? earlyTime;
  String? deptId;
  String? branchName;
  String? inTime;
  String? lateTime;
  String? empDetailsId;
  String? empDetailId;
  dynamic remarks;
  String? outTime;
  String? workHours;

  LateInList(
      {this.empId,
        this.date,
        this.deptName,
        this.shiftInTime,
        this.outPunchType,
        this.distance,
        this.inPunchType,
        this.empEmail,
        this.mobStatus,
        this.otHrs,
        this.contact,
        this.branchN,
        this.workingHours,
        this.empCompStatus,
        this.empPhoto,
        this.branchId,
        this.employeeName,
        this.earlyTime,
        this.deptId,
        this.branchName,
        this.inTime,
        this.lateTime,
        this.empDetailsId,
        this.empDetailId,
        this.remarks,
        this.outTime,
        this.workHours});

  LateInList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    date = json['date'];
    deptName = json['deptName'];
    shiftInTime = json['shiftInTime'];
    outPunchType = json['outPunchType'];
    distance = json['distance'];
    inPunchType = json['inPunchType'];
    empEmail = json['empEmail'];
    mobStatus = json['mobStatus'];
    otHrs = json['otHrs'];
    contact = json['contact'];
    branchN = json['branchN'];
    workingHours = json['workingHours'];
    empCompStatus = json['empCompStatus'];
    empPhoto = json['empPhoto'];
    branchId = json['branchId'];
    employeeName = json['employeeName'];
    earlyTime = json['earlyTime'];
    deptId = json['deptId'];
    branchName = json['branchName'];
    inTime = json['inTime'];
    lateTime = json['lateTime'];
    empDetailsId = json['empDetailsId'];
    empDetailId = json['empDetailId'];
    remarks = json['remarks'];
    outTime = json['outTime'];
    workHours = json['workHours'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['date'] = this.date;
    data['deptName'] = this.deptName;
    data['shiftInTime'] = this.shiftInTime;
    data['outPunchType'] = this.outPunchType;
    data['distance'] = this.distance;
    data['inPunchType'] = this.inPunchType;
    data['empEmail'] = this.empEmail;
    data['mobStatus'] = this.mobStatus;
    data['otHrs'] = this.otHrs;
    data['contact'] = this.contact;
    data['branchN'] = this.branchN;
    data['workingHours'] = this.workingHours;
    data['empCompStatus'] = this.empCompStatus;
    data['empPhoto'] = this.empPhoto;
    data['branchId'] = this.branchId;
    data['employeeName'] = this.employeeName;
    data['earlyTime'] = this.earlyTime;
    data['deptId'] = this.deptId;
    data['branchName'] = this.branchName;
    data['inTime'] = this.inTime;
    data['lateTime'] = this.lateTime;
    data['empDetailsId'] = this.empDetailsId;
    data['empDetailId'] = this.empDetailId;
    data['remarks'] = this.remarks;
    data['outTime'] = this.outTime;
    data['workHours'] = this.workHours;
    return data;
  }
}

class PresentEmp {
  String? empId;
  String? date;
  String? deptName;
  String? shiftInTime;
  String? outPunchType;
  String? distance;
  String? inPunchType;
  String? empEmail;
  String? mobStatus;
  String? otHrs;
  String? contact;
  String? branchN;
  String? workingHours;
  String? empCompStatus;
  String? empPhoto;
  String? branchId;
  String? employeeName;
  String? earlyTime;
  String? deptId;
  String? branchName;
  String? inTime;
  String? lateTime;
  String? empDetailsId;
  String? empDetailId;
  String? remarks;
  String? outTime;
  String? workHours;

  PresentEmp(
      {this.empId,
        this.date,
        this.deptName,
        this.shiftInTime,
        this.outPunchType,
        this.distance,
        this.inPunchType,
        this.empEmail,
        this.mobStatus,
        this.otHrs,
        this.contact,
        this.branchN,
        this.workingHours,
        this.empCompStatus,
        this.empPhoto,
        this.branchId,
        this.employeeName,
        this.earlyTime,
        this.deptId,
        this.branchName,
        this.inTime,
        this.lateTime,
        this.empDetailsId,
        this.empDetailId,
        this.remarks,
        this.outTime,
        this.workHours});

  PresentEmp.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    date = json['date'];
    deptName = json['deptName'];
    shiftInTime = json['shiftInTime'];
    outPunchType = json['outPunchType'];
    distance = json['distance'];
    inPunchType = json['inPunchType'];
    empEmail = json['empEmail'];
    mobStatus = json['mobStatus'];
    otHrs = json['otHrs'];
    contact = json['contact'];
    branchN = json['branchN'];
    workingHours = json['workingHours'];
    empCompStatus = json['empCompStatus'];
    empPhoto = json['empPhoto'];
    branchId = json['branchId'];
    employeeName = json['employeeName'];
    earlyTime = json['earlyTime'];
    deptId = json['deptId'];
    branchName = json['branchName'];
    inTime = json['inTime'];
    lateTime = json['lateTime'];
    empDetailsId = json['empDetailsId'];
    empDetailId = json['empDetailId'];
    remarks = json['remarks'];
    outTime = json['outTime'];
    workHours = json['workHours'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['date'] = this.date;
    data['deptName'] = this.deptName;
    data['shiftInTime'] = this.shiftInTime;
    data['outPunchType'] = this.outPunchType;
    data['distance'] = this.distance;
    data['inPunchType'] = this.inPunchType;
    data['empEmail'] = this.empEmail;
    data['mobStatus'] = this.mobStatus;
    data['otHrs'] = this.otHrs;
    data['contact'] = this.contact;
    data['branchN'] = this.branchN;
    data['workingHours'] = this.workingHours;
    data['empCompStatus'] = this.empCompStatus;
    data['empPhoto'] = this.empPhoto;
    data['branchId'] = this.branchId;
    data['employeeName'] = this.employeeName;
    data['earlyTime'] = this.earlyTime;
    data['deptId'] = this.deptId;
    data['branchName'] = this.branchName;
    data['inTime'] = this.inTime;
    data['lateTime'] = this.lateTime;
    data['empDetailsId'] = this.empDetailsId;
    data['empDetailId'] = this.empDetailId;
    data['remarks'] = this.remarks;
    data['outTime'] = this.outTime;
    data['workHours'] = this.workHours;
    return data;
  }
}

class AbsentEmp {
  String? status;
  String? date;
  String? reason;
  String? empId;
  String? branchId;
  String? employeeName;
  String? deptName;
  String? distance;
  String? empEmail;
  String? deptId;
  String? branchName;
  String? mobStatus;
  String? contact;
  String? branchN;
  String? empDetailsId;
  String? empDetailId;
  String? empCompStatus;
  String? empPhoto;

  AbsentEmp(
      {this.status,
        this.date,
        this.reason,
        this.empId,
        this.branchId,
        this.employeeName,
        this.deptName,
        this.distance,
        this.empEmail,
        this.deptId,
        this.branchName,
        this.mobStatus,
        this.contact,
        this.branchN,
        this.empDetailsId,
        this.empDetailId,
        this.empCompStatus,
        this.empPhoto});

  AbsentEmp.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    date = json['date'];
    reason = json['reason'];
    empId = json['empId'];
    branchId = json['branchId'];
    employeeName = json['employeeName'];
    deptName = json['deptName'];
    distance = json['distance'];
    empEmail = json['empEmail'];
    deptId = json['deptId'];
    branchName = json['branchName'];
    mobStatus = json['mobStatus'];
    contact = json['contact'];
    branchN = json['branchN'];
    empDetailsId = json['empDetailsId'];
    empDetailId = json['empDetailId'];
    empCompStatus = json['empCompStatus'];
    empPhoto = json['empPhoto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['date'] = this.date;
    data['reason'] = this.reason;
    data['empId'] = this.empId;
    data['branchId'] = this.branchId;
    data['employeeName'] = this.employeeName;
    data['deptName'] = this.deptName;
    data['distance'] = this.distance;
    data['empEmail'] = this.empEmail;
    data['deptId'] = this.deptId;
    data['branchName'] = this.branchName;
    data['mobStatus'] = this.mobStatus;
    data['contact'] = this.contact;
    data['branchN'] = this.branchN;
    data['empDetailsId'] = this.empDetailsId;
    data['empDetailId'] = this.empDetailId;
    data['empCompStatus'] = this.empCompStatus;
    data['empPhoto'] = this.empPhoto;
    return data;
  }
}

class OtEmpList {
  String? empId;
  String? date;
  String? deptName;
  String? shiftInTime;
  String? outPunchType;
  String? distance;
  String? inPunchType;
  String? empEmail;
  String? mobStatus;
  String? otHrs;
  String? contact;
  String? branchN;
  String? workingHours;
  String? empCompStatus;
  String? empPhoto;
  String? branchId;
  String? employeeName;
  String? earlyTime;
  String? deptId;
  String? branchName;
  String? inTime;
  String? lateTime;
  String? empDetailsId;
  String? empDetailId;
  Null? remarks;
  String? outTime;

  OtEmpList(
      {this.empId,
        this.date,
        this.deptName,
        this.shiftInTime,
        this.outPunchType,
        this.distance,
        this.inPunchType,
        this.empEmail,
        this.mobStatus,
        this.otHrs,
        this.contact,
        this.branchN,
        this.workingHours,
        this.empCompStatus,
        this.empPhoto,
        this.branchId,
        this.employeeName,
        this.earlyTime,
        this.deptId,
        this.branchName,
        this.inTime,
        this.lateTime,
        this.empDetailsId,
        this.empDetailId,
        this.remarks,
        this.outTime});

  OtEmpList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    date = json['date'];
    deptName = json['deptName'];
    shiftInTime = json['shiftInTime'];
    outPunchType = json['outPunchType'];
    distance = json['distance'];
    inPunchType = json['inPunchType'];
    empEmail = json['empEmail'];
    mobStatus = json['mobStatus'];
    otHrs = json['otHrs'];
    contact = json['contact'];
    branchN = json['branchN'];
    workingHours = json['workingHours'];
    empCompStatus = json['empCompStatus'];
    empPhoto = json['empPhoto'];
    branchId = json['branchId'];
    employeeName = json['employeeName'];
    earlyTime = json['earlyTime'];
    deptId = json['deptId'];
    branchName = json['branchName'];
    inTime = json['inTime'];
    lateTime = json['lateTime'];
    empDetailsId = json['empDetailsId'];
    empDetailId = json['empDetailId'];
    remarks = json['remarks'];
    outTime = json['outTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['date'] = this.date;
    data['deptName'] = this.deptName;
    data['shiftInTime'] = this.shiftInTime;
    data['outPunchType'] = this.outPunchType;
    data['distance'] = this.distance;
    data['inPunchType'] = this.inPunchType;
    data['empEmail'] = this.empEmail;
    data['mobStatus'] = this.mobStatus;
    data['otHrs'] = this.otHrs;
    data['contact'] = this.contact;
    data['branchN'] = this.branchN;
    data['workingHours'] = this.workingHours;
    data['empCompStatus'] = this.empCompStatus;
    data['empPhoto'] = this.empPhoto;
    data['branchId'] = this.branchId;
    data['employeeName'] = this.employeeName;
    data['earlyTime'] = this.earlyTime;
    data['deptId'] = this.deptId;
    data['branchName'] = this.branchName;
    data['inTime'] = this.inTime;
    data['lateTime'] = this.lateTime;
    data['empDetailsId'] = this.empDetailsId;
    data['empDetailId'] = this.empDetailId;
    data['remarks'] = this.remarks;
    data['outTime'] = this.outTime;
    return data;
  }
}

class HalfDayEmpSet {
  String? empId;
  String? date;
  String? deptName;
  String? shiftInTime;
  String? outPunchType;
  String? distance;
  String? inPunchType;
  String? workHours;
  String? empEmail;
  String? mobStatus;
  String? otHrs;
  String? contact;
  String? branchN;
  String? workingHours;
  String? empCompStatus;
  String? empPhoto;
  String? branchId;
  String? employeeName;
  String? earlyTime;
  String? deptId;
  String? branchName;
  String? inTime;
  String? lateTime;
  String? empDetailsId;
  String? empDetailId;
  String? remarks;
  String? outTime;

  HalfDayEmpSet(
      {this.empId,
        this.date,
        this.deptName,
        this.shiftInTime,
        this.outPunchType,
        this.distance,
        this.inPunchType,
        this.workHours,
        this.empEmail,
        this.mobStatus,
        this.otHrs,
        this.contact,
        this.branchN,
        this.workingHours,
        this.empCompStatus,
        this.empPhoto,
        this.branchId,
        this.employeeName,
        this.earlyTime,
        this.deptId,
        this.branchName,
        this.inTime,
        this.lateTime,
        this.empDetailsId,
        this.empDetailId,
        this.remarks,
        this.outTime});

  HalfDayEmpSet.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    date = json['date'];
    deptName = json['deptName'];
    shiftInTime = json['shiftInTime'];
    outPunchType = json['outPunchType'];
    distance = json['distance'];
    inPunchType = json['inPunchType'];
    workHours = json['workHours'];
    empEmail = json['empEmail'];
    mobStatus = json['mobStatus'];
    otHrs = json['otHrs'];
    contact = json['contact'];
    branchN = json['branchN'];
    workingHours = json['workingHours'];
    empCompStatus = json['empCompStatus'];
    empPhoto = json['empPhoto'];
    branchId = json['branchId'];
    employeeName = json['employeeName'];
    earlyTime = json['earlyTime'];
    deptId = json['deptId'];
    branchName = json['branchName'];
    inTime = json['inTime'];
    lateTime = json['lateTime'];
    empDetailsId = json['empDetailsId'];
    empDetailId = json['empDetailId'];
    remarks = json['remarks'];
    outTime = json['outTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['date'] = this.date;
    data['deptName'] = this.deptName;
    data['shiftInTime'] = this.shiftInTime;
    data['outPunchType'] = this.outPunchType;
    data['distance'] = this.distance;
    data['inPunchType'] = this.inPunchType;
    data['workHours'] = this.workHours;
    data['empEmail'] = this.empEmail;
    data['mobStatus'] = this.mobStatus;
    data['otHrs'] = this.otHrs;
    data['contact'] = this.contact;
    data['branchN'] = this.branchN;
    data['workingHours'] = this.workingHours;
    data['empCompStatus'] = this.empCompStatus;
    data['empPhoto'] = this.empPhoto;
    data['branchId'] = this.branchId;
    data['employeeName'] = this.employeeName;
    data['earlyTime'] = this.earlyTime;
    data['deptId'] = this.deptId;
    data['branchName'] = this.branchName;
    data['inTime'] = this.inTime;
    data['lateTime'] = this.lateTime;
    data['empDetailsId'] = this.empDetailsId;
    data['empDetailId'] = this.empDetailId;
    data['remarks'] = this.remarks;
    data['outTime'] = this.outTime;
    return data;
  }
}
