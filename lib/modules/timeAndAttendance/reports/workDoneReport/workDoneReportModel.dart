class WorkdoneReportModel {
  List<DataNew>? data;

  WorkdoneReportModel({this.data});

  WorkdoneReportModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataNew>[];
      json['data'].forEach((v) {
        data!.add(DataNew.fromJson(v));
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

class DataNew {
  String? date;
  String? image;
  String? cMailId;
  String? cAddress;
  String? cName;
  String? cNumber;
  String? remark;
  String? time;

  DataNew(
      {this.date,
        this.image,
        this.cMailId,
        this.cAddress,
        this.cName,
        this.cNumber,
        this.remark,
        this.time});

  DataNew.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    image = json['image'];
    cMailId = json['cMailId'];
    cAddress = json['cAddress'];
    cName = json['cName'];
    cNumber = json['cNumber'];
    remark = json['remark'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['date'] = this.date;
    data['image'] = this.image;
    data['cMailId'] = this.cMailId;
    data['cAddress'] = this.cAddress;
    data['cName'] = this.cName;
    data['cNumber'] = this.cNumber;
    data['remark'] = this.remark;
    data['time'] = this.time;
    return data;
  }
}
