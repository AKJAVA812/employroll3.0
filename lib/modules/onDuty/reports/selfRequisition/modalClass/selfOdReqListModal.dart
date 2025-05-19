class SelfOdReqListModal {
  String? result;
  List<Listdata>? listdata;

  SelfOdReqListModal({this.result, required this.listdata});

  SelfOdReqListModal.fromJson(Map<String, dynamic> json) {
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
  String? image;
  String? odtime;
  String? odStatus;
  double? lng;
  String? approvalstatus;
  String? odaddress;
  String? odtype;
  String? remark;
  String? approvaldate;
  String? name;
  String? id;
  double? lat;

  Listdata(
      {this.date,
        this.image,
        this.odtime,
        this.odStatus,
        this.lng,
        this.approvalstatus,
        this.odaddress,
        this.odtype,
        this.remark,
        this.approvaldate,
        this.name,
        this.id,
        this.lat});

   Listdata.fromJson(Map<String, dynamic> json) {

     /* date: json['date'] == null ? null: json['date'],
        image: json['image'] == null ? null: json['image'],
        odtime: json['odtime'] == null ? null: json['odtime'],
        odStatus: json['odStatus'] == null ? null: json['odStatus'],
        lng: json['lng'] == null ? null: json['lng'],
        approvalstatus: json['approvalstatus'] == null ? null: json['approvalstatus'],
        odaddress: json['odaddress'] == null ? null: json['odaddress'],
        odtype: json['odtype'] == null ? null: json['odtype'],
        remark: json['remark'] == null ? null: json['remark'],
        approvaldate: json['approvaldate'] == null ? null: json['approvaldate'],
        name: json['name'] == null ? null: json['name'],
        id: json['id'] == null ? null: json['id'],
        lat: json['lat'] == null ? null: json['lat'],*/
        date = json['date'];
        image = json['image'];
        odtime = json['odtime'];
        odStatus = json['odStatus'];
        lng = json['lng'];
        approvalstatus = json['approvalstatus'];
        odaddress = json['odaddress'];
        odtype = json['odtype'];
        remark = json['Remark'];
        approvaldate = json['approvaldate'];
        name = json['name'] ;
        id = json['id'];
        lat = json['lat'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['image'] = this.image;
    data['odtime'] = this.odtime;
    data['odStatus'] = this.odStatus;
    data['lng'] = this.lng;
    data['approvalstatus'] = this.approvalstatus;
    data['odaddress'] = this.odaddress;
    data['odtype'] = this.odtype;
    data['Remark'] = this.remark;
    data['approvaldate'] = this.approvaldate;
    data['name'] = this.name;
    data['id'] = this.id;
    data['lat'] = this.lat;
    return data;
  }
}
