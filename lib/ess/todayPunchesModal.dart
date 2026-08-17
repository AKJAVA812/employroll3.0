class TodayPunchesModal {
  List<TodayData>? data;

  TodayPunchesModal({this.data});

  TodayPunchesModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TodayData>[];
      json['data'].forEach((v) {
        data!.add(TodayData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
  String? empCode;
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
    empCode = json['empCode']?.toString();
    createdDateTime = json['createdDateTime'];
    enrollId = json['enrollId'];
    time = json['time'];
    event = json['event'];
    apiType = json['apiType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dt'] = dt;
    data['punchType'] = punchType;
    data['attMode'] = attMode;
    data['deviceSerial'] = deviceSerial;
    data['empCode'] = empCode;
    data['createdDateTime'] = createdDateTime;
    data['enrollId'] = enrollId;
    data['time'] = time;
    data['event'] = event;
    data['apiType'] = apiType;
    return data;
  }
}
