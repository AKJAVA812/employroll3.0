class AdminLoginModal {
  Data? data;

  AdminLoginModal({this.data});

  AdminLoginModal.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['branchId'] = branchId;
    data['odReq'] = odReq;
    if (userLoginned != null) {
      data['userLoginned'] = userLoginned!.toJson();
    }

    data['userPermissions'] = userPermissions;
    data['sessionId'] = sessionId;
    data['orgId'] = orgId;
    data['helpdesk'] = helpdesk;
    data['result'] = result;
    data['userRoles'] = userRoles;
    data['userImage'] = userImage;
    data['expired'] = expired;
    data['adminrole'] = adminrole;
    return data;
  }
}

class UserLoginned {
  String? userId;
  Null otp;
  String? userType;
  bool? accountSuspended;
  bool? loggedIn;
  Null otpExpiryDateTime;
  Null userProfileImage;
  String? firstLoginDate;
  bool? companySetup;
  bool? showPayroll;
  Null salt;
  String? status;
  Null password;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['otp'] = otp;
    data['userType'] = userType;
    data['accountSuspended'] = accountSuspended;
    data['loggedIn'] = loggedIn;
    data['otpExpiryDateTime'] = otpExpiryDateTime;
    data['userProfileImage'] = userProfileImage;
    data['firstLoginDate'] = firstLoginDate;
    data['companySetup'] = companySetup;
    data['showPayroll'] = showPayroll;
    data['salt'] = salt;
    data['status'] = status;
    data['password'] = password;
    data['name'] = name;
    return data;
  }
}
