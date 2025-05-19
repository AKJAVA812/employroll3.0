class AttendanceShiftDetailsModal {
  String? halfdayMaxWorkHour;
  String? result;
  String? halfdayMinWorkHour;
  String? presentWorkHour;
  bool? isAbsentWorkHour;
  bool? isShortWorkHour;
  int? id;
  String? shortMaxWorkHour;
  bool? isPresentWorkHour;
  String? absentWorkHour;
  String? shortMinWorkHour;
  bool? isHalfdayWorkHour;

  AttendanceShiftDetailsModal(
      {this.halfdayMaxWorkHour,
        this.result,
        this.halfdayMinWorkHour,
        this.presentWorkHour,
        this.isAbsentWorkHour,
        this.isShortWorkHour,
        this.id,
        this.shortMaxWorkHour,
        this.isPresentWorkHour,
        this.absentWorkHour,
        this.shortMinWorkHour,
        this.isHalfdayWorkHour});

  AttendanceShiftDetailsModal.fromJson(Map<String, dynamic> json) {
    halfdayMaxWorkHour = json['halfdayMaxWorkHour'];
    result = json['result'];
    halfdayMinWorkHour = json['halfdayMinWorkHour'];
    presentWorkHour = json['presentWorkHour'];
    isAbsentWorkHour = json['isAbsentWorkHour'];
    isShortWorkHour = json['isShortWorkHour'];
    id = json['id'];
    shortMaxWorkHour = json['shortMaxWorkHour'];
    isPresentWorkHour = json['isPresentWorkHour'];
    absentWorkHour = json['absentWorkHour'];
    shortMinWorkHour = json['shortMinWorkHour'];
    isHalfdayWorkHour = json['isHalfdayWorkHour'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['halfdayMaxWorkHour'] = this.halfdayMaxWorkHour;
    data['result'] = this.result;
    data['halfdayMinWorkHour'] = this.halfdayMinWorkHour;
    data['presentWorkHour'] = this.presentWorkHour;
    data['isAbsentWorkHour'] = this.isAbsentWorkHour;
    data['isShortWorkHour'] = this.isShortWorkHour;
    data['id'] = this.id;
    data['shortMaxWorkHour'] = this.shortMaxWorkHour;
    data['isPresentWorkHour'] = this.isPresentWorkHour;
    data['absentWorkHour'] = this.absentWorkHour;
    data['shortMinWorkHour'] = this.shortMinWorkHour;
    data['isHalfdayWorkHour'] = this.isHalfdayWorkHour;
    return data;
  }
}
