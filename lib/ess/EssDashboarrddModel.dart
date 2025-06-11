/*
class EssDashboarrdModel {
  CountData? countData;

  EssDashboarrdModel({this.countData});

  EssDashboarrdModel.fromJson(Map<String, dynamic> json) {
    countData = json['countData'] != null
        ? new CountData.fromJson(json['countData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.countData != null) {
      data['countData'] = this.countData!.toJson();
    }
    return data;
  }
}

class CountData {
  List<Data>? data;

  CountData({this.data});

  CountData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  String? empId;
  List<PresentList>? presentList;
  List<LateList>? lateList;
  int? halfday;
  List<EarlyGoList>? earlyGoList;
  List<AbsentList>? absentList;
  List<HalfDayList>? halfDayList;
  int? totalAtt;
  String? dept;
  int? absentCount;
  List<ShortLeaveList>? shortLeaveList;
  String? branch;
  List<TotalList>? totalList;
  int? late;
  int? shortlev;
  int? totalDays;
  List<MispunchList>? mispunchList;
  String? empName;
  int? mispunch;
  int? earlygo;

  Data(
      {this.empId,
        this.presentList,
        this.lateList,
        this.halfday,
        this.earlyGoList,
        this.absentList,
        this.halfDayList,
        this.totalAtt,
        this.dept,
        this.absentCount,
        this.shortLeaveList,
        this.branch,
        this.totalList,
        this.late,
        this.shortlev,
        this.totalDays,
        this.mispunchList,
        this.empName,
        this.mispunch,
        this.earlygo});

  Data.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    if (json['presentList'] != null) {
      presentList = <PresentList>[];
      json['presentList'].forEach((v) {
        presentList!.add(new PresentList.fromJson(v));
      });
    }
    if (json['lateList'] != null) {
      lateList = <LateList>[];
      json['lateList'].forEach((v) {
        lateList!.add(new LateList.fromJson(v));
      });
    }
    halfday = json['halfday'];
    if (json['earlyGoList'] != null) {
      earlyGoList = <EarlyGoList>[];
      json['earlyGoList'].forEach((v) {
        earlyGoList!.add(new EarlyGoList.fromJson(v));
      });
    }
    if (json['absentList'] != null) {
      absentList = <AbsentList>[];
      json['absentList'].forEach((v) {
        absentList!.add(new AbsentList.fromJson(v));
      });
    }
    if (json['halfDayList'] != null) {
      halfDayList = <HalfDayList>[];
      json['halfDayList'].forEach((v) {
        halfDayList!.add(new HalfDayList.fromJson(v));
      });
    }
    totalAtt = json['totalAtt'];
    dept = json['dept'];
    absentCount = json['absentCount'];
    if (json['shortLeaveList'] != null) {
      shortLeaveList = <ShortLeaveList>[];
      json['shortLeaveList'].forEach((v) {
        shortLeaveList!.add(new ShortLeaveList.fromJson(v));
      });
    }
    branch = json['branch'];
    if (json['totalList'] != null) {
      totalList = <TotalList>[];
      json['totalList'].forEach((v) {
        totalList!.add(new TotalList.fromJson(v));
      });
    }
    late = json['late'];
    shortlev = json['shortlev'];
    totalDays = json['totalDays'];
    if (json['mispunchList'] != null) {
      mispunchList = <MispunchList>[];
      json['mispunchList'].forEach((v) {
        mispunchList!.add(new MispunchList.fromJson(v));
      });
    }
    empName = json['empName'];
    mispunch = json['mispunch'];
    earlygo = json['earlygo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    if (this.presentList != null) {
      data['presentList'] = this.presentList!.map((v) => v.toJson()).toList();
    }
    if (this.lateList != null) {
      data['lateList'] = this.lateList!.map((v) => v.toJson()).toList();
    }
    data['halfday'] = this.halfday;
    if (this.earlyGoList != null) {
      data['earlyGoList'] = this.earlyGoList!.map((v) => v.toJson()).toList();
    }
    if (this.absentList != null) {
      data['absentList'] = this.absentList!.map((v) => v.toJson()).toList();
    }
    if (this.halfDayList != null) {
      data['halfDayList'] = this.halfDayList!.map((v) => v.toJson()).toList();
    }
    data['totalAtt'] = this.totalAtt;
    data['dept'] = this.dept;
    data['absentCount'] = this.absentCount;
    if (this.shortLeaveList != null) {
      data['shortLeaveList'] =
          this.shortLeaveList!.map((v) => v.toJson()).toList();
    }
    data['branch'] = this.branch;
    if (this.totalList != null) {
      data['totalList'] = this.totalList!.map((v) => v.toJson()).toList();
    }
    data['late'] = this.late;
    data['shortlev'] = this.shortlev;
    data['totalDays'] = this.totalDays;
    if (this.mispunchList != null) {
      data['mispunchList'] = this.mispunchList!.map((v) => v.toJson()).toList();
    }
    data['empName'] = this.empName;
    data['mispunch'] = this.mispunch;
    data['earlygo'] = this.earlygo;
    return data;
  }
}

class PresentList {
  String? empId;
  String? outPunchType;
  String? logDate;
  String? inPunchType;
  String? shortStatus;
  String? dept;
  String? type;
  String? branch;
  String? inTime;
  String? empName;
  String? outTime;
  String? status;
  String? statusCode;

  PresentList(
      {this.empId,
        this.outPunchType,
        this.logDate,
        this.inPunchType,
        this.shortStatus,
        this.dept,
        this.type,
        this.branch,
        this.inTime,
        this.empName,
        this.outTime,
        this.status,
        this.statusCode});

  PresentList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    outPunchType = json['outPunchType'];
    logDate = json['logDate'];
    inPunchType = json['inPunchType'];
    shortStatus = json['shortStatus'];
    dept = json['dept'];
    type = json['type'];
    branch = json['branch'];
    inTime = json['inTime'];
    empName = json['empName'];
    outTime = json['outTime'];
    status = json['status'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['outPunchType'] = this.outPunchType;
    data['logDate'] = this.logDate;
    data['inPunchType'] = this.inPunchType;
    data['shortStatus'] = this.shortStatus;
    data['dept'] = this.dept;
    data['type'] = this.type;
    data['branch'] = this.branch;
    data['inTime'] = this.inTime;
    data['empName'] = this.empName;
    data['outTime'] = this.outTime;
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    return data;
  }
}

class EarlyGoList {
  String? empId;
  String? outPunchType;
  String? logDate;
  String? inPunchType;
  String? shortStatus;
  String? dept;
  String? type;
  String? branch;
  String? inTime;
  String? empName;
  String? outTime;
  String? status;
  String? statusCode;

  EarlyGoList(
      {this.empId,
        this.outPunchType,
        this.logDate,
        this.inPunchType,
        this.shortStatus,
        this.dept,
        this.type,
        this.branch,
        this.inTime,
        this.empName,
        this.outTime,
        this.status,
        this.statusCode});

  EarlyGoList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    outPunchType = json['outPunchType'];
    logDate = json['logDate'];
    inPunchType = json['inPunchType'];
    shortStatus = json['shortStatus'];
    dept = json['dept'];
    type = json['type'];
    branch = json['branch'];
    inTime = json['inTime'];
    empName = json['empName'];
    outTime = json['outTime'];
    status = json['status'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['outPunchType'] = this.outPunchType;
    data['logDate'] = this.logDate;
    data['inPunchType'] = this.inPunchType;
    data['shortStatus'] = this.shortStatus;
    data['dept'] = this.dept;
    data['type'] = this.type;
    data['branch'] = this.branch;
    data['inTime'] = this.inTime;
    data['empName'] = this.empName;
    data['outTime'] = this.outTime;
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    return data;
  }
}

class AbsentList {
  String? empId;
  String? outPunchType;
  String? logDate;
  String? inPunchType;
  String? shortStatus;
  String? dept;
  String? type;
  String? branch;
  String? inTime;
  String? empName;
  String? outTime;
  String? status;
  String? statusCode;

  AbsentList(
      {this.empId,
        this.outPunchType,
        this.logDate,
        this.inPunchType,
        this.shortStatus,
        this.dept,
        this.type,
        this.branch,
        this.inTime,
        this.empName,
        this.outTime,
        this.status,
        this.statusCode});

  AbsentList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    outPunchType = json['outPunchType'];
    logDate = json['logDate'];
    inPunchType = json['inPunchType'];
    shortStatus = json['shortStatus'];
    dept = json['dept'];
    type = json['type'];
    branch = json['branch'];
    inTime = json['inTime'];
    empName = json['empName'];
    outTime = json['outTime'];
    status = json['status'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['outPunchType'] = this.outPunchType;
    data['logDate'] = this.logDate;
    data['inPunchType'] = this.inPunchType;
    data['shortStatus'] = this.shortStatus;
    data['dept'] = this.dept;
    data['type'] = this.type;
    data['branch'] = this.branch;
    data['inTime'] = this.inTime;
    data['empName'] = this.empName;
    data['outTime'] = this.outTime;
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    return data;
  }
}

class TotalList {
  String? empId;
  String? outPunchType;
  String? logDate;
  String? inPunchType;
  String? shortStatus;
  String? dept;
  String? type;
  String? branch;
  String? inTime;
  String? empName;
  String? outTime;
  String? status;
  String? statusCode;

  TotalList(
      {this.empId,
        this.outPunchType,
        this.logDate,
        this.inPunchType,
        this.shortStatus,
        this.dept,
        this.type,
        this.branch,
        this.inTime,
        this.empName,
        this.outTime,
        this.status,
        this.statusCode});

  TotalList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    outPunchType = json['outPunchType'];
    logDate = json['logDate'];
    inPunchType = json['inPunchType'];
    shortStatus = json['shortStatus'];
    dept = json['dept'];
    type = json['type'];
    branch = json['branch'];
    inTime = json['inTime'];
    empName = json['empName'];
    outTime = json['outTime'];
    status = json['status'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['outPunchType'] = this.outPunchType;
    data['logDate'] = this.logDate;
    data['inPunchType'] = this.inPunchType;
    data['shortStatus'] = this.shortStatus;
    data['dept'] = this.dept;
    data['type'] = this.type;
    data['branch'] = this.branch;
    data['inTime'] = this.inTime;
    data['empName'] = this.empName;
    data['outTime'] = this.outTime;
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    return data;
  }
}

class LateList {
  String? empId;
  String? outPunchType;
  String? logDate;
  String? inPunchType;
  String? shortStatus;
  String? dept;
  String? type;
  String? branch;
  String? inTime;
  String? empName;
  String? outTime;
  String? status;
  String? statusCode;

  LateList(
      {this.empId,
        this.outPunchType,
        this.logDate,
        this.inPunchType,
        this.shortStatus,
        this.dept,
        this.type,
        this.branch,
        this.inTime,
        this.empName,
        this.outTime,
        this.status,
        this.statusCode});

  LateList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    outPunchType = json['outPunchType'];
    logDate = json['logDate'];
    inPunchType = json['inPunchType'];
    shortStatus = json['shortStatus'];
    dept = json['dept'];
    type = json['type'];
    branch = json['branch'];
    inTime = json['inTime'];
    empName = json['empName'];
    outTime = json['outTime'];
    status = json['status'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['outPunchType'] = this.outPunchType;
    data['logDate'] = this.logDate;
    data['inPunchType'] = this.inPunchType;
    data['shortStatus'] = this.shortStatus;
    data['dept'] = this.dept;
    data['type'] = this.type;
    data['branch'] = this.branch;
    data['inTime'] = this.inTime;
    data['empName'] = this.empName;
    data['outTime'] = this.outTime;
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    return data;
  }
}

class HalfDayList {
  String? empId;
  String? outPunchType;
  String? logDate;
  String? inPunchType;
  String? shortStatus;
  String? dept;
  String? type;
  String? branch;
  String? inTime;
  String? empName;
  String? outTime;
  String? status;
  String? statusCode;

  HalfDayList(
      {this.empId,
        this.outPunchType,
        this.logDate,
        this.inPunchType,
        this.shortStatus,
        this.dept,
        this.type,
        this.branch,
        this.inTime,
        this.empName,
        this.outTime,
        this.status,
        this.statusCode});

  HalfDayList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    outPunchType = json['outPunchType'];
    logDate = json['logDate'];
    inPunchType = json['inPunchType'];
    shortStatus = json['shortStatus'];
    dept = json['dept'];
    type = json['type'];
    branch = json['branch'];
    inTime = json['inTime'];
    empName = json['empName'];
    outTime = json['outTime'];
    status = json['status'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['outPunchType'] = this.outPunchType;
    data['logDate'] = this.logDate;
    data['inPunchType'] = this.inPunchType;
    data['shortStatus'] = this.shortStatus;
    data['dept'] = this.dept;
    data['type'] = this.type;
    data['branch'] = this.branch;
    data['inTime'] = this.inTime;
    data['empName'] = this.empName;
    data['outTime'] = this.outTime;
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    return data;
  }
}

class ShortLeaveList {
  String? empId;
  String? outPunchType;
  String? logDate;
  String? inPunchType;
  String? shortStatus;
  String? dept;
  String? type;
  String? branch;
  String? inTime;
  String? empName;
  String? outTime;
  String? status;
  String? statusCode;

  ShortLeaveList(
      {this.empId,
        this.outPunchType,
        this.logDate,
        this.inPunchType,
        this.shortStatus,
        this.dept,
        this.type,
        this.branch,
        this.inTime,
        this.empName,
        this.outTime,
        this.status,
        this.statusCode});

  ShortLeaveList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    outPunchType = json['outPunchType'];
    logDate = json['logDate'];
    inPunchType = json['inPunchType'];
    shortStatus = json['shortStatus'];
    dept = json['dept'];
    type = json['type'];
    branch = json['branch'];
    inTime = json['inTime'];
    empName = json['empName'];
    outTime = json['outTime'];
    status = json['status'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['outPunchType'] = this.outPunchType;
    data['logDate'] = this.logDate;
    data['inPunchType'] = this.inPunchType;
    data['shortStatus'] = this.shortStatus;
    data['dept'] = this.dept;
    data['type'] = this.type;
    data['branch'] = this.branch;
    data['inTime'] = this.inTime;
    data['empName'] = this.empName;
    data['outTime'] = this.outTime;
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    return data;
  }
}

class MispunchList {
  String? empId;
  String? outPunchType;
  String? logDate;
  String? inPunchType;
  String? shortStatus;
  String? dept;
  String? type;
  String? branch;
  String? inTime;
  String? empName;
  String? outTime;
  String? status;
  String? statusCode;

  MispunchList(
      {this.empId,
        this.outPunchType,
        this.logDate,
        this.inPunchType,
        this.shortStatus,
        this.dept,
        this.type,
        this.branch,
        this.inTime,
        this.empName,
        this.outTime,
        this.status,
        this.statusCode});

  MispunchList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    outPunchType = json['outPunchType'];
    logDate = json['logDate'];
    inPunchType = json['inPunchType'];
    shortStatus = json['shortStatus'];
    dept = json['dept'];
    type = json['type'];
    branch = json['branch'];
    inTime = json['inTime'];
    empName = json['empName'];
    outTime = json['outTime'];
    status = json['status'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['outPunchType'] = this.outPunchType;
    data['logDate'] = this.logDate;
    data['inPunchType'] = this.inPunchType;
    data['shortStatus'] = this.shortStatus;
    data['dept'] = this.dept;
    data['type'] = this.type;
    data['branch'] = this.branch;
    data['inTime'] = this.inTime;
    data['empName'] = this.empName;
    data['outTime'] = this.outTime;
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    return data;
  }
}
*/

