class GeofenceListModal {
  List<Userdata>? userdata;

  GeofenceListModal({this.userdata});

  GeofenceListModal.fromJson(Map<String, dynamic> json) {
    if (json['userdata'] != null) {
      userdata = <Userdata>[];
      json['userdata'].forEach((v) {
        userdata!.add(Userdata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.userdata != null) {
      data['userdata'] = this.userdata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Userdata {
  dynamic empid;
  dynamic name;
  dynamic geofencetypename;
  dynamic locationLatitude;
  dynamic locationLongitude;
  dynamic id;
  dynamic geofencetypeid;
  dynamic radius;

  Userdata(
      {this.empid,
        this.name,
        this.geofencetypename,
        this.locationLatitude,
        this.locationLongitude,
        this.id,
        this.geofencetypeid,
        this.radius});

  Userdata.fromJson(Map<String, dynamic> json) {
    empid = json['empid'];
    name = json['name'];
    geofencetypename = json['geofencetypename'];
    locationLatitude = json['locationLatitude'];
    locationLongitude = json['locationLongitude'];
    id = json['id'];
    geofencetypeid = json['geofencetypeid'];
    radius = json['radius'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['empid'] = this.empid;
    data['name'] = this.name;
    data['geofencetypename'] = this.geofencetypename;
    data['locationLatitude'] = this.locationLatitude;
    data['locationLongitude'] = this.locationLongitude;
    data['id'] = this.id;
    data['geofencetypeid'] = this.geofencetypeid;
    data['radius'] = this.radius;
    return data;
  }
}
