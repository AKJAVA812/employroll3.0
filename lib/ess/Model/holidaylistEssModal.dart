class HolidayESSModal {
  String? result;
  String? reason;
  List<ViewHolidayList>? viewHolidayList;

  HolidayESSModal({this.result, this.reason, this.viewHolidayList});

  HolidayESSModal.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    reason = json['reason'];
    final holidayRows =
        json['viewHolidayList'] ??
        json['holidayList'] ??
        json['holidays'] ??
        _nestedHolidayRows(json['r3']) ??
        _nestedHolidayRows(json['r3Body']) ??
        _nestedHolidayRows(json['r3Calendar']) ??
        _nestedHolidayRows(json['calendarBody']);
    if (holidayRows != null) {
      viewHolidayList = <ViewHolidayList>[];
      holidayRows.forEach((v) {
        viewHolidayList!.add(ViewHolidayList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['result'] = this.result;
    data['reason'] = this.reason;
    if (this.viewHolidayList != null) {
      data['viewHolidayList'] =
          this.viewHolidayList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

dynamic _nestedHolidayRows(dynamic source) {
  if (source is! Map) return null;
  return source['viewHolidayList'] ?? source['holidayList'] ?? source['holidays'];
}

class ViewHolidayList {
  String? gradeName;
  String? holidayType;
  String? holidaystatus;
  String? stateName;
  String? branchName;
  String? userName;
  String? holidayName;
  int? holidayId;
  String? dateOfHoliday;

  ViewHolidayList(
      {this.gradeName,
        this.holidayType,
        this.holidaystatus,
        this.stateName,
        this.branchName,
        this.userName,
        this.holidayName,
        this.holidayId,
        this.dateOfHoliday});

  ViewHolidayList.fromJson(Map<String, dynamic> json) {
    gradeName = json['gradeName'];
    holidayType = json['holidayType'] ?? json['type'] ?? json['applicability'];
    holidaystatus = json['holidaystatus'];
    stateName = json['stateName'];
    branchName = json['branchName'];
    userName = json['userName'];
    holidayName = json['holidayName'] ?? json['name'] ?? json['title'];
    holidayId = json['holidayId'] ?? json['id'];
    dateOfHoliday = json['dateOfHoliday'] ?? json['date'] ?? json['holidayDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['gradeName'] = this.gradeName;
    data['holidayType'] = this.holidayType;
    data['holidaystatus'] = this.holidaystatus;
    data['stateName'] = this.stateName;
    data['branchName'] = this.branchName;
    data['userName'] = this.userName;
    data['holidayName'] = this.holidayName;
    data['holidayId'] = this.holidayId;
    data['dateOfHoliday'] = this.dateOfHoliday;
    return data;
  }
}
