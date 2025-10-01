class PendingOdReqList {
  String? result;
  List<Listdata>? listdata;

  PendingOdReqList({this.result, this.listdata});

  PendingOdReqList.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    if (json['listdata'] != null) {
      listdata = <Listdata>[];
      json['listdata'].forEach((v) {
        listdata!.add(new Listdata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    return data;
  }
}
