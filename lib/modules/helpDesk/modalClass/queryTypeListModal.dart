class QueryTypeListModal {
  List<Statusdata>? statusdata;

  QueryTypeListModal({this.statusdata});

  QueryTypeListModal.fromJson(Map<String, dynamic> json) {
    if (json['statusdata'] != null) {
      statusdata = <Statusdata>[];
      json['statusdata'].forEach((v) {
        statusdata!.add(Statusdata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (statusdata != null) {
      data['statusdata'] = statusdata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Statusdata {
  String? name;
  String? description;
  String? emailid;
  int? id;
  String? dept;
  String? branchDeptId;
  String? status;

  Statusdata(
      {this.name,
        this.description,
        this.emailid,
        this.id,
        this.dept,
        this.branchDeptId,
        this.status});

  Statusdata.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    emailid = json['emailid'];
    id = json['id'];
    dept = json['dept'];
    branchDeptId = json['branchDeptId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['emailid'] = emailid;
    data['id'] = id;
    data['dept'] = dept;
    data['branchDeptId'] = branchDeptId;
    data['status'] = status;
    return data;
  }
}
