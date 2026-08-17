class EmployeeListFaceModel {
  List<Data>? data;

  EmployeeListFaceModel({this.data});

  EmployeeListFaceModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? empId;
  String? empContactNo;
  bool? face;
  String? empCode;
  String? empName;
  String? empEmail;
  String? empPhoto;

  Data(
      {this.empId,
        this.empContactNo,
        this.face,
        this.empCode,
        this.empName,
        this.empEmail,
        this.empPhoto});

  Data.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    empContactNo = json['empContactNo'];
    face = json['face'];
    empCode = json['empCode'];
    empName = json['empName'];
    empEmail = json['empEmail'];
    empPhoto = json['empPhoto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empId'] = empId;
    data['empContactNo'] = empContactNo;
    data['face'] = face;
    data['empCode'] = empCode;
    data['empName'] = empName;
    data['empEmail'] = empEmail;
    data['empPhoto'] = empPhoto;
    return data;
  }
}
