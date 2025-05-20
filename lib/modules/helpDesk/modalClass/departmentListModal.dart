class DepartmentListModal {
  List<Data>? data;

  DepartmentListModal({this.data});

  DepartmentListModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
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

class Data {
  String? deptName;
  int? branchDeptId;

  Data({this.deptName, this.branchDeptId});

  Data.fromJson(Map<String, dynamic> json) {
    deptName = json['deptName'];
    branchDeptId = json['branchDeptId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deptName'] = this.deptName;
    data['branchDeptId'] = this.branchDeptId;
    return data;
  }
}
