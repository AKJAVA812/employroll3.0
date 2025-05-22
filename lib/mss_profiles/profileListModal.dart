class ProfileListModal {
  List<ProfileData>? data;
  bool? defaultEss;

  ProfileListModal({this.data, this.defaultEss});

  ProfileListModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ProfileData>[];
      json['data'].forEach((v) {
        data!.add(new ProfileData.fromJson(v));
      });
    }
    defaultEss = json['defaultEss'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['defaultEss'] = this.defaultEss;
    return data;
  }
}

class ProfileData {
  String? profileName;
  int? roMapId;
  int? profileId;
  String? profileCode;
  bool? defaultProfile;
  int? mappedID;
  bool? isDefaultProfile;
  int? userId;

  ProfileData(
      {this.profileName,
        this.roMapId,
        this.profileId,
        this.profileCode,
        this.defaultProfile,
        this.mappedID,
        this.isDefaultProfile,
        this.userId});

  ProfileData.fromJson(Map<String, dynamic> json) {
    profileName = json['profileName'];
    roMapId = json['roMapId'];
    profileId = json['profileId'];
    profileCode = json['profileCode'];
    defaultProfile = json['defaultProfile'];
    mappedID = json['mappedID'];
    isDefaultProfile = json['isDefaultProfile'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profileName'] = this.profileName;
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
