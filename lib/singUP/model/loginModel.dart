class LoginModel {
  String? status;
  String? message;
  String? accessToken;
  String? tokenType;
  String? userId;
  String? permissionsVersion;
  String? profileVersion;
  Data? data;
  MobileUser? user;
  MobileSession? session;
  EssPermissions? essPermissions;
  MssInfo? mss;
  List<ProfileList> profiles = [];
  List<String> permissions = [];

  LoginModel({
    this.status,
    this.message,
    this.accessToken,
    this.tokenType,
    this.userId,
    this.permissionsVersion,
    this.profileVersion,
    this.data,
    this.user,
    this.session,
    this.essPermissions,
    this.mss,
    List<ProfileList>? profiles,
    List<String>? permissions,
  }) : profiles = profiles ?? [],
       permissions = permissions ?? [];

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toString();
    message = json['message']?.toString();
    accessToken = json['accessToken']?.toString();
    tokenType = json['tokenType']?.toString() ?? 'Bearer';
    userId = json['userId']?.toString();
    permissionsVersion = json['permissionsVersion']?.toString();
    profileVersion = json['profileVersion']?.toString();
    permissions = _stringList(json['permissions']);
    profiles = _profileList(json['profiles']);
    user =
        json['user'] is Map<String, dynamic>
            ? MobileUser.fromJson(json['user'])
            : null;
    session =
        json['session'] is Map<String, dynamic>
            ? MobileSession.fromJson(json['session'])
            : null;
    essPermissions =
        json['essPermissions'] is Map<String, dynamic>
            ? EssPermissions.fromJson(json['essPermissions'])
            : null;
    mss =
        json['mss'] is Map<String, dynamic>
            ? MssInfo.fromJson(json['mss'])
            : null;

    if (json['data'] is Map<String, dynamic>) {
      data = Data.fromJson(json['data']);
    } else {
      data = Data.fromMobileJson(json);
    }
  }

  bool get isSuccess =>
      (status ?? data?.result ?? '').toUpperCase() == 'SUCCESS' ||
      data?.result?.toLowerCase() == 'success';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['status'] = status;
    json['message'] = message;
    json['accessToken'] = accessToken;
    json['tokenType'] = tokenType;
    json['userId'] = userId;
    json['permissionsVersion'] = permissionsVersion;
    json['profileVersion'] = profileVersion;
    json['permissions'] = permissions;
    json['profiles'] = profiles.map((v) => v.toJson()).toList();
    if (user != null) json['user'] = user!.toJson();
    if (session != null) json['session'] = session!.toJson();
    if (essPermissions != null)
      json['essPermissions'] = essPermissions!.toJson();
    if (mss != null) json['mss'] = mss!.toJson();
    if (data != null) json['data'] = data!.toJson();
    return json;
  }
}

class Data {
  int? empId;
  String? odReq;
  String? compOff;
  var bankName;
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
  String? accessToken;
  String? tokenType;
  String? permissionsVersion;
  String? profileVersion;

  Data({
    this.empId,
    this.odReq,
    this.compOff,
    this.bankName,
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
    this.profileList,
    this.sessionId,
    this.aadharNo,
    this.helpdesk,
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
    this.accessToken,
    this.tokenType,
    this.permissionsVersion,
    this.profileVersion,
  });

  Data.fromJson(Map<String, dynamic> json) {
    empId = _intValue(json['empId']);
    odReq = json['odReq']?.toString();
    compOff = json['compOff']?.toString();
    bankName = json['bankName'];
    bankAccNo = json['bankAccNo'];
    branch = json['branch']?.toString();
    orgId = _intValue(json['orgId']);
    result = json['result']?.toString();
    userImage = json['userImage']?.toString();
    expired = _boolValue(json['expired']) ?? false;
    latestVersionCode = json['latest_version_code']?.toString();
    contact = json['contact']?.toString();
    roRole = _stringList(json['roRole']);
    department = json['department']?.toString();
    userPanel = json['userPanel']?.toString();
    ifscCode = json['ifscCode'];
    adminrole = _stringList(json['adminrole']);
    branchId = _intValue(json['branchId']);
    orgName = json['orgName']?.toString();
    pfNo = json['pfNo'];
    userLoginned =
        json['userLoginned'] is Map<String, dynamic>
            ? UserLoginned.fromJson(json['userLoginned'])
            : UserLoginned();
    mobAction = _mobActionList(json['mobAction']);
    profileList = _profileList(json['profileList']);
    sessionId = json['sessionId']?.toString();
    aadharNo = json['aadharNo'];
    helpdesk = json['helpdesk']?.toString();
    empCode = json['empCode']?.toString();
    dob = json['dob']?.toString();
    esicNo = json['esicNo'];
    empRole = _stringList(json['empRole']);
    designation = json['designation']?.toString();
    needUpdation = _intValue(json['need_updation']) ?? 0;
    doj = json['doj']?.toString();
    enrollId = json['enrollId']?.toString();
    startDate = json['startDate']?.toString();
    endDate = json['endDate']?.toString();
    raisedDate = json['raisedDeadlineDate']?.toString();
    approvedDate = json['approvelDeadlineDate']?.toString();
    accessToken = json['accessToken']?.toString();
    tokenType = json['tokenType']?.toString();
    permissionsVersion = json['permissionsVersion']?.toString();
    profileVersion = json['profileVersion']?.toString();
  }

