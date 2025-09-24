class TodayPunchesModal {
  List<TodayData>? data;

  TodayPunchesModal({this.data});

  TodayPunchesModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TodayData>[];
      json['data'].forEach((v) {
        data!.add(new TodayData.fromJson(v));
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

class TodayData {
  String? dt;
  String? punchType;
  String? attMode;
  String? deviceSerial;
  int? empCode;
  String? createdDateTime;
  String? enrollId;
  String? time;
  int? event;
  String? apiType;

  TodayData(
      {this.dt,
        this.punchType,
        this.attMode,
        this.deviceSerial,
        this.empCode,
        this.createdDateTime,
        this.enrollId,
        this.time,
        this.event,
        this.apiType});

  TodayData.fromJson(Map<String, dynamic> json) {
    dt = json['dt'];
    punchType = json['punchType'];
    attMode = json['attMode'];
    deviceSerial = json['deviceSerial'];
    empCode = json['empCode'];
    createdDateTime = json['createdDateTime'];
    enrollId = json['enrollId'];
    time = json['time'];
    event = json['event'];
    apiType = json['apiType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dt'] = this.dt;
    data['punchType'] = this.punchType;
    data['attMode'] = this.attMode;
    data['deviceSerial'] = this.deviceSerial;
    data['empCode'] = this.empCode;
    data['createdDateTime'] = this.createdDateTime;
    data['enrollId'] = this.enrollId;
    data['time'] = this.time;
    data['event'] = this.event;
    data['apiType'] = this.apiType;
    return data;
  }
}