class EssDashboarrdModel {
  CountData? countData;

  EssDashboarrdModel({this.countData});

  EssDashboarrdModel.fromJson(Map<String, dynamic> json) {
    countData = json['countData'] != null
        ? new CountData.fromJson(json['countData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.countData != null) {
      data['countData'] = this.countData!.toJson();
    }
    return data;
  }
}

class CountData {
  List<PresentList>? presentList;
  List<LateList>? lateList;
  List<Data>? data;
  int? halfday;
  List<EarlyGoList>? earlyGoList;
  List<AbsentList>? absentList;
  List<HalfDayList>? halfDayList;
  int? totalAtt;
  int? absentCount;
  List<ShortLeaveList>? shortLeaveList;
  List<TotalList>? totalList;
  int? late;
  int? shortlev;
  int? totalDays;
  List<MispunchList>? mispunchList;
  int? mispunch;
  int? earlygo;
  int? paidDaysCount;

  CountData(
      {this.presentList,
        this.lateList,
        this.data,
        this.halfday,
        this.earlyGoList,
        this.absentList,
        this.halfDayList,
        this.totalAtt,
        this.absentCount,
        this.shortLeaveList,
        this.totalList,
        this.late,
        this.shortlev,
        this.totalDays,
        this.mispunchList,
        this.mispunch,
        this.earlygo,
        this.paidDaysCount});

