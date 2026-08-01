class ProfileListModal {
  List<ProfileData>? data;

  ProfileListModal({this.data});

  ProfileListModal.fromJson(Map<String, dynamic> json) {
    data = <ProfileData>[];
    final source = json['data'] ?? json['profiles'];
    if (source is List) {
      for (final v in source) {
        if (v is Map<String, dynamic>) {
          data!.add(ProfileData.fromJson(v));
        } else if (v is Map) {
          data!.add(ProfileData.fromJson(Map<String, dynamic>.from(v)));
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProfileData {
  String? profileName;
  List<String>? profilePermission;
  int? roMapId;
  int? profileId;
  String? profileCode;
  bool? defaultProfile;
  int? mappedID;
  bool? isDefaultProfile;
  int? userId;

  ProfileData({
    this.profileName,
    this.profilePermission,
    this.roMapId,
    this.profileId,
    this.profileCode,
    this.defaultProfile,
    this.mappedID,
    this.isDefaultProfile,
    this.userId,
  });

  ProfileData.fromJson(Map<String, dynamic> json) {
    profileName = (json['profileName'] ?? json['displayName'])?.toString();
    profilePermission = _stringList(
      json['profilePermission'] ?? json['permissions'],
    );
    roMapId = _intValue(json['roMapId'] ?? json['mappingId']);
    profileId = _intValue(json['profileId']);
    profileCode = json['profileCode']?.toString();
    defaultProfile = _boolValue(json['defaultProfile']);
    mappedID = _intValue(json['mappedID'] ?? json['mappingId']);
    isDefaultProfile = _boolValue(
      json['isDefaultProfile'] ?? json['defaultProfile'],
    );
    userId = _intValue(json['userId']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profileName'] = this.profileName;
    data['profilePermission'] = this.profilePermission ?? <String>[];
    data['roMapId'] = this.roMapId;
    data['profileId'] = this.profileId;
    data['profileCode'] = this.profileCode;
    data['defaultProfile'] = this.defaultProfile;
    data['mappedID'] = this.mappedID;
    data['isDefaultProfile'] = this.isDefaultProfile;
    data['userId'] = this.userId;
    return data;
  }
}

List<String> _stringList(dynamic value) {
  if (value == null) return <String>[];
  if (value is List) {
    return value
        .where((item) => item != null)
        .map((item) => item.toString())
        .toList();
  }
  return <String>[value.toString()];
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
