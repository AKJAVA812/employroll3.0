class TimeLineModal {
  List<Data>? data;

  TimeLineModal({this.data});

  TimeLineModal.fromJson(Map<String, dynamic> json) {
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
  String? datetime;
  String? address;
  num? lng;
  String? comment;
  int? time;
  String? type;
  num? lat;

  Data(
      {this.datetime,
        this.address,
        this.lng,
        this.comment,
        this.time,
        this.type,
        this.lat});

  Data.fromJson(Map<String, dynamic> json) {
    datetime = json['datetime'];
    address = json['address'];
    lng = json['lng'];
    comment = json['comment'];
    time = json['time'];
    type = json['type'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['datetime'] = this.datetime;
    data['address'] = this.address;
    data['lng'] = this.lng;
    data['comment'] = this.comment;
    data['time'] = this.time;
    data['type'] = this.type;
    data['lat'] = this.lat;
    return data;
  }
}