  CountData.fromJson(Map<String, dynamic> json) {
    if (json['presentList'] != null) {
      presentList = <PresentList>[];
      json['presentList'].forEach((v) {
        presentList!.add(new PresentList.fromJson(v));
      });
    }
    if (json['lateList'] != null) {
      lateList = <LateList>[];
      json['lateList'].forEach((v) {
        lateList!.add(new LateList.fromJson(v));
      });
    }
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    halfday = json['halfday'];
    if (json['earlyGoList'] != null) {
      earlyGoList = <EarlyGoList>[];
      json['earlyGoList'].forEach((v) {
        earlyGoList!.add(new EarlyGoList.fromJson(v));
      });
    }
    if (json['absentList'] != null) {
      absentList = <AbsentList>[];
      json['absentList'].forEach((v) {
        absentList!.add(new AbsentList.fromJson(v));
      });
    }
    if (json['halfDayList'] != null) {
      halfDayList = <HalfDayList>[];
      json['halfDayList'].forEach((v) {
        halfDayList!.add(new HalfDayList.fromJson(v));
      });
    }
    totalAtt = json['totalAtt'];
    absentCount = json['absentCount'];
    if (json['shortLeaveList'] != null) {
      shortLeaveList = <ShortLeaveList>[];
      json['shortLeaveList'].forEach((v) {
        shortLeaveList!.add(new ShortLeaveList.fromJson(v));
      });
    }
    if (json['totalList'] != null) {
      totalList = <TotalList>[];
      json['totalList'].forEach((v) {
        totalList!.add(new TotalList.fromJson(v));
      });
    }
    late = json['late'];
    shortlev = json['shortlev'];
    totalDays = json['totalDays'];
    if (json['mispunchList'] != null) {
      mispunchList = <MispunchList>[];
      json['mispunchList'].forEach((v) {
        mispunchList!.add(new MispunchList.fromJson(v));
      });
    }
    mispunch = json['mispunch'];
    earlygo = json['earlygo'];
    paidDaysCount = json['paidDaysCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.presentList != null) {
      data['presentList'] = this.presentList!.map((v) => v.toJson()).toList();
    }
    if (this.lateList != null) {
      data['lateList'] = this.lateList!.map((v) => v.toJson()).toList();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['halfday'] = this.halfday;
    if (this.earlyGoList != null) {
      data['earlyGoList'] = this.earlyGoList!.map((v) => v.toJson()).toList();
    }
    if (this.absentList != null) {
      data['absentList'] = this.absentList!.map((v) => v.toJson()).toList();
    }
    if (this.halfDayList != null) {
      data['halfDayList'] = this.halfDayList!.map((v) => v.toJson()).toList();
    }
    data['totalAtt'] = this.totalAtt;
    data['absentCount'] = this.absentCount;
    if (this.shortLeaveList != null) {
      data['shortLeaveList'] =
          this.shortLeaveList!.map((v) => v.toJson()).toList();
    }
    if (this.totalList != null) {
      data['totalList'] = this.totalList!.map((v) => v.toJson()).toList();
    }
    data['late'] = this.late;
    data['shortlev'] = this.shortlev;
    data['totalDays'] = this.totalDays;
    if (this.mispunchList != null) {
      data['mispunchList'] = this.mispunchList!.map((v) => v.toJson()).toList();
    }
    data['mispunch'] = this.mispunch;
    data['earlygo'] = this.earlygo;
    data['paidDaysCount'] = this.paidDaysCount;
    return data;
  }
}

class Data {
  String? empId;
  String? empName;
  String? dept;
  String? branch;

