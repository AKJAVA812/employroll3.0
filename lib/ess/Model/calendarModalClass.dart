class CalendarModalClass {
  List<Legends>? legends;
  List<Data>? data;

  CalendarModalClass({this.legends, this.data});

  CalendarModalClass.fromJson(Map<String, dynamic> json) {
    if (json['legends'] != null) {
      legends = <Legends>[];
      json['legends'].forEach((v) {
        legends!.add(new Legends.fromJson(v));
      });
    }
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.legends != null) {
      data['legends'] = this.legends!.map((v) => v.toJson()).toList();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Legends {
  String? mobColor;
  String? status;
  String? statusName;

  Legends({this.mobColor, this.status});

  Legends.fromJson(Map<String, dynamic> json) {
    mobColor = json['mobColor'];
    status = json['status'];
    statusName = json['statusName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobColor'] = this.mobColor;
    data['status'] = this.status;
    data['statusName'] = this.statusName;
    return data;
  }
}

class Data {
  String? empId;
  String? outPunchType;
  String? logDate;
  String? inPunchType;
  String? shortStatus;
  String? dept;
  String? type;
  String? branch;
  String? webColor;
  String? inTime;
  String? mobColor;
  String? empName;
  String? outTime;
  String? status;
  String? statusCode;

  Data(
      {this.empId,
        this.outPunchType,
        this.logDate,
        this.inPunchType,
        this.shortStatus,
        this.dept,
        this.type,
        this.branch,
        this.webColor,
        this.inTime,
        this.mobColor,
        this.empName,
        this.outTime,
        this.status,
        this.statusCode});

  Data.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    outPunchType = json['outPunchType'];
    logDate = json['logDate'];
    inPunchType = json['inPunchType'];
    shortStatus = json['shortStatus'];
    dept = json['dept'];
    type = json['type'];
    branch = json['branch'];
    webColor = json['webColor'];
    inTime = json['inTime'];
    mobColor = json['mobColor'];
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
    data['webColor'] = this.webColor;
    data['inTime'] = this.inTime;
    data['mobColor'] = this.mobColor;
    data['empName'] = this.empName;
    data['outTime'] = this.outTime;
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    return data;
  }
}
