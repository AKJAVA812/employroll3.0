class ExitEmpListModal {
  List<Data>? data;

  ExitEmpListModal({this.data});

  ExitEmpListModal.fromJson(Map<String, dynamic> json) {
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
  String? approveStatus;
  String? empId;
  String? resignData;
  bool? noticePayServeActive;
  String? lastworkingData;
  String? document;
  int? empdetailsId;
  String? empEmail;
  int? seprationId;
  String? devicestatus;
  bool? partialDaysActive;
  String? empDept;
  bool? initiate;
  String? empContactNo;
  String? seprationMode;
  int? partialDaysValue;
  String? empName;
  String? empPhoto;

  Data(
      {this.approveStatus,
        this.empId,
        this.resignData,
        this.noticePayServeActive,
        this.lastworkingData,
        this.document,
        this.empdetailsId,
        this.empEmail,
        this.seprationId,
        this.devicestatus,
        this.partialDaysActive,
        this.empDept,
        this.initiate,
        this.empContactNo,
        this.seprationMode,
        this.partialDaysValue,
        this.empName,
        this.empPhoto});

  Data.fromJson(Map<String, dynamic> json) {
    approveStatus = json['approveStatus'];
    empId = json['empId'];
    resignData = json['resignData'];
    noticePayServeActive = json['noticePayServeActive'];
    lastworkingData = json['lastworkingData'];
    document = json['document'];
    empdetailsId = json['empdetailsId'];
    empEmail = json['empEmail'];
    seprationId = json['seprationId'];
    devicestatus = json['devicestatus'];
    partialDaysActive = json['partialDaysActive'];
    empDept = json['empDept'];
    initiate = json['initiate'];
    empContactNo = json['empContactNo'];
    seprationMode = json['seprationMode'];
    partialDaysValue = json['partialDaysValue'];
    empName = json['empName'];
    empPhoto = json['empPhoto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['approveStatus'] = this.approveStatus;
    data['empId'] = this.empId;
    data['resignData'] = this.resignData;
    data['noticePayServeActive'] = this.noticePayServeActive;
    data['lastworkingData'] = this.lastworkingData;
    data['document'] = this.document;
    data['empdetailsId'] = this.empdetailsId;
    data['empEmail'] = this.empEmail;
    data['seprationId'] = this.seprationId;
    data['devicestatus'] = this.devicestatus;
    data['partialDaysActive'] = this.partialDaysActive;
    data['empDept'] = this.empDept;
    data['initiate'] = this.initiate;
    data['empContactNo'] = this.empContactNo;
    data['seprationMode'] = this.seprationMode;
    data['partialDaysValue'] = this.partialDaysValue;
    data['empName'] = this.empName;
    data['empPhoto'] = this.empPhoto;
    return data;
  }
}
