class DisapprovedRequisitionModel {
  List<Data>? data;

  DisapprovedRequisitionModel({this.data});

  DisapprovedRequisitionModel.fromJson(Map<String, dynamic> json) {
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
  String? outtime;
  String? actualInTime;
  String? remark;
  String? reqId;
  String? inTime;
  String? intimeRemarks;
  String? outtimeRemarks;
  String? reqDate;
  String? onDate;
  String? updationDate;
  String? empName;
  String? actualOutTime;
  String? status;

  Data(
      {this.outtime,
        this.actualInTime,
        this.remark,
        this.reqId,
        this.inTime,
        this.intimeRemarks,
        this.outtimeRemarks,
        this.reqDate,
        this.onDate,
        this.updationDate,
        this.empName,
        this.actualOutTime,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    outtime = json['outtime'];
    actualInTime = json['actualInTime'];
    remark = json['remark'];
    reqId = json['reqId'];
    inTime = json['inTime'];
    intimeRemarks = json['intimeRemarks'];
    outtimeRemarks = json['outtimeRemarks'];
    reqDate = json['reqDate'];
    onDate = json['onDate'];
    updationDate = json['updationDate'];
    empName = json['empName'];
    actualOutTime = json['actualOutTime'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['outtime'] = this.outtime;
    data['actualInTime'] = this.actualInTime;
    data['remark'] = this.remark;
    data['reqId'] = this.reqId;
    data['inTime'] = this.inTime;
    data['intimeRemarks'] = this.intimeRemarks;
    data['outtimeRemarks'] = this.outtimeRemarks;
    data['reqDate'] = this.reqDate;
    data['onDate'] = this.onDate;
    data['updationDate'] = this.updationDate;
    data['empName'] = this.empName;
    data['actualOutTime'] = this.actualOutTime;
    data['status'] = this.status;
    return data;
  }
}
