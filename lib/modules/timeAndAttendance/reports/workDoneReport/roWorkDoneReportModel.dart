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
    final Map<String, dynamic> data = <String, dynamic>{};
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['empId'] = empId;
    data['image'] = image;
    data['cMailId'] = cMailId;
    data['empCode'] = empCode;
    data['cAddress'] = cAddress;
    data['cName'] = cName;
    data['empName'] = empName;
    data['branchName'] = branchName;
    data['cNumber'] = cNumber;
    data['remark'] = remark;
    data['time'] = time;
    return data;
  }
}
