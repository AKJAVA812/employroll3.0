class PendingRequisitionModel {
  List<Data>? data;

  PendingRequisitionModel({this.data});

  PendingRequisitionModel.fromJson(Map<String, dynamic> json) {
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
  String? onDate;
  int? requestId;
  String? empName;
  String? inRemarks;
  String? outRemarks;
  String? actualInTime;
  String? actualOutTime;
  String? department;
  String? branch;
  String? outTime;

  Data(
      {this.inTime,
        this.empId,
        this.onDate,
        this.requestId,
        this.empName,
        this.inRemarks,
        this.outRemarks,
        this.actualInTime,
        this.actualOutTime,
        this.department,
        this.branch,
        this.outTime});

  Data.fromJson(Map<String, dynamic> json) {
    inTime = json['inTime'];
    empId = json['empId'];
    onDate = json['onDate'];
    requestId = json['requestId'];
    empName = json['empName'];
    inRemarks = json['inRemarks'];
    outRemarks = json['outRemarks'];
    actualInTime = json['actualInTime'];
    actualOutTime = json['actualOutTime'];
    department = json['department'];
    branch = json['branch'];
    outTime = json['outTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inTime'] = this.inTime;
    data['empId'] = this.empId;
    data['onDate'] = this.onDate;
    data['requestId'] = this.requestId;
    data['empName'] = this.empName;
    data['inRemarks'] = this.inRemarks;
    data['outRemarks'] = this.outRemarks;
    data['actualInTime'] = this.actualInTime;
    data['actualOutTime'] = this.actualOutTime;
    data['department'] = this.department;
    data['branch'] = this.branch;
    data['outTime'] = this.outTime;
    return data;
  }
}
