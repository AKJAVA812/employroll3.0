class EssEventsListModal {
  List<BdayList>? bdayList;
  List<Joblist>? joblist;

  EssEventsListModal({this.bdayList, this.joblist});

  EssEventsListModal.fromJson(Map<String, dynamic> json) {
    if (json['bdayList'] != null) {
      bdayList = <BdayList>[];
      json['bdayList'].forEach((v) {
        bdayList!.add(new BdayList.fromJson(v));
      });
    }
    if (json['joblist'] != null) {
      joblist = <Joblist>[];
      json['joblist'].forEach((v) {
        joblist!.add(new Joblist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bdayList != null) {
      data['bdayList'] = this.bdayList!.map((v) => v.toJson()).toList();
    }
    if (this.joblist != null) {
      data['joblist'] = this.joblist!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['dob'] = this.dob;
    data['contact'] = this.contact;
    data['fullName'] = this.fullName;
    data['emailId'] = this.emailId;
    data['empDetailsId'] = this.empDetailsId;
    data['employeeId'] = this.employeeId;
    data['department'] = this.department;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['doj'] = this.doj;
    data['contact'] = this.contact;
    data['fullName'] = this.fullName;
    data['emailId'] = this.emailId;
    data['empDetailsId'] = this.empDetailsId;
    data['employeeId'] = this.employeeId;
    data['department'] = this.department;
    return data;
  }
}
