class TodayEventListModal {
  List<TodayEventList>? todayEventList;

  TodayEventListModal({this.todayEventList});

  TodayEventListModal.fromJson(Map<String, dynamic> json) {
    if (json['todayEventList'] != null) {
      todayEventList = <TodayEventList>[];
      json['todayEventList'].forEach((v) {
        todayEventList!.add(TodayEventList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (todayEventList != null) {
      data['todayEventList'] =
          todayEventList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TodayEventList {
  String? image;
  String? dob;
  String? contact;
  String? fullName;
  String? emailId;
  String? empDetailsId;
  String? employeeId;
  String? department;
  String? status;

  TodayEventList(
      {this.image,
        this.dob,
        this.contact,
        this.fullName,
        this.emailId,
        this.empDetailsId,
        this.employeeId,
        this.department,
        this.status});

  TodayEventList.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    dob = json['dob'];
    contact = json['contact'];
    fullName = json['fullName'];
    emailId = json['emailId'];
    empDetailsId = json['empDetailsId'];
    employeeId = json['employeeId'];
    department = json['department'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['dob'] = dob;
    data['contact'] = contact;
    data['fullName'] = fullName;
    data['emailId'] = emailId;
    data['empDetailsId'] = empDetailsId;
    data['employeeId'] = employeeId;
    data['department'] = department;
    data['status'] = status;
    return data;
  }
}