  Data({this.empId, this.empName, this.dept, this.branch});

  Data.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    empName = json['empName'];
    dept = json['dept'];
    branch = json['branch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['empName'] = this.empName;
    data['dept'] = this.dept;
    data['branch'] = this.branch;
    return data;
  }
}

class AbsentList {
  String? empId;
  String? outPunchType;
  String? logDate;
  String? lateTime;
  String? earlyTime;
  String? inPunchType;
  String? shortStatus;
  String? dept;
  String? type;
  String? branch;
  String? inTime;
  String? empName;
  String? workingHours;
  String? outTime;
  String? status;
  String? statusCode;

  AbsentList(
      {this.empId,
        this.outPunchType,
        this.logDate,
        this.lateTime,
        this.earlyTime,
        this.inPunchType,
        this.shortStatus,
        this.dept,
        this.type,
        this.branch,
        this.inTime,
        this.empName,
        this.workingHours,
        this.outTime,
        this.status,
        this.statusCode});

  AbsentList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    outPunchType = json['outPunchType'];
    logDate = json['logDate'];
    lateTime = json['lateTime'];
    earlyTime = json['earlyTime'];
    inPunchType = json['inPunchType'];
    shortStatus = json['shortStatus'];
    dept = json['dept'];
    type = json['type'];
    branch = json['branch'];
    inTime = json['inTime'];
    empName = json['empName'];
    workingHours = json['workingHours'];
    outTime = json['outTime'];
    status = json['status'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['outPunchType'] = this.outPunchType;
    data['logDate'] = this.logDate;
    data['lateTime'] = this.lateTime;
    data['earlyTime'] = this.earlyTime;
    data['inPunchType'] = this.inPunchType;
    data['shortStatus'] = this.shortStatus;
    data['dept'] = this.dept;
    data['type'] = this.type;
    data['branch'] = this.branch;
    data['inTime'] = this.inTime;
    data['empName'] = this.empName;
    data['workingHours'] = this.workingHours;
    data['outTime'] = this.outTime;
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    return data;
  }
}

class PresentList {
  String? empId;
  String? outPunchType;
  String? logDate;
  String? lateTime;
  String? earlyTime;
  String? inPunchType;
  String? shortStatus;
  String? dept;
  String? type;
  String? branch;
  String? inTime;
  String? empName;
  String? workingHours;
  String? outTime;
  String? status;
  String? statusCode;

