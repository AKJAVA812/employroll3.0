class HolidayESSModal {
  String? result;
  String? reason;
  List<ViewHolidayList>? viewHolidayList;

  HolidayESSModal({this.result, this.reason, this.viewHolidayList});

  HolidayESSModal.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    reason = json['reason'];
    if (json['viewHolidayList'] != null) {
      viewHolidayList = <ViewHolidayList>[];
      json['viewHolidayList'].forEach((v) {
        viewHolidayList!.add(new ViewHolidayList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['reason'] = this.reason;
    if (this.viewHolidayList != null) {
      data['viewHolidayList'] =
          this.viewHolidayList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
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
    holidayType = json['holidayType'];
    holidaystatus = json['holidaystatus'];
    stateName = json['stateName'];
    branchName = json['branchName'];
    userName = json['userName'];
    holidayName = json['holidayName'];
    holidayId = json['holidayId'];
    dateOfHoliday = json['dateOfHoliday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
