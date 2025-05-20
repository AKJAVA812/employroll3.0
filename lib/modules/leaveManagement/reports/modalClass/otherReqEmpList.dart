class RequistionEmpListModel {
  List<Data>? data;

  RequistionEmpListModel({this.data});

  RequistionEmpListModel.fromJson(Map<String, dynamic> json) {
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
  int? empId;
  String? deptName;
  String? empBranch;
  String? empName;

  Data({this.empId, this.deptName, this.empBranch, this.empName});

  Data.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    deptName = json['deptName'];
    empBranch = json['empBranch'];
    empName = json['empName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['empId'] = this.empId;
    data['deptName'] = this.deptName;
    data['empBranch'] = this.empBranch;
    data['empName'] = this.empName;
    return data;
  }
}