  PresentList(
      {this.empId,
        this.outPunchType,
        this.logDate,
        this.lateTime,
        this.earlyTime,
        this.inPunchType,
        this.shortStatus,
        this.dept,
        this.type,
        this.branch,
        this.inTime,
        this.empName,
        this.workingHours,
        this.outTime,
        this.status,
        this.statusCode});

  PresentList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    outPunchType = json['outPunchType'];
    logDate = json['logDate'];
    lateTime = json['lateTime'];
    earlyTime = json['earlyTime'];
    inPunchType = json['inPunchType'];
    shortStatus = json['shortStatus'];
    dept = json['dept'];
    type = json['type'];
    branch = json['branch'];
    inTime = json['inTime'];
    empName = json['empName'];
    workingHours = json['workingHours'];
    outTime = json['outTime'];
    status = json['status'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['outPunchType'] = this.outPunchType;
    data['logDate'] = this.logDate;
    data['lateTime'] = this.lateTime;
    data['earlyTime'] = this.earlyTime;
    data['inPunchType'] = this.inPunchType;
    data['shortStatus'] = this.shortStatus;
    data['dept'] = this.dept;
    data['type'] = this.type;
    data['branch'] = this.branch;
    data['inTime'] = this.inTime;
    data['empName'] = this.empName;
    data['workingHours'] = this.workingHours;
    data['outTime'] = this.outTime;
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    return data;
  }
}

class LateList {
  String? empId;
  String? outPunchType;
  String? logDate;
  String? lateTime;
  String? earlyTime;
  String? inPunchType;
  String? shortStatus;
  String? dept;
  String? type;
  String? branch;
  String? inTime;
  String? empName;
  String? workingHours;
  String? outTime;
  String? status;
  String? statusCode;

