class EssEventsListModal {
  List<BdayList>? bdayList;
  List<Joblist>? joblist;

  EssEventsListModal({this.bdayList, this.joblist});

  EssEventsListModal.fromJson(Map<String, dynamic> json) {
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
  String? doj;
  String? contact;
  String? fullName;
  String? emailId;
  String? empDetailsId;
  String? employeeId;
  String? department;

  Joblist(
      {this.image,
        this.doj,
        this.contact,
        this.fullName,
        this.emailId,
        this.empDetailsId,
        this.employeeId,
        this.department});

  Joblist.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    doj = json['doj'];
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
    data['doj'] = doj;
    data['contact'] = contact;
    data['fullName'] = fullName;
    data['emailId'] = emailId;
    data['empDetailsId'] = empDetailsId;
    data['employeeId'] = employeeId;
    data['department'] = department;
    return data;
  }
}