  factory Data.fromMobileJson(Map<String, dynamic> json) {
    final userJson =
        json['user'] is Map<String, dynamic>
            ? json['user'] as Map<String, dynamic>
            : <String, dynamic>{};
    final sessionJson =
        json['session'] is Map<String, dynamic>
            ? json['session'] as Map<String, dynamic>
            : <String, dynamic>{};
    final essJson =
        json['essPermissions'] is Map<String, dynamic>
            ? json['essPermissions'] as Map<String, dynamic>
            : <String, dynamic>{};
    final permissions = _stringList(json['permissions']);
    final essPermissionIds = _stringList(essJson['securityGroupIds']);
    final profileList = _profileList(json['profiles']);

    return Data(
      empId: _intValue(userJson['employeeId']) ?? 0,
      orgId: _intValue(userJson['orgId']),
      orgName: userJson['orgName']?.toString() ?? '',
      result:
          (json['status']?.toString().toUpperCase() == 'SUCCESS')
              ? 'success'
              : json['status']?.toString(),
      userImage: userJson['image']?.toString() ?? '',
      expired: false,
      roRole: profileList.isNotEmpty ? <String>['MSS'] : <String>[],
      adminrole:
          permissions.any((p) => p.toUpperCase().contains('ADMIN'))
              ? <String>['ADMIN']
              : <String>[],
      userPanel: profileList.isNotEmpty ? 'MSS' : 'COMPANY_EMPLOYEE',
      userLoginned: UserLoginned(
        name: userJson['name']?.toString(),
        userId: json['userId']?.toString(),
        status: 'ACTIVE',
        userType: 'COMPANY_EMPLOYEE',
        loggedIn: true,
        showPayroll:
            essPermissionIds.contains('ESS_PAYSLIP') ||
            essPermissionIds.contains('ESS_PAYSLIP_VIEW'),
        companySetup: true,
      ),
      mobAction: <MobAction>[],
      bankName: '',
      bankAccNo: '',
      branch: '',
      contact: '',
      department: '',
      ifscCode: '',
      pfNo: '',
      aadharNo: '',
      dob: '',
      esicNo: '',
      designation: '',
      doj: '',
      enrollId: '',
      startDate: '0',
      endDate: '0',
      raisedDate: '',
      approvedDate: '',
      profileList: profileList,
      sessionId: sessionJson['sessionId']?.toString(),
      empCode: userJson['employeeId']?.toString() ?? '',
      empRole:
          permissions.contains('COMPANY_EMPLOYEE') ||
                  essPermissionIds.isNotEmpty
              ? <String>['COMPANY_EMPLOYEE']
              : <String>[],
      needUpdation: 0,
      accessToken: json['accessToken']?.toString(),
      tokenType: json['tokenType']?.toString() ?? 'Bearer',
      permissionsVersion: json['permissionsVersion']?.toString(),
      profileVersion: json['profileVersion']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empId'] = empId;
    data['odReq'] = odReq;
    data['compOff'] = compOff;
    data['bankName'] = bankName;
    data['bankAccNo'] = bankAccNo;
    data['branch'] = branch;
    data['orgId'] = orgId;
    data['result'] = result;
    data['userImage'] = userImage;
    data['expired'] = expired;
    data['latest_version_code'] = latestVersionCode;
    data['contact'] = contact;
    data['roRole'] = roRole ?? <String>[];
    data['department'] = department;
    data['userPanel'] = userPanel;
    data['ifscCode'] = ifscCode;
    data['adminrole'] = adminrole ?? <String>[];
    data['branchId'] = branchId;
    data['orgName'] = orgName;
    data['pfNo'] = pfNo;
    if (userLoginned != null) data['userLoginned'] = userLoginned!.toJson();
    data['mobAction'] =
        (mobAction ?? <MobAction>[]).map((v) => v.toJson()).toList();
    data['profileList'] =
        (profileList ?? <ProfileList>[]).map((v) => v.toJson()).toList();
    data['sessionId'] = sessionId;
    data['aadharNo'] = aadharNo;
    data['helpdesk'] = helpdesk;
    data['empCode'] = empCode;
    data['dob'] = dob;
    data['esicNo'] = esicNo;
    data['empRole'] = empRole ?? <String>[];
    data['designation'] = designation;
    data['need_updation'] = needUpdation;
    data['doj'] = doj;
    data['enrollId'] = enrollId;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['raisedDeadlineDate'] = raisedDate;
    data['approvelDeadlineDate'] = approvedDate;
    data['accessToken'] = accessToken;
    data['tokenType'] = tokenType;
    data['permissionsVersion'] = permissionsVersion;
    data['profileVersion'] = profileVersion;
    return data;
  }
}

class MobileUser {
  String? name;
  String? employeeId;
  int? orgId;
  String? orgName;
  String? image;
  String? isOld;
  String? suspend;