  LateList(
      {this.empId,
        this.outPunchType,
        this.logDate,
        this.lateTime,
        this.earlyTime,
        this.inPunchType,
        this.shortStatus,
        this.dept,
        this.type,
        this.branch,
        this.inTime,
        this.empName,
        this.workingHours,
        this.outTime,
        this.status,
        this.statusCode});

  LateList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    outPunchType = json['outPunchType'];
    logDate = json['logDate'];
    lateTime = json['lateTime'];
    earlyTime = json['earlyTime'];
    inPunchType = json['inPunchType'];
    shortStatus = json['shortStatus'];
    dept = json['dept'];
    type = json['type'];
    branch = json['branch'];
    inTime = json['inTime'];
    empName = json['empName'];
    workingHours = json['workingHours'];
    outTime = json['outTime'];
    status = json['status'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['outPunchType'] = this.outPunchType;
    data['logDate'] = this.logDate;
    data['lateTime'] = this.lateTime;
    data['earlyTime'] = this.earlyTime;
    data['inPunchType'] = this.inPunchType;
    data['shortStatus'] = this.shortStatus;
    data['dept'] = this.dept;
    data['type'] = this.type;
    data['branch'] = this.branch;
    data['inTime'] = this.inTime;
    data['empName'] = this.empName;
    data['workingHours'] = this.workingHours;
    data['outTime'] = this.outTime;
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    return data;
  }
}

class MispunchList {
  String? empId;
  String? outPunchType;
  String? logDate;
  String? lateTime;
  String? earlyTime;
  String? inPunchType;
  String? shortStatus;
  String? dept;
  String? type;
  String? branch;
  String? inTime;
  String? empName;
  String? workingHours;
  String? outTime;
  String? status;
  String? statusCode;

