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
    final Map<String, dynamic> data = <String, dynamic>{};
    if (statusdata != null) {
      data['statusdata'] = statusdata!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['subQueryname'] = subQueryname;
    data['queryName'] = queryName;
    data['description'] = description;
    data['id'] = id;
    data['dept'] = dept;
    data['branchDeptId'] = branchDeptId;
    data['status'] = status;
    return data;
  }
}
