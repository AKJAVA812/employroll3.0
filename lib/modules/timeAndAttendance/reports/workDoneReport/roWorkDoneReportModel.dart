class ROWorkdoneReportModel {
  List<Data>? data;

  ROWorkdoneReportModel({this.data});

  ROWorkdoneReportModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? date;
  int? empId;
  String? image;
  String? cMailId;
  String? empCode;
  String? cAddress;
  String? cName;
  String? empName;
  String? branchName;
  String? cNumber;
  String? remark;
  String? time;

  Data(
      {this.date,
        this.empId,
        this.image,
        this.cMailId,
        this.empCode,
        this.cAddress,
        this.cName,
        this.empName,
        this.branchName,
        this.cNumber,
        this.remark,
        this.time});

  Data.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    empId = json['empId'];
    image = json['image'];
    cMailId = json['cMailId'];
    empCode = json['empCode'];
    cAddress = json['cAddress'];
    cName = json['cName'];
    empName = json['empName'];
    branchName = json['branchName'];
    cNumber = json['cNumber'];
    remark = json['remark'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['date'] = this.date;
    data['empId'] = this.empId;
    data['image'] = this.image;
    data['cMailId'] = this.cMailId;
    data['empCode'] = this.empCode;
    data['cAddress'] = this.cAddress;
    data['cName'] = this.cName;
    data['empName'] = this.empName;
    data['branchName'] = this.branchName;
    data['cNumber'] = this.cNumber;
    data['remark'] = this.remark;
    data['time'] = this.time;
    return data;
  }
}
