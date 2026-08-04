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
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.todayEventList != null) {
      data['todayEventList'] =
          this.todayEventList!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['image'] = this.image;
    data['dob'] = this.dob;
    data['contact'] = this.contact;
    data['fullName'] = this.fullName;
    data['emailId'] = this.emailId;
    data['empDetailsId'] = this.empDetailsId;
    data['employeeId'] = this.employeeId;
    data['department'] = this.department;
    data['status'] = this.status;
    return data;
  }
}
