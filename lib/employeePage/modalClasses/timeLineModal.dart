class TimeLineModal {
  List<Data>? data;

  TimeLineModal({this.data});

  TimeLineModal.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['datetime'] = datetime;
    data['address'] = address;
    data['lng'] = lng;
    data['comment'] = comment;
    data['time'] = time;
    data['type'] = type;
    data['lat'] = lat;
    return data;
  }
}
