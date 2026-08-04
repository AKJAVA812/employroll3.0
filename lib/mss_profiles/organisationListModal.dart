class OrganisationListModal {
  List<OrgList>? list;

  OrganisationListModal({this.list});

  OrganisationListModal.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <OrgList>[];
      json['list'].forEach((v) {
        list!.add(OrgList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrgList {
  String? orgName;
  String? displayName;
  String? id;

  OrgList({this.orgName, this.displayName, this.id});

  OrgList.fromJson(Map<String, dynamic> json) {
    orgName = json['orgName'];
    displayName = json['displayName'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['orgName'] = this.orgName;
    data['displayName'] = this.displayName;
    data['id'] = this.id;
    return data;
  }
}
