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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['halfdayMaxWorkHour'] = halfdayMaxWorkHour;
    data['result'] = result;
    data['halfdayMinWorkHour'] = halfdayMinWorkHour;
    data['presentWorkHour'] = presentWorkHour;
    data['isAbsentWorkHour'] = isAbsentWorkHour;
    data['isShortWorkHour'] = isShortWorkHour;
    data['id'] = id;
    data['shortMaxWorkHour'] = shortMaxWorkHour;
    data['isPresentWorkHour'] = isPresentWorkHour;
    data['absentWorkHour'] = absentWorkHour;
    data['shortMinWorkHour'] = shortMinWorkHour;
    data['isHalfdayWorkHour'] = isHalfdayWorkHour;
    return data;
  }
}
