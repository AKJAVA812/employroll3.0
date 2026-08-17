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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    if (listdata != null) {
      data['listdata'] = listdata!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['approvaldate'] = approvaldate;
    data['image'] = image;
    data['odtime'] = odtime;
    data['lng'] = lng;
    data['approvalstatus'] = approvalstatus;
    data['odaddress'] = odaddress;
    data['name'] = name;
    data['id'] = id;
    data['odtype'] = odtype;
    data['lat'] = lat;
    data['Remark'] = remark;
    data['branch'] = branch;
    data['requestType'] = requestType;
    data['currentLevel'] = currentLevel;
    data['totalLevels'] = totalLevels;
    return data;
  }
}
