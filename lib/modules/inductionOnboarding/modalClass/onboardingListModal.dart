class OnboardingListModal {
  dynamic result;
  List<Data>? data;

  OnboardingListModal({this.result, this.data});

  OnboardingListModal.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['result'] = this.result;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  dynamic gender;
  dynamic userType;
  dynamic branchName;
  dynamic aadharNo;
  dynamic maritalStatus;
  dynamic userTypeName;
  dynamic doj;
  dynamic firstName;
  dynamic currentAddress;
  dynamic designationName;
  dynamic department;
  dynamic departmentName;
  dynamic aadharRegisNo;
  dynamic permanentAddress;
  dynamic empPhoto;
  dynamic branch;
  dynamic mobileNo;
  dynamic designation;
  dynamic skillType;
  dynamic dob;
  dynamic empStatus;
  dynamic emailId;
  dynamic status;

  Data(
      {this.gender,
        this.userType,
        this.branchName,
        this.aadharNo,
        this.maritalStatus,
        this.userTypeName,
        this.doj,
        this.firstName,
        this.currentAddress,
        this.designationName,
        this.department,
        this.departmentName,
        this.aadharRegisNo,
        this.permanentAddress,
        this.empPhoto,
        this.branch,
        this.mobileNo,
        this.designation,
        this.skillType,
        this.dob,
        this.empStatus,
        this.emailId,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    userType = json['userType'];
    branchName = json['branchName'];
    aadharNo = json['aadharNo'];
    maritalStatus = json['maritalStatus'];
    userTypeName = json['userTypeName'];
    doj = json['doj'];
    firstName = json['firstName'];
    currentAddress = json['currentAddress'];
    designationName = json['designationName'];
    department = json['department'];
    departmentName = json['departmentName'];
    aadharRegisNo = json['aadharRegisNo'];
    permanentAddress = json['permanentAddress'];
    empPhoto = json['empPhoto'];
    branch = json['branch'];
    mobileNo = json['mobileNo'];
    designation = json['designation'];
    skillType = json['skillType'];
    dob = json['dob'];
    empStatus = json['empStatus'];
    emailId = json['emailId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['gender'] = this.gender;
    data['userType'] = this.userType;
    data['branchName'] = this.branchName;
    data['aadharNo'] = this.aadharNo;
    data['maritalStatus'] = this.maritalStatus;
    data['userTypeName'] = this.userTypeName;
    data['doj'] = this.doj;
    data['firstName'] = this.firstName;
    data['currentAddress'] = this.currentAddress;
    data['designationName'] = this.designationName;
    data['department'] = this.department;
    data['departmentName'] = this.departmentName;
    data['aadharRegisNo'] = this.aadharRegisNo;
    data['permanentAddress'] = this.permanentAddress;
    data['empPhoto'] = this.empPhoto;
    data['branch'] = this.branch;
    data['mobileNo'] = this.mobileNo;
    data['designation'] = this.designation;
    data['skillType'] = this.skillType;
    data['dob'] = this.dob;
    data['empStatus'] = this.empStatus;
    data['emailId'] = this.emailId;
    data['status'] = this.status;
    return data;
  }
}
