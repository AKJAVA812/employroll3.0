class SelfRequisitionModel {
  List<Data>? data;

  SelfRequisitionModel({this.data});

  SelfRequisitionModel.fromJson(Map<String, dynamic> json) {
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
  String? inTime;
  String? empId;
  String? employeeName;
  String? inTimeRemark;
  String? reqDate;
  int? empDetailsId;
  String? outTimeRemark;
  String? creationDate;
  String? outTime;
  int? reqId;
  String? status;

  Data(
      {this.inTime,
        this.empId,
        this.employeeName,
        this.inTimeRemark,
        this.reqDate,
        this.empDetailsId,
        this.outTimeRemark,
        this.creationDate,
        this.outTime,
        this.reqId,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    inTime = json['inTime'];
    empId = json['empId'];
    employeeName = json['employeeName'];
    inTimeRemark = json['inTimeRemark'];
    reqDate = json['reqDate'];
    empDetailsId = json['empDetailsId'];
    outTimeRemark = json['outTimeRemark'];
    creationDate = json['creationDate'];
    outTime = json['outTime'];
    reqId = json['reqId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inTime'] = this.inTime;
    data['empId'] = this.empId;
    data['employeeName'] = this.employeeName;
    data['inTimeRemark'] = this.inTimeRemark;
    data['reqDate'] = this.reqDate;
    data['empDetailsId'] = this.empDetailsId;
    data['outTimeRemark'] = this.outTimeRemark;
    data['creationDate'] = this.creationDate;
    data['outTime'] = this.outTime;
    data['reqId'] = this.reqId;
    data['status'] = this.status;
    return data;
  }
}
