class AdminLoginModal {
  Data? data;

  AdminLoginModal({this.data});

  AdminLoginModal.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? branchId;
  String? odReq;
  UserLoginned? userLoginned;
  List<Null>? mobAction;
  List<String>? userPermissions;
  String? sessionId;
  int? orgId;
  String? helpdesk;
  String? result;
  List<String>? userRoles;
  String? userImage;
  bool? expired;
  List<Null>? roRole;
  List<Null>? empRole;
  List<String>? adminrole;

  Data(
      {this.branchId,
        this.odReq,
        this.userLoginned,
        this.mobAction,
        this.userPermissions,
        this.sessionId,
        this.orgId,
        this.helpdesk,
        this.result,
        this.userRoles,
        this.userImage,
        this.expired,
        this.roRole,
        this.empRole,
        this.adminrole});

  Data.fromJson(Map<String, dynamic> json) {
    branchId = json['branchId'];
    odReq = json['odReq'];
    userLoginned = json['userLoginned'] != null
        ? UserLoginned.fromJson(json['userLoginned'])
        : null;

    userPermissions = json['userPermissions'].cast<String>();
    sessionId = json['sessionId'];
    orgId = json['orgId'];
    helpdesk = json['helpdesk'];
    result = json['result'];
    userRoles = json['userRoles'].cast<String>();
    userImage = json['userImage'];
    expired = json['expired'];


    adminrole = json['adminrole'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['branchId'] = this.branchId;
    data['odReq'] = this.odReq;
    if (this.userLoginned != null) {
      data['userLoginned'] = this.userLoginned!.toJson();
    }

    data['userPermissions'] = this.userPermissions;
    data['sessionId'] = this.sessionId;
    data['orgId'] = this.orgId;
    data['helpdesk'] = this.helpdesk;
    data['result'] = this.result;
    data['userRoles'] = this.userRoles;
    data['userImage'] = this.userImage;
    data['expired'] = this.expired;
    data['adminrole'] = this.adminrole;
    return data;
  }
}

class UserLoginned {
  String? userId;
  Null? otp;
  String? userType;
  bool? accountSuspended;
  bool? loggedIn;
  Null? otpExpiryDateTime;
  Null? userProfileImage;
  String? firstLoginDate;
  bool? companySetup;
  bool? showPayroll;
  Null? salt;
  String? status;
  Null? password;
  String? name;

  UserLoginned(
      {this.userId,
        this.otp,
        this.userType,
        this.accountSuspended,
        this.loggedIn,
        this.otpExpiryDateTime,
        this.userProfileImage,
        this.firstLoginDate,
        this.companySetup,
        this.showPayroll,
        this.salt,
        this.status,
        this.password,
        this.name});

  UserLoginned.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    otp = json['otp'];
    userType = json['userType'];
    accountSuspended = json['accountSuspended'];
    loggedIn = json['loggedIn'];
    otpExpiryDateTime = json['otpExpiryDateTime'];
    userProfileImage = json['userProfileImage'];
    firstLoginDate = json['firstLoginDate'];
    companySetup = json['companySetup'];
    showPayroll = json['showPayroll'];
    salt = json['salt'];
    status = json['status'];
    password = json['password'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['userId'] = this.userId;
    data['otp'] = this.otp;
    data['userType'] = this.userType;
    data['accountSuspended'] = this.accountSuspended;
    data['loggedIn'] = this.loggedIn;
    data['otpExpiryDateTime'] = this.otpExpiryDateTime;
    data['userProfileImage'] = this.userProfileImage;
    data['firstLoginDate'] = this.firstLoginDate;
    data['companySetup'] = this.companySetup;
    data['showPayroll'] = this.showPayroll;
    data['salt'] = this.salt;
    data['status'] = this.status;
    data['password'] = this.password;
    data['name'] = this.name;
    return data;
  }
}