  MobileUser({
    this.name,
    this.employeeId,
    this.orgId,
    this.orgName,
    this.image,
    this.isOld,
    this.suspend,
  });

  MobileUser.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
    employeeId = json['employeeId']?.toString();
    orgId = _intValue(json['orgId']);
    orgName = json['orgName']?.toString();
    image = json['image']?.toString();
    isOld = json['isOld']?.toString();
    suspend = json['suspend']?.toString();
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'employeeId': employeeId,
    'orgId': orgId,
    'orgName': orgName,
    'image': image,
    'isOld': isOld,
    'suspend': suspend,
  };
}

class MobileSession {
  String? sessionId;
  String? status;
  String? userId;
  int? employeeId;
  int? orgId;
  String? createdAt;
  String? lastSeenAt;
  String? expiresAt;

  MobileSession({
    this.sessionId,
    this.status,
    this.userId,
    this.employeeId,
    this.orgId,
    this.createdAt,
    this.lastSeenAt,
    this.expiresAt,
  });

  MobileSession.fromJson(Map<String, dynamic> json) {
    sessionId = json['sessionId']?.toString();
    status = json['status']?.toString();
    userId = json['userId']?.toString();
    employeeId = _intValue(json['employeeId']);
    orgId = _intValue(json['orgId']);
    createdAt = json['createdAt']?.toString();
    lastSeenAt = json['lastSeenAt']?.toString();
    expiresAt = json['expiresAt']?.toString();
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'sessionId': sessionId,
    'status': status,
    'userId': userId,
    'employeeId': employeeId,
    'orgId': orgId,
    'createdAt': createdAt,
    'lastSeenAt': lastSeenAt,
    'expiresAt': expiresAt,
  };
}

class EssPermissions {
  int? total;
  List<String> securityGroupIds = [];

  EssPermissions({this.total, List<String>? securityGroupIds})
    : securityGroupIds = securityGroupIds ?? [];

  EssPermissions.fromJson(Map<String, dynamic> json) {
    total = _intValue(json['total']);
    securityGroupIds = _stringList(json['securityGroupIds']);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'total': total,
    'securityGroupIds': securityGroupIds,
  };
}

class MssInfo {
  bool enabled = false;
  List<ProfileList> profiles = [];
  List<String> permissions = [];

  MssInfo({
    this.enabled = false,
    List<ProfileList>? profiles,
    List<String>? permissions,
  }) : profiles = profiles ?? [],
       permissions = permissions ?? [];

  MssInfo.fromJson(Map<String, dynamic> json) {
    enabled = _boolValue(json['enabled']) ?? false;
    profiles = _profileList(json['profiles']);
    permissions = _stringList(json['permissions']);
    profiles = _profileList(json['profiles']);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'enabled': enabled,
    'profiles': profiles.map((v) => v.toJson()).toList(),
    'permissions': permissions,
  };
}

