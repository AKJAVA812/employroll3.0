class CalendarModalClass {
  List<Legends>? legends;
  List<Data>? data;

  CalendarModalClass({this.legends, this.data});

  CalendarModalClass.fromJson(Map<String, dynamic> json) {
    if (json['legends'] != null) {
      legends = <Legends>[];
      json['legends'].forEach((v) {
        legends!.add(Legends.fromJson(v));
      });
    }
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (legends != null) {
      data['legends'] = legends!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobColor'] = mobColor;
    data['status'] = status;
    data['statusName'] = statusName;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empId'] = empId;
    data['outPunchType'] = outPunchType;
    data['logDate'] = logDate;
    data['inPunchType'] = inPunchType;
    data['shortStatus'] = shortStatus;
    data['dept'] = dept;
    data['type'] = type;
    data['branch'] = branch;
    data['webColor'] = webColor;
    data['inTime'] = inTime;
    data['mobColor'] = mobColor;
    data['empName'] = empName;
    data['outTime'] = outTime;
    data['status'] = status;
    data['statusCode'] = statusCode;
    return data;
  }
}
