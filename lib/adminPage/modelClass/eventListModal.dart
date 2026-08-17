class EventsListModal {
  List<BdayList>? bdayList;
  List<Joblist>? joblist;

  EventsListModal({this.bdayList, this.joblist});

  EventsListModal.fromJson(Map<String, dynamic> json) {
    if (json['bdayList'] != null) {
      bdayList = <BdayList>[];
      json['bdayList'].forEach((v) {
        bdayList!.add(BdayList.fromJson(v));
      });
    }
    if (json['joblist'] != null) {
      joblist = <Joblist>[];
      json['joblist'].forEach((v) {
        joblist!.add(Joblist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bdayList != null) {
      data['bdayList'] = bdayList!.map((v) => v.toJson()).toList();
    }
    if (joblist != null) {
      data['joblist'] = joblist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BdayList {
  String? image;
  String? dob;
  String? contact;
  String? fullName;
  String? emailId;
  String? empDetailsId;
  String? employeeId;
  String? department;

  BdayList(
      {this.image,
        this.dob,
        this.contact,
        this.fullName,
        this.emailId,
        this.empDetailsId,
        this.employeeId,
        this.department});

  BdayList.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    dob = json['dob'];
    contact = json['contact'];
    fullName = json['fullName'];
    emailId = json['emailId'];
    empDetailsId = json['empDetailsId'];
    employeeId = json['employeeId'];
    department = json['department'];
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
    return data;
  }
}

class Joblist {
  String? image;
  String? contact;
  String? fullName;
  String? emailId;
  String? empDetailsId;
  String? employeeId;
  String? department;
  String? doj;

  Joblist(
      {this.image,
        this.contact,
        this.fullName,
        this.emailId,
        this.empDetailsId,
        this.employeeId,
        this.department,
        this.doj});

  Joblist.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    contact = json['contact'];
    fullName = json['fullName'];
    emailId = json['emailId'];
    empDetailsId = json['empDetailsId'];
    employeeId = json['employeeId'];
    department = json['department'];
    doj = json['doj'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['contact'] = contact;
    data['fullName'] = fullName;
    data['emailId'] = emailId;
    data['empDetailsId'] = empDetailsId;
    data['employeeId'] = employeeId;
    data['department'] = department;
    data['doj'] = doj;
    return data;
  }
}
