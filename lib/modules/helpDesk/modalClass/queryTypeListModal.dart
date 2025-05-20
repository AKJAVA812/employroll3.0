class QueryTypeListModal {
  List<Statusdata>? statusdata;

  QueryTypeListModal({this.statusdata});

  QueryTypeListModal.fromJson(Map<String, dynamic> json) {
    if (json['statusdata'] != null) {
      statusdata = <Statusdata>[];
      json['statusdata'].forEach((v) {
        statusdata!.add(new Statusdata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.statusdata != null) {
      data['statusdata'] = this.statusdata!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['emailid'] = this.emailid;
    data['id'] = this.id;
    data['dept'] = this.dept;
    data['branchDeptId'] = this.branchDeptId;
    data['status'] = this.status;
    return data;
  }
}
