class LoginModel {
  Data? data;

  LoginModel({this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? empId;
  String? odReq;
  String? compOff;
  var bankName;
  /*List<String>? userPermissions;*/
  var bankAccNo;
  String? branch;
  int? orgId;
  String? result;
  String? userImage;
  bool? expired;
  String? latestVersionCode;
  String? contact;
  List<String>? roRole;
  String? userPanel;
  String? department;
  var ifscCode;
  List<String>? adminrole;
  int? branchId;
  String? orgName;
  var pfNo;
  UserLoginned? userLoginned;
  List<MobAction>? mobAction;
  List<ProfileList>? profileList;
  String? sessionId;
  var aadharNo;
  String? helpdesk;
  /*List<String>? userRoles;*/
  String? empCode;
  String? dob;
  var esicNo;
  List<String>? empRole;
  String? designation;
  int? needUpdation;
  String? doj;
  String? enrollId;
  String? startDate;
  String? endDate;
  String? raisedDate;
  String? approvedDate;

  Data(
      {this.empId,
        this.odReq,
        this.compOff,
        this.bankName,
       /* this.userPermissions,*/
        this.bankAccNo,
        this.branch,
        this.orgId,
        this.result,
        this.userImage,
        this.expired,
        this.latestVersionCode,
        this.contact,
        this.roRole,
        this.department,
        this.userPanel,
        this.ifscCode,
        this.adminrole,
        this.branchId,
        this.orgName,
        this.pfNo,
        this.userLoginned,
        this.mobAction,
        this.sessionId,
        this.aadharNo,
        this.helpdesk,
        /*this.userRoles,*/
        this.empCode,
        this.dob,
        this.esicNo,
        this.empRole,
        this.designation,
        this.needUpdation,
        this.doj,
        this.enrollId,
        this.startDate,
        this.endDate,
        this.raisedDate,
        this.approvedDate,
      });

  Data.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    odReq = json['odReq'];
    compOff = json['compOff'];
    bankName = json['bankName'];
   /* userPermissions = json['userPermissions'].cast<String>();*/
    bankAccNo = json['bankAccNo'];
    branch = json['branch'];
    orgId = json['orgId'];
    result = json['result'];
    userImage = json['userImage'];
    expired = json['expired'];
    latestVersionCode = json['latest_version_code'];
    contact = json['contact'];
    roRole = json['roRole'].cast<String>();
    department = json['department'];
    userPanel = json['userPanel'];
    ifscCode = json['ifscCode'];
    adminrole = json['adminrole'].cast<String>();
    branchId = json['branchId'];
    orgName = json['orgName'];
    pfNo = json['pfNo'];
    userLoginned = json['userLoginned'] != null
        ? new UserLoginned.fromJson(json['userLoginned'])
        : null;
    if (json['mobAction'] != null) {
      mobAction = <MobAction>[];
      json['mobAction'].forEach((v) {
        mobAction!.add(new MobAction.fromJson(v));
      });
    }
    if (json['profileList'] != null) {
      profileList = <ProfileList>[];
      json['profileList'].forEach((v) {
        profileList!.add(new ProfileList.fromJson(v));
      });
    }
    sessionId = json['sessionId'];
    aadharNo = json['aadharNo'];
    helpdesk = json['helpdesk'];
   /* userRoles = json['userRoles'].cast<String>();*/
    empCode = json['empCode'];
    dob = json['dob'];
    esicNo = json['esicNo'];
    empRole = json['empRole'].cast<String>();
    designation = json['designation'];
    needUpdation = json['need_updation'];
    doj = json['doj'];
    enrollId = json['enrollId'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    raisedDate = json['raisedDeadlineDate'];
    approvedDate = json['approvelDeadlineDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['odReq'] = this.odReq;
    data['compOff'] = this.compOff;
    data['bankName'] = this.bankName;
   /* data['userPermissions'] = this.userPermissions;*/
    data['bankAccNo'] = this.bankAccNo;
    data['branch'] = this.branch;
    data['orgId'] = this.orgId;
    data['result'] = this.result;
    data['userImage'] = this.userImage;
    data['expired'] = this.expired;
    data['latest_version_code'] = this.latestVersionCode;
    data['contact'] = this.contact;
    data['roRole'] = this.roRole;
    data['department'] = this.department;
    data['userPanel'] = this.userPanel;
    data['ifscCode'] = this.ifscCode;
    data['adminrole'] = this.adminrole;
    data['branchId'] = this.branchId;
    data['orgName'] = this.orgName;
    data['pfNo'] = this.pfNo;
    if (this.userLoginned != null) {
      data['userLoginned'] = this.userLoginned!.toJson();
    }
    if (this.mobAction != null) {
      data['mobAction'] = this.mobAction!.map((v) => v.toJson()).toList();
    }
    data['sessionId'] = this.sessionId;
    data['aadharNo'] = this.aadharNo;
    data['helpdesk'] = this.helpdesk;
   /* data['userRoles'] = this.userRoles;*/
    data['empCode'] = this.empCode;
    data['dob'] = this.dob;
    data['esicNo'] = esicNo;
    data['empRole'] = empRole;
    data['designation'] = designation;
    data['need_updation'] = needUpdation;
    data['doj'] = doj;
    data['enrollId'] = enrollId;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['raisedDeadlineDate']=raisedDate;
    data['approvelDeadlineDate']=approvedDate;
    return data;
  }
}

class UserLoginned {
  String? name;
  Null password;
  String? userId;
  String? status;
  String? userType;
  Null salt;
  Null otp;
  bool? accountSuspended;
  Null userProfileImage;
  Null otpExpiryDateTime;
  String? firstLoginDate;
  bool? loggedIn;
  bool? showPayroll;
  bool? companySetup;

  UserLoginned(
      {this.name,
        this.password,
        this.userId,
        this.status,
        this.userType,
        this.salt,
        this.otp,
        this.accountSuspended,
        this.userProfileImage,
        this.otpExpiryDateTime,
        this.firstLoginDate,
        this.loggedIn,
        this.showPayroll,
        this.companySetup});

  UserLoginned.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    password = json['password'];
    userId = json['userId'];
    status = json['status'];
    userType = json['userType'];
    salt = json['salt'];
    otp = json['otp'];
    accountSuspended = json['accountSuspended'];
    userProfileImage = json['userProfileImage'];
    otpExpiryDateTime = json['otpExpiryDateTime'];
    firstLoginDate = json['firstLoginDate'];
    loggedIn = json['loggedIn'];
    showPayroll = json['showPayroll'];
    companySetup = json['companySetup'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['password'] = this.password;
    data['userId'] = this.userId;
    data['status'] = this.status;
    data['userType'] = this.userType;
    data['salt'] = this.salt;
    data['otp'] = this.otp;
    data['accountSuspended'] = this.accountSuspended;
    data['userProfileImage'] = this.userProfileImage;
    data['otpExpiryDateTime'] = this.otpExpiryDateTime;
    data['firstLoginDate'] = this.firstLoginDate;
    data['loggedIn'] = this.loggedIn;
    data['showPayroll'] = this.showPayroll;
    data['companySetup'] = this.companySetup;
    return data;
  }
}

class MobAction {
  String? distance;
  dynamic geofenceActive;
  String? mobAction;
  String? attAction;
  String? time;

  MobAction({this.distance, this.geofenceActive, this.mobAction, this.attAction, this.time});

  MobAction.fromJson(Map<String, dynamic> json) {
    distance = json['distance'];
    geofenceActive = json['geofenceActive'];
    mobAction = json['mobAction'];
    attAction = json['attAction'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distance'] = this.distance;
    data['geofenceActive'] = this.geofenceActive;
    data['mobAction'] = this.mobAction;
    data['attAction'] = this.attAction;
    data['time'] = this.time;
    return data;
  }
}

class ProfileList {
  dynamic profileName;
  dynamic roMapId;
  dynamic defaultProfile;
  List<String>? profilePermission;
  dynamic profileId;
  dynamic profileCode;
  dynamic mappedID;
  dynamic isDefaultProfile;
  dynamic userId;

  ProfileList({this.profileName, this.roMapId, this.defaultProfile, this.profilePermission, this.profileId, this.profileCode, this.mappedID, this.isDefaultProfile, this.userId});

  ProfileList.fromJson(Map<String, dynamic> json) {
    profileName = json['profileName'];
    roMapId = json['roMapId'];
    defaultProfile = json['defaultProfile'];
    profilePermission = json['profilePermission'] != null
        ? List<String>.from(json['profilePermission'])
        : [];
    profileId = json['profileId'];
    profileCode = json['profileCode'];
    mappedID = json['mappedID'];
    isDefaultProfile = json['isDefaultProfile'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profileName'] = this.profileName;
    data['defaultProfile'] = this.defaultProfile;
    data['profilePermission'] = this.profilePermission;
    data['profileId'] = this.profileId;
    data['profileCode'] = this.profileCode;
    data['mappedID'] = this.mappedID;
    data['isDefaultProfile'] = this.isDefaultProfile;
    data['userId'] = this.userId;
    return data;
  }
}