class UserLoginned {
  String? name;
  dynamic password;
  String? userId;
  String? status;
  String? userType;
  dynamic salt;
  dynamic otp;
  bool? accountSuspended;
  dynamic userProfileImage;
  dynamic otpExpiryDateTime;
  String? firstLoginDate;
  bool? loggedIn;
  bool? showPayroll;
  bool? companySetup;

  UserLoginned({
    this.name,
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
    this.companySetup,
  });

  UserLoginned.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
    password = json['password'];
    userId = json['userId']?.toString();
    status = json['status']?.toString();
    userType = json['userType']?.toString();
    salt = json['salt'];
    otp = json['otp'];
    accountSuspended = _boolValue(json['accountSuspended']);
    userProfileImage = json['userProfileImage'];
    otpExpiryDateTime = json['otpExpiryDateTime'];
    firstLoginDate = json['firstLoginDate']?.toString();
    loggedIn = _boolValue(json['loggedIn']);
    showPayroll = _boolValue(json['showPayroll']);
    companySetup = _boolValue(json['companySetup']);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'password': password,
    'userId': userId,
    'status': status,
    'userType': userType,
    'salt': salt,
    'otp': otp,
    'accountSuspended': accountSuspended,
    'userProfileImage': userProfileImage,
    'otpExpiryDateTime': otpExpiryDateTime,
    'firstLoginDate': firstLoginDate,
    'loggedIn': loggedIn,
    'showPayroll': showPayroll,
    'companySetup': companySetup,
  };
}

class MobAction {
  String? distance;
  dynamic geofenceActive;
  String? mobAction;
  String? attAction;
  String? time;

  MobAction({
    this.distance,
    this.geofenceActive,
    this.mobAction,
    this.attAction,
    this.time,
  });

  MobAction.fromJson(Map<String, dynamic> json) {
    distance = json['distance']?.toString();
    geofenceActive = json['geofenceActive'];
    mobAction = json['mobAction']?.toString();
    attAction = json['attAction']?.toString();
    time = json['time']?.toString();
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'distance': distance,
    'geofenceActive': geofenceActive,
    'mobAction': mobAction,
    'attAction': attAction,
    'time': time,
  };
}

class ProfileList {
  dynamic profileName;
  dynamic roMapId;
  dynamic defaultProfile;
  List<String> profilePermission = <String>[];
  dynamic profileId;
  dynamic profileCode;
  dynamic mappedID;
  dynamic isDefaultProfile;
  dynamic userId;

  ProfileList({
    this.profileName,
    this.roMapId,
    this.defaultProfile,
    this.profilePermission = const <String>[],
    this.profileId,
    this.profileCode,
    this.mappedID,
    this.isDefaultProfile,
    this.userId,
  });

  ProfileList.fromJson(Map<String, dynamic> json) {
    profileName = json['profileName'] ?? json['displayName'];
    roMapId = json['roMapId'];
    defaultProfile = json['defaultProfile'];
    profilePermission = _stringList(
      json['profilePermission'] ?? json['permissions'],
    );
    profileId = json['profileId'];
    profileCode = json['profileCode'];
    mappedID = json['mappedID'] ?? json['mappingId'];
    isDefaultProfile = json['isDefaultProfile'] ?? json['mapped'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'profileName': profileName,
    'roMapId': roMapId,
    'defaultProfile': defaultProfile,
    'profilePermission': profilePermission,
    'profileId': profileId,
    'profileCode': profileCode,
    'mappedID': mappedID,
    'isDefaultProfile': isDefaultProfile,
    'userId': userId,
  };
}

List<String> _stringList(dynamic value) {
  if (value == null) return <String>[];
  if (value is List)
    return value
        .where((item) => item != null)
        .map((item) => item.toString())
        .toList();
  return <String>[value.toString()];
}

List<MobAction> _mobActionList(dynamic value) {
  if (value is! List) return <MobAction>[];
  return value
      .whereType<Map<String, dynamic>>()
      .map(MobAction.fromJson)
      .toList();
}

List<ProfileList> _profileList(dynamic value) {
  if (value is! List) return <ProfileList>[];
  return value
      .whereType<Map<String, dynamic>>()
      .map(ProfileList.fromJson)
      .toList();
}

int? _intValue(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

bool? _boolValue(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;
  final normalized = value.toString().toLowerCase();
  if (normalized == 'true' || normalized == '1' || normalized == 'yes')
    return true;
  if (normalized == 'false' || normalized == '0' || normalized == 'no')
    return false;
  return null;
}
