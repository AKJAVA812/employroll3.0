class OrganisationListModal {
  List<OrgList>? list;
  int? parentOrgId;

  OrganisationListModal({this.list, this.parentOrgId});

  OrganisationListModal.fromJson(Map<String, dynamic> json) {
    final source = json['list'] ?? json['data'];
    if (source != null) {
      list = <OrgList>[];
      source.forEach((v) {
        list!.add(OrgList.fromJson(v));
      });
    }
    parentOrgId = _intValue(json['parentOrgId'] ?? json['parent_org_id']);
    if (parentOrgId == null && (list?.isNotEmpty ?? false)) {
      parentOrgId = list!.first.parentOrgId;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    data['parentOrgId'] = parentOrgId;
    return data;
  }

  static int? _intValue(dynamic value) {
    if (value is int) return value;
    return value == null ? null : int.tryParse(value.toString());
  }
}

class OrgList {
  String? orgName;
  String? displayName;
  String? id;
  int? parentOrgId;
  String? parentName;

  OrgList({
    this.orgName,
    this.displayName,
    this.id,
    this.parentOrgId,
    this.parentName,
  });

  OrgList.fromJson(Map<String, dynamic> json) {
    orgName = json['orgName'] ?? json['organisationName'] ?? json['name'];
    displayName = json['displayName'];
    id = (json['id'] ?? json['orgId'] ?? json['organisationId'])?.toString();
    parentOrgId = OrganisationListModal._intValue(
      json['parentOrgId'] ?? json['parentId'] ?? json['parent_org_id'],
    );
    parentName = json['parentName']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['orgName'] = this.orgName;
    data['displayName'] = this.displayName;
    data['id'] = this.id;
    data['parentOrgId'] = this.parentOrgId;
    data['parentName'] = this.parentName;
    return data;
  }
}
