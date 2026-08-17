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
    final Map<String, dynamic> data = <String, dynamic>{};
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['approveStatus'] = approveStatus;
    data['empId'] = empId;
    data['resignData'] = resignData;
    data['noticePayServeActive'] = noticePayServeActive;
    data['lastworkingData'] = lastworkingData;
    data['document'] = document;
    data['empdetailsId'] = empdetailsId;
    data['empEmail'] = empEmail;
    data['seprationId'] = seprationId;
    data['devicestatus'] = devicestatus;
    data['partialDaysActive'] = partialDaysActive;
    data['empDept'] = empDept;
    data['initiate'] = initiate;
    data['empContactNo'] = empContactNo;
    data['seprationMode'] = seprationMode;
    data['partialDaysValue'] = partialDaysValue;
    data['empName'] = empName;
    data['empPhoto'] = empPhoto;
    return data;
  }
}
