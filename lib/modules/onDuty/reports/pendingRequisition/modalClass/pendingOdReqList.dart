class PendingOdReqList {
  String? result;
  List<Listdata>? listdata;

  PendingOdReqList({this.result, this.listdata});

  PendingOdReqList.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    if (json['listdata'] != null) {
      listdata = <Listdata>[];
      json['listdata'].forEach((v) {
        listdata!.add(Listdata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['result'] = this.result;
    if (this.listdata != null) {
      data['listdata'] = this.listdata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Listdata {
  String? date;
  String? approvaldate;
  String? image;
  String? odtime;
  double? lng;
  String? approvalstatus;
  String? odaddress;
  String? name;
  String? id;
  String? odtype;
  double? lat;
  String? remark;
  String? branch;
  String? requestType;
  int? currentLevel;
  int? totalLevels;

  Listdata(
      {this.date,
        this.approvaldate,
        this.image,
        this.odtime,
        this.lng,
        this.approvalstatus,
        this.odaddress,
        this.name,
        this.id,
        this.odtype,
        this.lat,
        this.remark});

  Listdata.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    approvaldate = json['approvaldate'];
    image = json['image'];
    odtime = json['odtime'];
    lng = json['lng'];
    approvalstatus = json['approvalstatus'];
    odaddress = json['odaddress'];
    name = json['name'];
    id = json['id'];
    odtype = json['odtype'];
    lat = json['lat'];
    remark = json['Remark'];
    branch = json['branch'];
    requestType = json['requestType'];
    currentLevel = int.tryParse(
      (json['currentLevel'] ?? json['approvalLevel'] ?? json['levelNo'] ?? '')
          .toString(),
    );
    totalLevels = int.tryParse((json['totalLevels'] ?? '').toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['date'] = this.date;
    data['approvaldate'] = this.approvaldate;
    data['image'] = this.image;
    data['odtime'] = this.odtime;
    data['lng'] = this.lng;
    data['approvalstatus'] = this.approvalstatus;
    data['odaddress'] = this.odaddress;
    data['name'] = this.name;
    data['id'] = this.id;
    data['odtype'] = this.odtype;
    data['lat'] = this.lat;
    data['Remark'] = this.remark;
    data['branch'] = this.branch;
    data['requestType'] = this.requestType;
    data['currentLevel'] = this.currentLevel;
    data['totalLevels'] = this.totalLevels;
    return data;
  }
}
