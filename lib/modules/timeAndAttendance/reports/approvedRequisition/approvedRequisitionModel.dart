class ApprovedRequisitionModel {
  List<Data>? data;

  ApprovedRequisitionModel({this.data});

  ApprovedRequisitionModel.fromJson(Map<String, dynamic> json) {
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
  String? inTime;
  String? empId;
  String? onDate;
  int? requestId;
  String? updationDate;
  String? empName;
  String? inRemarks;
  String? outRemarks;
  String? department;
  String? branch;
  String? outTime;

  Data(
      {this.inTime,
        this.empId,
        this.onDate,
        this.requestId,
        this.updationDate,
        this.empName,
        this.inRemarks,
        this.outRemarks,
        this.department,
        this.branch,
        this.outTime});

  Data.fromJson(Map<String, dynamic> json) {
    inTime = json['inTime'];
    empId = json['empId'];
    onDate = json['onDate'];
    requestId = json['requestId'];
    updationDate = json['updationDate'];
    empName = json['empName'];
    inRemarks = json['inRemarks'];
    outRemarks = json['outRemarks'];
    department = json['department'];
    branch = json['branch'];
    outTime = json['outTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['inTime'] = this.inTime;
    data['empId'] = this.empId;
    data['onDate'] = this.onDate;
    data['requestId'] = this.requestId;
    data['updationDate'] = this.updationDate;
    data['empName'] = this.empName;
    data['inRemarks'] = this.inRemarks;
    data['outRemarks'] = this.outRemarks;
    data['department'] = this.department;
    data['branch'] = this.branch;
    data['outTime'] = this.outTime;
    return data;
  }
}