  MispunchList(
      {this.empId,
        this.outPunchType,
        this.logDate,
        this.lateTime,
        this.earlyTime,
        this.inPunchType,
        this.shortStatus,
        this.dept,
        this.type,
        this.branch,
        this.inTime,
        this.empName,
        this.workingHours,
        this.outTime,
        this.status,
        this.statusCode});

  MispunchList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    outPunchType = json['outPunchType'];
    logDate = json['logDate'];
    lateTime = json['lateTime'];
    earlyTime = json['earlyTime'];
    inPunchType = json['inPunchType'];
    shortStatus = json['shortStatus'];
    dept = json['dept'];
    type = json['type'];
    branch = json['branch'];
    inTime = json['inTime'];
    empName = json['empName'];
    workingHours = json['workingHours'];
    outTime = json['outTime'];
    status = json['status'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['outPunchType'] = this.outPunchType;
    data['logDate'] = this.logDate;
    data['lateTime'] = this.lateTime;
    data['earlyTime'] = this.earlyTime;
    data['inPunchType'] = this.inPunchType;
    data['shortStatus'] = this.shortStatus;
    data['dept'] = this.dept;
    data['type'] = this.type;
    data['branch'] = this.branch;
    data['inTime'] = this.inTime;
    data['empName'] = this.empName;
    data['workingHours'] = this.workingHours;
    data['outTime'] = this.outTime;
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    return data;
  }
}

class EarlyGoList {
  String? empId;
  String? outPunchType;
  String? logDate;
  String? lateTime;
  String? earlyTime;
  String? inPunchType;
  String? shortStatus;
  String? dept;
  String? type;
  String? branch;
  String? inTime;
  String? empName;
  String? workingHours;
  String? outTime;
  String? status;
  String? statusCode;

  EarlyGoList(
      {this.empId,
        this.outPunchType,
        this.logDate,
        this.lateTime,
        this.earlyTime,
        this.inPunchType,
        this.shortStatus,
        this.dept,
        this.type,
        this.branch,
        this.inTime,
        this.empName,
        this.workingHours,
        this.outTime,
        this.status,
        this.statusCode});

  EarlyGoList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    outPunchType = json['outPunchType'];
    logDate = json['logDate'];
    lateTime = json['lateTime'];
    earlyTime = json['earlyTime'];
    inPunchType = json['inPunchType'];
    shortStatus = json['shortStatus'];
    dept = json['dept'];
    type = json['type'];
    branch = json['branch'];
    inTime = json['inTime'];
    empName = json['empName'];
    workingHours = json['workingHours'];
    outTime = json['outTime'];
    status = json['status'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['outPunchType'] = this.outPunchType;
    data['logDate'] = this.logDate;
    data['lateTime'] = this.lateTime;
    data['earlyTime'] = this.earlyTime;
    data['inPunchType'] = this.inPunchType;
    data['shortStatus'] = this.shortStatus;
    data['dept'] = this.dept;
    data['type'] = this.type;
    data['branch'] = this.branch;
    data['inTime'] = this.inTime;
    data['empName'] = this.empName;
    data['workingHours'] = this.workingHours;
    data['outTime'] = this.outTime;
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    return data;
  }
}

class HalfDayList {
  String? empId;
  String? outPunchType;
  String? logDate;
  String? lateTime;
  String? earlyTime;
  String? inPunchType;
  String? shortStatus;
  String? dept;
  String? type;
  String? branch;
  String? inTime;
  String? empName;
  String? workingHours;
  String? outTime;
  String? status;
  String? statusCode;

  HalfDayList(
      {this.empId,
        this.outPunchType,
        this.logDate,
        this.lateTime,
        this.earlyTime,
        this.inPunchType,
        this.shortStatus,
        this.dept,
        this.type,
        this.branch,
        this.inTime,
        this.empName,
        this.workingHours,
        this.outTime,
        this.status,
        this.statusCode});

