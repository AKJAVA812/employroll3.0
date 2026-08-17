class EmployeeListModel {
  List<Data>? data;

  EmployeeListModel({this.data});

  EmployeeListModel.fromJson(Map<String, dynamic> json) {
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
  var empId;
  String? empContactNo;
  String? empName;
  int? empdetailsId;
  String? empEmail;
  String? devicestatus;
  String? empDept;
  String? empPhoto;

  Data(
      {this.empId,
        this.empContactNo,
        this.empName,
        this.empdetailsId,
        this.empEmail,
        this.devicestatus,
        this.empDept,
        this.empPhoto});

  Data.fromJson(Map<String, dynamic> json) {
    empId = json['empId'];
    empContactNo = json['empContactNo'];
    empName = json['empName'];
    empdetailsId = json['empdetailsId'];
    empEmail = json['empEmail'];
    devicestatus = json['devicestatus'];
    empDept = json['empDept'];
    empPhoto = json['empPhoto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empId'] = empId;
    data['empContactNo'] = empContactNo;
    data['empName'] = empName;
    data['empdetailsId'] = empdetailsId;
    data['empEmail'] = empEmail;
    data['devicestatus'] = devicestatus;
    data['empDept'] = empDept;
    data['empPhoto'] = empPhoto;
    return data;
  }
}