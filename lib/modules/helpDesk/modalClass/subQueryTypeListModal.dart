class SubQueryTypeListModal {
  List<Statusdata>? statusdata;

  SubQueryTypeListModal({this.statusdata});

  SubQueryTypeListModal.fromJson(Map<String, dynamic> json) {
    if (json['statusdata'] != null) {
      statusdata = <Statusdata>[];
      json['statusdata'].forEach((v) {
        statusdata!.add(Statusdata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.statusdata != null) {
      data['statusdata'] = this.statusdata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Statusdata {
  String? code;
  String? subQueryname;
  String? queryName;
  String? description;
  int? id;
  String? dept;
  String? branchDeptId;
  String? status;

  Statusdata(
      {this.code,
        this.subQueryname,
        this.queryName,
        this.description,
        this.id,
        this.dept,
        this.branchDeptId,
        this.status});

  Statusdata.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    subQueryname = json['subQueryname'];
    queryName = json['queryName'];
    description = json['description'];
    id = json['id'];
    dept = json['dept'];
    branchDeptId = json['branchDeptId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.code;
    data['subQueryname'] = this.subQueryname;
    data['queryName'] = this.queryName;
    data['description'] = this.description;
    data['id'] = this.id;
    data['dept'] = this.dept;
    data['branchDeptId'] = this.branchDeptId;
    data['status'] = this.status;
    return data;
  }
}