  HalfDayList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    outPunchType = json['outPunchType'];
    logDate = json['logDate'];
    lateTime = json['lateTime'];
    earlyTime = json['earlyTime'];
    inPunchType = json['inPunchType'];
    shortStatus = json['shortStatus'];
    dept = json['dept'];
    type = json['type'];
    branch = json['branch'];
    inTime = json['inTime'];
    empName = json['empName'];
    workingHours = json['workingHours'];
    outTime = json['outTime'];
    status = json['status'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['outPunchType'] = this.outPunchType;
    data['logDate'] = this.logDate;
    data['lateTime'] = this.lateTime;
    data['earlyTime'] = this.earlyTime;
    data['inPunchType'] = this.inPunchType;
    data['shortStatus'] = this.shortStatus;
    data['dept'] = this.dept;
    data['type'] = this.type;
    data['branch'] = this.branch;
    data['inTime'] = this.inTime;
    data['empName'] = this.empName;
    data['workingHours'] = this.workingHours;
    data['outTime'] = this.outTime;
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    return data;
  }
}

class ShortLeaveList {
  String? empId;
  String? outPunchType;
  String? logDate;
  String? lateTime;
  String? earlyTime;
  String? inPunchType;
  String? shortStatus;
  String? dept;
  String? type;
  String? branch;
  String? inTime;
  String? empName;
  String? workingHours;
  String? outTime;
  String? status;
  String? statusCode;

  ShortLeaveList(
      {this.empId,
        this.outPunchType,
        this.logDate,
        this.lateTime,
        this.earlyTime,
        this.inPunchType,
        this.shortStatus,
        this.dept,
        this.type,
        this.branch,
        this.inTime,
        this.empName,
        this.workingHours,
        this.outTime,
        this.status,
        this.statusCode});

  ShortLeaveList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    outPunchType = json['outPunchType'];
    logDate = json['logDate'];
    lateTime = json['lateTime'];
    earlyTime = json['earlyTime'];
    inPunchType = json['inPunchType'];
    shortStatus = json['shortStatus'];
    dept = json['dept'];
    type = json['type'];
    branch = json['branch'];
    inTime = json['inTime'];
    empName = json['empName'];
    workingHours = json['workingHours'];
    outTime = json['outTime'];
    status = json['status'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['outPunchType'] = this.outPunchType;
    data['logDate'] = this.logDate;
    data['lateTime'] = this.lateTime;
    data['earlyTime'] = this.earlyTime;
    data['inPunchType'] = this.inPunchType;
    data['shortStatus'] = this.shortStatus;
    data['dept'] = this.dept;
    data['type'] = this.type;
    data['branch'] = this.branch;
    data['inTime'] = this.inTime;
    data['empName'] = this.empName;
    data['workingHours'] = this.workingHours;
    data['outTime'] = this.outTime;
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    return data;
  }
}

class TotalList {
  String? empId;
  String? outPunchType;
  String? logDate;
  String? lateTime;
  String? earlyTime;
  String? inPunchType;
  String? shortStatus;
  String? dept;
  String? type;
  String? branch;
  String? inTime;
  String? empName;
  dynamic workingHours;
  String? outTime;
  String? status;
  String? statusCode;

  TotalList(
      {this.empId,
        this.outPunchType,
        this.logDate,
        this.lateTime,
        this.earlyTime,
        this.inPunchType,
        this.shortStatus,
        this.dept,
        this.type,
        this.branch,
        this.inTime,
        this.empName,
        this.workingHours,
        this.outTime,
        this.status,
        this.statusCode});

  TotalList.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    outPunchType = json['outPunchType'];
    logDate = json['logDate'];
    lateTime = json['lateTime'];
    earlyTime = json['earlyTime'];
    inPunchType = json['inPunchType'];
    shortStatus = json['shortStatus'];
    dept = json['dept'];
    type = json['type'];
    branch = json['branch'];
    inTime = json['inTime'];
    empName = json['empName'];
    workingHours = json['workingHours'];
    outTime = json['outTime'];
    status = json['status'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['outPunchType'] = this.outPunchType;
    data['logDate'] = this.logDate;
    data['lateTime'] = this.lateTime;
    data['earlyTime'] = this.earlyTime;
    data['inPunchType'] = this.inPunchType;
    data['shortStatus'] = this.shortStatus;
    data['dept'] = this.dept;
    data['type'] = this.type;
    data['branch'] = this.branch;
    data['inTime'] = this.inTime;
    data['empName'] = this.empName;
    data['workingHours'] = this.workingHours;
    data['outTime'] = this.outTime;
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    return data;
  }
}
